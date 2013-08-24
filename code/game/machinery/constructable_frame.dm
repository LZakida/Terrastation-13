
/*
Common Parts: Parts List: Ignitor, Timer, Infra-red laser, Infra-red sensor, t_scanner, Capacitor, Valve, sensor unit,
micro-manipulator, console screen, beaker, Microlaser, matter bin, power cells.
Note: Once everything is added to the public areas, will add m_amt and g_amt to circuit boards since autolathe won't be able
to destroy them and players will be able to make replacements.
*/

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	icon = 'stock_parts.dmi'
	icon_state = "box_0"
	density = 1
	anchored = 1
	use_power = 0
	var
		obj/item/weapon/circuitboard/circuit = null
		list/components = null
		list/req_components = null
		state = 1

/obj/machinery/constructable_frame/machine_frame
	attackby(obj/item/P as obj, mob/user as mob)
		if (P.crit_fail)
			user << "\red This part is faulty, you cannot add this to the machine!"
			return
		switch(state)
			if (1)
				if (istype(P, /obj/item/cable_coil))
					if (P:amount >= 5)
						playsound(src.loc, 'Deconstruct.ogg', 50, 1)
						user << "\blue You start to add cables to the frame."
						if (do_after(user, 20))
							P:amount -= 5
							if (!P:amount) del(P)
							user << "\blue You add cables to the frame."
							state = 2
							icon_state = "box_1"
				if (istype(P, /obj/item/weapon/wrench))
					playsound(src.loc, 'Ratchet.ogg', 75, 1)
					user << "\blue You dismantle the frame"
					new /obj/item/stack/sheet/metal(src.loc, 5)
					del(src)
			if (2)
				if (istype(P, /obj/item/weapon/circuitboard))
					var/obj/item/weapon/circuitboard/B = P
					if (B.board_type == "machine")
						playsound(src.loc, 'Deconstruct.ogg', 50, 1)
						user << "\blue You add the circuit board to the frame."
						circuit = P
						user.drop_item()
						P.loc = src
						icon_state = "box_2"
						state = 3
						components = list()
						req_components = circuit.req_components.Copy()
						for(var/A in circuit.req_components)
							req_components[A] = circuit.req_components[A]
						if (circuit.frame_desc) desc = circuit.frame_desc
					else
						user << "\red This frame does not accept circuit boards of this type!"
				if (istype(P, /obj/item/weapon/wirecutters))
					playsound(src.loc, 'wirecutter.ogg', 50, 1)
					user << "\blue You remove the cables."
					state = 1
					icon_state = "box_0"
					var/obj/item/cable_coil/A = new /obj/item/cable_coil( src.loc )
					A.amount = 5

			if (3)
				if (istype(P, /obj/item/weapon/crowbar))
					playsound(src.loc, 'Crowbar.ogg', 50, 1)
					state = 2
					circuit.loc = src.loc
					circuit = null
					if (components.len == 0)
						user << "\blue You remove the circuit board."
					else
						user << "\blue You remove the circuit board and other components."
						for(var/obj/item/weapon/W in components)
							W.loc = src.loc
					desc = initial(desc)
					req_components = null
					components = null
					icon_state = "box_1"

				if (istype(P, /obj/item/weapon/screwdriver))
					var/component_check = 1
					for(var/R in req_components)
						if (req_components[R] > 0)
							component_check = 0
							break
					if (component_check)
						playsound(src.loc, 'Screwdriver.ogg', 50, 1)
						var/obj/machinery/new_machine = new src.circuit.build_path(src.loc)
						for(var/obj/O in new_machine.component_parts)
							del(O)
						new_machine.component_parts = list()
						for(var/obj/O in src)
							O.loc = new_machine
							new_machine.component_parts += O
						circuit.loc = new_machine
						new_machine.RefreshParts()
						del(src)

				if (istype(P, /obj/item/weapon))
					for(var/I in req_components)
						if (istype(P, text2path(I)) && (req_components[I] > 0))
							if (istype(P, /obj/item/cable_coil))
								var/obj/item/cable_coil/CP = P
								if (CP.amount > 1)
									var/obj/item/cable_coil/CC = new /obj/item/cable_coil(src)
									CC.amount = 1
									components += CC
									req_components[I]--
									break
							user.drop_item()
							P.loc = src
							components += P
							req_components[I]--
							break
					if (P.loc != src && !istype(P, /obj/item/cable_coil))
						user << "\red You cannot add that component to the machine!"
