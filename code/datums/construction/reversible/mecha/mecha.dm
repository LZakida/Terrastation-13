
/datum/construction/reversible/mecha/custom_action(index as num, diff as num, atom/used_atom, mob/user as mob)
	if (istype(used_atom, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/W = used_atom
		if (W:remove_fuel(0, user))
			playsound(holder, 'Welder2.ogg', 50, 1)
		else
			return 0
	else if (istype(used_atom, /obj/item/weapon/wrench))
		playsound(holder, 'Ratchet.ogg', 50, 1)

	else if (istype(used_atom, /obj/item/weapon/wirecutters))
		playsound(holder, 'Wirecutter.ogg', 50, 1)

	else if (istype(used_atom, /obj/item/cable_coil))
		var/obj/item/cable_coil/C = used_atom
		if (C.amount<4)
			user << ("There's not enough cable to finish the task.")
			return 0
		else
			C.use(4)
	else if (istype(used_atom, /obj/item/stack))
		var/obj/item/stack/S = used_atom
		if (S.amount < 5)
			user << ("There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1