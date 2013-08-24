
/obj/table
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'structures.dmi'
	icon_state = "table"
	density = 1
	anchored = 1.0
	layer = 2.8

/obj/table/New()
	..()
	for(var/obj/table/T in src.loc)
		if (T != src)
			del(T)
	update_icon()
	for(var/direction in list(1,2,4,8,5,6,9,10))
		if (locate(/obj/table,get_step(src,direction)))
			var/obj/table/T = locate(/obj/table,get_step(src,direction))
			T.update_icon()

/obj/table/Del()
	for(var/direction in list(1,2,4,8,5,6,9,10))
		if (locate(/obj/table,get_step(src,direction)))
			var/obj/table/T = locate(/obj/table,get_step(src,direction))
			T.update_icon()
	..()

/obj/table/update_icon()
	spawn(2) //So it properly updates when deleting
		var/dir_sum = 0
		for(var/direction in cardinal)
			var/skip_sum = 0
			for(var/obj/structure/window/W in src.loc)
				if (W.dir == direction) //So smooth tables don't go smooth through windows
					skip_sum = 1
					continue
			var/inv_direction //inverse direction
			switch(direction)
				if (1)
					inv_direction = 2
				if (2)
					inv_direction = 1
				if (4)
					inv_direction = 8
				if (8)
					inv_direction = 4
			for(var/obj/structure/window/W in get_step(src,direction))
				if (W.dir == inv_direction) //So smooth tables don't go smooth through windows when the window is on the other table's tile
					skip_sum = 1
					continue
			if (!skip_sum) //means there is a window between the two tiles in this direction
				if (locate(/obj/table,get_step(src,direction)))
					dir_sum += direction

		//dir_sum:
		//  1,2,4,8 = endtable
		//  3,12 = streight 1 tile thick table
		//  5,6,9,10 = corner, if it finds a table in get_step(src,dir_sum) then it's a full corner table, else it's a 1 tile chick corner table
		//  7,11,13,14 = three way intersection = full side table piece (north ,south, east or west)
		//  15 = four way intersection = center (aka middle) table piece
		//
		//table_type:
		//  0 = stand-alone table
		//  1 = end table (1 tile thick, 1 connection)
		//  2 = 1 tile thick table (1 tile thick, 2 connections)
		//  3 = full table (full, 3 connections)
		//  4 = middle table (full, 4 connections)

		var/table_type = 0 //stand_alone table
		if (dir_sum in cardinal)
			table_type = 1 //endtable
		if (dir_sum in list(3,12))
			table_type = 2 //1 tile thick, streight table
			if (dir_sum == 3) //3 doesn't exist as a dir
				dir_sum = 2
			if (dir_sum == 12) //12 doesn't exist as a dir.
				dir_sum = 4
		if (dir_sum in list(5,6,9,10))
			if (locate(/obj/table,get_step(src.loc,dir_sum)))
				table_type = 3 //full table (not the 1 tile thick one, but one of the 'tabledir' tables)
			else
				table_type = 2 //1 tile thick, corner table (treated the same as streight tables in code later on)
		if (dir_sum in list(13,14,7,11)) //Three-way intersection
			table_type = 3 //full table as three-way intersections are not sprited, would require 64 sprites to handle all combinations
			switch(dir_sum)
				if (7)
					dir_sum = 4
				if (11)
					dir_sum = 8
				if (13)
					dir_sum = 1
				if (14)
					dir_sum = 2 //These translate the dir_sum to the correct dirs from the 'tabledir' icon_state.
		if (dir_sum == 15)
			table_type = 4 //4-way intersection, the 'middle' table sprites will be used.

		if (istype(src,/obj/table/reinforced))
			switch(table_type)
				if (0)
					icon_state = "reinf_table"
				if (1)
					icon_state = "reinf_1tileendtable"
				if (2)
					icon_state = "reinf_1tilethick"
				if (3)
					icon_state = "reinf_tabledir"
				if (4)
					icon_state = "reinf_middle"
		else if (istype(src,/obj/table/woodentable))
			switch(table_type)
				if (0)
					icon_state = "wood_table"
				if (1)
					icon_state = "wood_1tileendtable"
				if (2)
					icon_state = "wood_1tilethick"
				if (3)
					icon_state = "wood_tabledir"
				if (4)
					icon_state = "wood_middle"
		else
			switch(table_type)
				if (0)
					icon_state = "table"
				if (1)
					icon_state = "table_1tileendtable"
				if (2)
					icon_state = "table_1tilethick"
				if (3)
					icon_state = "tabledir"
				if (4)
					icon_state = "table_middle"
		if (dir_sum in list(1,2,4,8,5,6,9,10))
			dir = dir_sum
		else
			dir = 2

/obj/table/ex_act(severity)
	switch(severity)
		if (1.0)
			del(src)
			return
		if (2.0)
			if (prob(50))
				del(src)
				return
		if (3.0)
			if (prob(25))
				src.density = 0
		else
	return


/obj/table/blob_act()
	if (prob(75))
		if (istype(src, /obj/table/woodentable))
			new /obj/item/weapon/table_parts/wood( src.loc )
			del(src)
			return
		new /obj/item/weapon/table_parts( src.loc )
		del(src)
		return


/obj/table/hand_p(mob/user as mob)
	return src.attack_paw(user)
	return


/obj/table/attack_paw(mob/user as mob)
	if ((usr.mutations & HULK))
		usr << text("\blue You destroy the table.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] smashes the table apart!", usr)
		if (istype(src, /obj/table/reinforced))
			new /obj/item/weapon/table_parts/reinforced( src.loc )
		else if (istype(src, /obj/table/woodentable))
			new/obj/item/weapon/table_parts/wood( src.loc )
		else
			new /obj/item/weapon/table_parts( src.loc )
		src.density = 0
		del(src)
	if (!( locate(/obj/table, user.loc) ))
		step(user, get_dir(user, src))
		if (user.loc == src.loc)
			user.layer = TURF_LAYER
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("[] hides under the table!", user)
				//Foreach goto(69)
	return


/obj/table/attack_alien(mob/user as mob) //Removed code for larva since it doesn't work. Previous code is now a larva ability. /N
	usr << text("\green You destroy the table.")
	for(var/mob/O in oviewers())
		if ((O.client && !( O.blinded )))
			O << text("\red [] slices the table apart!", user)
	if (istype(src, /obj/table/reinforced))
		new /obj/item/weapon/table_parts/reinforced( src.loc )
	else if (istype(src, /obj/table/woodentable))
		new/obj/item/weapon/table_parts/wood( src.loc )
	else
		new /obj/item/weapon/table_parts( src.loc )
	src.density = 0
	del(src)
	return


/obj/table/attack_hand(mob/user as mob)
	if ((usr.mutations & HULK))
		usr << text("\blue You destroy the table.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] smashes the table apart!", usr)
		if (istype(src, /obj/table/reinforced))
			new /obj/item/weapon/table_parts/reinforced( src.loc )
		else if (istype(src, /obj/table/woodentable))
			new/obj/item/weapon/table_parts/wood( src.loc )
		else
			new /obj/item/weapon/table_parts( src.loc )
		src.density = 0
		del(src)
	return


/obj/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (air_group || (height==0)) return 1

	if (istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0


/obj/table/MouseDrop_T(obj/O as obj, mob/user as mob)

	if ((!( istype(O, /obj/item/weapon) ) || user.equipped() != O))
		return
	if (isrobot(user))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return


/obj/table/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if (G.state<2)
			user << "\red You need a better grip to do that!"
			return
		G.affecting.loc = src.loc
		G.affecting.weakened = 5
		for(var/mob/O in viewers(world.view, src))
			if (O.client)
				O << text("\red [] puts [] on the table.", G.assailant, G.affecting)
		del(W)
		return

	if (istype(W, /obj/item/weapon/wrench))
		user << "\blue Now disassembling table"
		playsound(src.loc, 'Ratchet.ogg', 50, 1)
		sleep(50)
		new /obj/item/weapon/table_parts( src.loc )
		playsound(src.loc, 'Deconstruct.ogg', 50, 1)
		//SN src = null
		del(src)
		return

	if (isrobot(user))
		return

	if (istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effects/system/spark_spread/spark_system = new /datum/effects/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		for(var/mob/O in viewers(user, 4))
			O.show_message(text("\blue The table was sliced apart by []!", user), 1, text("\red You hear metal coming apart."), 2)
		new /obj/item/weapon/table_parts( src.loc )
		del(src)
		return

	user.drop_item()
	if (W && W.loc)	W.loc = src.loc
	return
