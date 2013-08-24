
/obj/item/weapon/melee/chainofcommand
	name = "Chain of Command"
	desc = "The Captain is first and all other heads are last."
	icon_state = "chainofcommand"
	item_state = "chainofcommand"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 10
	throwforce = 7
	w_class = 3
	var/charges = 50.0
	var/maximum_charges = 50.0
	var/status = 1
	origin_tech = "combat=4"

/obj/item/weapon/melee/energy
	var/active = 0

// SWORD

/obj/item/weapon/melee/energy/sword
	var/color
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	origin_tech = "magnets=3;syndicate=4"

/obj/item/weapon/melee/energy/sword/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/melee/energy/sword/New()
	color = pick("red","blue","green","purple")

/obj/item/weapon/melee/energy/sword/attack_self(mob/living/user as mob)
	if ((user.mutations & CLOWN) && prob(50))
		user << "\red You accidentally cut yourself with [src]."
		user.take_organ_damage(5,5)
	active = !active
	if (active)
		force = 30
		if (istype(src,/obj/item/weapon/melee/energy/sword/pirate))
			icon_state = "cutlass1"
		else
			icon_state = "sword[color]"
		w_class = 4
		playsound(user, 'saberon.ogg', 50, 1)
		user << "\blue [src] is now active."
	else
		force = 3
		if (istype(src,/obj/item/weapon/melee/energy/sword/pirate))
			icon_state = "cutlass0"
		else
			icon_state = "sword0"
		w_class = 2
		playsound(user, 'saberoff.ogg', 50, 1)
		user << "\blue [src] can now be concealed."
	add_fingerprint(user)
	return

/obj/item/weapon/melee/energy/sword/green
	New()
		color = "green"

/obj/item/weapon/melee/energy/sword/red
	New()
		color = "red"

/obj/item/weapon/melee/energy/sword/chainsword
	color = "chain"
	New()
		return

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

// BLADE
//Most of the other special functions are handled in their own files.

/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 70.0//Normal attacks deal very high damage.
	throwforce = 1//Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = 4.0//So you can't hide it in your pocket or some such.
	flags = FPRINT | TABLEPASS | NOSHIELD
	var/datum/effects/system/spark_spread/spark_system

/obj/item/weapon/melee/energy/blade/New()
	spark_system = new /datum/effects/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	return

/obj/item/weapon/melee/energy/blade/dropped()
	del(src)
	return

/obj/item/weapon/melee/energy/blade/proc/throw()
	del(src)
	return

// AXE

/obj/item/weapon/melee/energy/axe
	name = "Axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	force = 40.0
	throwforce = 25.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | CONDUCT | NOSHIELD | TABLEPASS
	origin_tech = "combat=3"

/obj/item/weapon/melee/energy/axe/attack(target as mob, mob/user as mob)
	..()

/obj/item/weapon/melee/energy/axe/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "\blue The axe is now energised."
		src.force = 150
		src.icon_state = "axe1"
		src.w_class = 5
	else
		user << "\blue The axe can now be concealed."
		src.force = 40
		src.icon_state = "axe0"
		src.w_class = 5
	src.add_fingerprint(user)
	return

// STUN BATON

/obj/item/weapon/melee/baton
	name = "Stun Baton"
	desc = "A stun baton for hitting people with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 10
	throwforce = 7
	w_class = 3
	var/charges = 10.0
	var/maximum_charges = 10.0
	var/status = 0
	origin_tech = "combat=2"

/obj/item/weapon/melee/baton/update_icon()
	if (src.status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"

/obj/item/weapon/melee/baton/attack_self(mob/user as mob)
	src.status = !( src.status )
	if ((usr.mutations & CLOWN) && prob(50))
		usr << "\red You grab the stunbaton on the wrong side."
		usr.paralysis += 60
		return
	if (src.status)
		user << "\blue The baton is now on."
		playsound(src.loc, "sparks", 75, 1, -1)
	else
		user << "\blue The baton is now off."
		playsound(src.loc, "sparks", 75, 1, -1)

	update_icon()
	src.add_fingerprint(user)
	return

/obj/item/weapon/melee/baton/attack(mob/M as mob, mob/user as mob)
	if ((usr.mutations & CLOWN) && prob(50))
		usr << "\red You grab the stunbaton on the wrong side."
		usr.weakened += 30
		return
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = M

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey]) (INTENT: [uppertext(user.a_intent)])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey]) (INTENT: [uppertext(user.a_intent)])</font>")

	if (isrobot(M))
		..()
		return

	if (status == 0 || (status == 1 && charges ==0))
		if (user.a_intent == "hurt")
			if (!..()) return
			if (M.weakened < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened = 5
			for(var/mob/O in viewers(M))
				if (O.client)	O.show_message("\red <B>[M] has been beaten with the stun baton by [user]!</B>", 1)
			if (status == 1 && charges == 0)
				user << "\red Not enough charge"
			return
		else
			for(var/mob/O in viewers(M))
				if (O.client)	O.show_message("\red <B>[M] has been prodded with the stun baton by [user]! Luckily it was off.</B>", 1)
			if (status == 1 && charges == 0)
				user << "\red Not enough charge"
			return
	if ((charges > 0 && status == 1) && (istype(H, /mob/living/carbon)))
		flick("baton_active", src)
		if (user.a_intent == "hurt")
			if (!..()) return
			playsound(src.loc, 'Genhit.ogg', 50, 1, -1)
			if (isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 20
			else
				charges--
			if (M.weakened < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened = 1
			if (M.stuttering < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stuttering = 1
			if (M.stunned < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stunned = 1
		else
			playsound(src.loc, 'Egloves.ogg', 50, 1, -1)
			if (isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 20
			else
				charges--
			if (M.weakened < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened = 10
			if (M.stuttering < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stuttering = 10
			if (M.stunned < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stunned = 10
			user.lastattacked = M
			M.lastattacker = user
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the stun baton by [user]!</B>", 1, "\red You hear someone fall", 2)

/obj/item/weapon/melee/baton/emp_act(severity)
	switch(severity)
		if (1)
			src.charges = 0
		if (2)
			charges -= 5

/obj/item/weapon/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 10

/obj/item/weapon/melee/classic_baton/attack(mob/M as mob, mob/living/user as mob)
	if ((user.mutations & CLOWN) && prob(50))
		user << "\red You club yourself over the head."
		user.weakened = max(3 * force, user.weakened)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			H.TakeDamage("head", 2 * force, 0)
		else
			user.take_organ_damage(2*force)
		return
	src.add_fingerprint(user)

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	if (user.a_intent == "hurt")
		if (!..()) return
		playsound(src.loc, "swing_hit", 50, 1, -1)
		if (M.weakened < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.weakened = 8
		if (M.stuttering < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stuttering = 8
		if (M.stunned < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stunned = 8
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been beaten with the police baton by [user]!</B>", 1, "\red You hear someone fall", 2)
	else
		playsound(src.loc, 'Genhit.ogg', 50, 1, -1)
		if (M.weakened < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.weakened = 5
		if (M.stunned < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stunned = 5
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the police baton by [user]!</B>", 1, "\red You hear someone fall", 2)