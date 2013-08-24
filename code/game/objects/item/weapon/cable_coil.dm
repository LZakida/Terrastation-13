
// the cable coil object, used for laying cable

#define MAXCOIL 30

/obj/item/cable_coil
	name = "cable coil"
	icon = 'power.dmi'
	icon_state = "coil_red"
	var/amount = MAXCOIL
	var/color = "red"
	desc = "A coil of power cable."
	throwforce = 10
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	flags = TABLEPASS|USEDELAY|FPRINT|CONDUCT
	item_state = "coil_red"

	New(loc, length = MAXCOIL, var/param_color = null)
		..()
		src.amount = length
		if (param_color)
			color = param_color
		pixel_x = rand(-2,2)
		pixel_y = rand(-2,2)
		updateicon()

	examine()
		set src in view(1)

		if (amount == 1)
			usr << "A short piece of power cable."
		else if (amount == 2)
			usr << "A piece of power cable."
		else
			usr << "A coil of power cable. There are [amount] lengths of cable in the coil."

	attackby(obj/item/weapon/W, mob/user)
		..()
		if ( istype(W, /obj/item/weapon/wirecutters) && src.amount > 1)
			src.amount--
			new/obj/item/cable_coil(user.loc, 1,color)
			user << "You cut a piece off the cable coil."
			src.updateicon()
			return
		else if ( istype(W, /obj/item/cable_coil) )
			var/obj/item/cable_coil/C = W
			if (C.amount == MAXCOIL)
				user << "The coil is too long, you cannot add any more cable to it."
				return
			if ( (C.amount + src.amount <= MAXCOIL) )
				C.amount += src.amount
				user << "You join the cable coils together."
				C.updateicon()
				del(src)
				return
			else
				user << "You transfer [MAXCOIL - src.amount ] length\s of cable from one coil to the other."
				src.amount -= (MAXCOIL-C.amount)
				src.updateicon()
				C.amount = MAXCOIL
				C.updateicon()
				return

	proc
		updateicon()
			if (!color)
				color = pick("red", "yellow", "blue", "green")
			if (amount == 1)
				icon_state = "coil_[color]1"
				name = "cable piece"
			else if (amount == 2)
				icon_state = "coil_[color]2"
				name = "cable piece"
			else
				icon_state = "coil_[color]"
				name = "cable coil"


		use(var/used)
			if (src.amount < used)
				return 0
			else if (src.amount == used)
				del(src)
			else
				amount -= used
				updateicon()
				return 1

	// called when cable_coil is clicked on a turf/simulated/floor
		turf_place(turf/simulated/floor/F, mob/user)
			if (!isturf(user.loc))
				return
			if (get_dist(F,user) > 1)
				user << "You can't lay cable at a place that far away."
				return
			if (F.intact)		// if floor is intact, complain
				user << "You can't lay cable there unless the floor tiles are removed."
				return
			else
				var/dirn
				if (user.loc == F)
					dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
				else
					dirn = get_dir(F, user)
				for(var/obj/cable/LC in F)
					if ((LC.d1 == dirn && LC.d2 == 0 ) || ( LC.d2 == dirn && LC.d1 == 0))
						user << "There's already a cable at that position."
						return
				var/obj/cable/C = new(F)
				C.cableColor(color)
				C.d1 = 0
				C.d2 = dirn
				C.add_fingerprint(user)
				C.updateicon()
				var/datum/powernet/PN = new()
				PN.number = powernets.len + 1
				powernets += PN
				C.netnum = PN.number
				PN.cables += C
				C.mergeConnectedNetworks(C.d2)
				C.mergeConnectedNetworksOnTurf()
				use(1)
				if (C.shock(user, 50))
					if (prob(50)) //fail
						new/obj/item/cable_coil(C.loc, 1, C.color)
						del(C)
				//src.laying = 1
				//last = C


	// called when cable_coil is click on an installed obj/cable
		cable_join(obj/cable/C, mob/user)
			var/turf/U = user.loc
			if (!isturf(U))
				return
			var/turf/T = C.loc
			if (!isturf(T) || T.intact)		// sanity checks, also stop use interacting with T-scanner revealed cable
				return
			if (get_dist(C, user) > 1)		// make sure it's close enough
				user << "You can't lay cable at a place that far away."
				return
			if (U == T)		// do nothing if we clicked a cable we're standing on
				return		// may change later if can think of something logical to do
			var/dirn = get_dir(C, user)
			if (C.d1 == dirn || C.d2 == dirn)		// one end of the clicked cable is pointing towards us
				if (U.intact)						// can't place a cable if the floor is complete
					user << "You can't lay cable there unless the floor tiles are removed."
					return
				else
					// cable is pointing at us, we're standing on an open tile
					// so create a stub pointing at the clicked cable on our tile
					var/fdirn = turn(dirn, 180)		// the opposite direction
					for(var/obj/cable/LC in U)		// check to make sure there's not a cable there already
						if (LC.d1 == fdirn || LC.d2 == fdirn)
							user << "There's already a cable at that position."
							return
					var/obj/cable/NC = new(U)
					NC.cableColor(color)
					NC.d1 = 0
					NC.d2 = fdirn
					NC.add_fingerprint()
					NC.updateicon()
					NC.netnum = C.netnum
					var/datum/powernet/PN = powernets[C.netnum]
					PN.cables += NC
					NC.mergeConnectedNetworks(NC.d2)
					NC.mergeConnectedNetworksOnTurf()
					use(1)
					if (NC.shock(user, 50))
						if (prob(50)) //fail
							new/obj/item/cable_coil(NC.loc, 1, NC.color)
							del(NC)
					return
			else if (C.d1 == 0)		// exisiting cable doesn't point at our position, so see if it's a stub
									// if so, make it a full cable pointing from it's old direction to our dirn
				var/nd1 = C.d2	// these will be the new directions
				var/nd2 = dirn
				if (nd1 > nd2)		// swap directions to match icons/states
					nd1 = dirn
					nd2 = C.d2
				for(var/obj/cable/LC in T)		// check to make sure there's no matching cable
					if (LC == C)			// skip the cable we're interacting with
						continue
					if ((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
						user << "There's already a cable at that position."
						return
				C.cableColor(color)
				C.d1 = nd1
				C.d2 = nd2
				C.add_fingerprint()
				C.updateicon()
				C.mergeConnectedNetworks(C.d1)
				C.mergeConnectedNetworks(C.d2)
				C.mergeConnectedNetworksOnTurf()
				use(1)
				if (C.shock(user, 50))
					if (prob(50)) //fail
						new/obj/item/cable_coil(C.loc, 2, C.color)
						del(C)
				return

/obj/item/cable_coil/cut
	item_state = "coil_red2"

	New(loc)
		..()
		src.amount = rand(1,2)
		pixel_x = rand(-2,2)
		pixel_y = rand(-2,2)
		updateicon()

/obj/item/cable_coil/yellow
	color = "yellow"
	icon_state = "coil_yellow"

/obj/item/cable_coil/blue
	color = "blue"
	icon_state = "coil_blue"

/obj/item/cable_coil/green
	color = "green"
	icon_state = "coil_green"