
/obj/item/weapon/tank
	name = "tank"
	icon = 'tank.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT | ONBACK
	pressure_resistance = ONE_ATMOSPHERE*5
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4
	var
		volume = 70
		datum/gas_mixture/air_contents = null
		distribute_pressure = ONE_ATMOSPHERE

	New()
		..()
		src.air_contents = new /datum/gas_mixture()
		src.air_contents.volume = volume //liters
		src.air_contents.temperature = T20C
		processing_objects.Add(src)
		return

	Del()
		if (air_contents)
			del(air_contents)
		processing_objects.Remove(src)
		..()

	examine()
		var/obj/icon = src
		if (istype(src.loc, /obj/item/assembly))
			icon = src.loc
		if (!in_range(src, usr))
			if (icon == src) usr << "\blue It's \a \icon[icon][src]! If you want any more information you'll need to get closer."
			return
		var/celsius_temperature = src.air_contents.temperature-T0C
		var/descriptive
		if (celsius_temperature < 20)
			descriptive = "cold"
		else if (celsius_temperature < 40)
			descriptive = "room temperature"
		else if (celsius_temperature < 80)
			descriptive = "lukewarm"
		else if (celsius_temperature < 100)
			descriptive = "warm"
		else if (celsius_temperature < 300)
			descriptive = "hot"
		else
			descriptive = "furiously hot"
		usr << text("\blue \The \icon[][src] feels []", icon, descriptive)
		return

	blob_act()
		if (prob(50))
			var/turf/location = src.loc
			if (!( istype(location, /turf) ))
				del(src)
			if (src.air_contents)
				location.assume_air(air_contents)
			del(src)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		var/obj/icon = src
		if (istype(src.loc, /obj/item/assembly))
			icon = src.loc
		if ((istype(W, /obj/item/device/analyzer) || (istype(W, /obj/item/device/pda))) && get_dist(user, src) <= 1)

			for (var/mob/O in viewers(user, null))
				O << "\red [user] has used [W] on \icon[icon] [src]"
			var/pressure = air_contents.return_pressure()
			var/total_moles = air_contents.total_moles()
			user << "\blue Results of analysis of \icon[icon]"
			if (total_moles>0)
				var/o2_concentration = air_contents.oxygen/total_moles
				var/n2_concentration = air_contents.nitrogen/total_moles
				var/co2_concentration = air_contents.carbon_dioxide/total_moles
				var/plasma_concentration = air_contents.toxins/total_moles
				var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+plasma_concentration)
				user << "\blue Pressure: [round(pressure,0.1)] kPa"
				user << "\blue Nitrogen: [round(n2_concentration*100)]%"
				user << "\blue Oxygen: [round(o2_concentration*100)]%"
				user << "\blue CO2: [round(co2_concentration*100)]%"
				user << "\blue Plasma: [round(plasma_concentration*100)]%"
				if (unknown_concentration>0.01)
					user << "\red Unknown: [round(unknown_concentration*100)]%"
				user << "\blue Temperature: [round(air_contents.temperature-T0C)]&deg;C"
			else
				user << "\blue Tank is empty!"
			src.add_fingerprint(user)
		else if (istype(W,/obj/item/latexballon))
			var/obj/item/latexballon/LB = W
			LB.blow(src)
			src.add_fingerprint(user)
		return

	attack_self(mob/user as mob)
		if (!(src.air_contents))
			return
		user.machine = src
		var/using_internal
		if (istype(loc,/mob/living/carbon))
			var/mob/living/carbon/location = loc
			if (location.internal==src)
				using_internal = 1
		var/message = {"
	<b>Tank</b><BR>
	<FONT color='blue'><b>Tank Pressure:</b> [air_contents.return_pressure()]</FONT><BR>
	<BR>
	<b>Mask Release Pressure:</b> <A href='?src=\ref[src];dist_p=-10'>-</A> <A href='?src=\ref[src];dist_p=-1'>-</A> [distribute_pressure] <A href='?src=\ref[src];dist_p=1'>+</A> <A href='?src=\ref[src];dist_p=10'>+</A><BR>
	<b>Mask Release Valve:</b> <A href='?src=\ref[src];stat=1'>[using_internal?("Open"):("Closed")]</A>
	"}
		user << browse(message, "window=tank;size=600x300")
		onclose(user, "tank")
		return

	Topic(href, href_list)
		..()
		if (usr.stat|| usr.restrained())
			return
		if (src.loc == usr)
			usr.machine = src
			if (href_list["dist_p"])
				var/cp = text2num(href_list["dist_p"])
				src.distribute_pressure += cp
				src.distribute_pressure = min(max(round(src.distribute_pressure), 0), 3*ONE_ATMOSPHERE)
			if (href_list["stat"])
				if (istype(loc,/mob/living/carbon))
					var/mob/living/carbon/location = loc
					if (location.internal == src)
						location.internal = null
						location.internals.icon_state = "internal0"
						usr << "\blue You close the tank release valve."
						if (location.internals)
							location.internals.icon_state = "internal0"
					else
						if (location.wear_mask && (location.wear_mask.flags & MASKINTERNALS))
							location.internal = src
							usr << "\blue You open \the [src] valve."
							if (location.internals)
								location.internals.icon_state = "internal1"
						else
							usr << "\blue You need something to connect to \the [src]."
			src.add_fingerprint(usr)
	/*
	 * the following is needed for a tank lying on the floor. But currently we restrict players to use not weared tanks as intrals. --rastaf
			for(var/mob/M in viewers(1, src.loc))
				if ((M.client && M.machine == src))
					src.attack_self(M)
	*/
			src.attack_self(usr)
		else
			usr << browse(null, "window=tank")
			return
		return

	remove_air(amount)
		return air_contents.remove(amount)

	return_air()
		return air_contents

	assume_air(datum/gas_mixture/giver)
		air_contents.merge(giver)

		check_status()
		return 1

	process()
		//Allow for reactions
		air_contents.react()
		check_status()

	var/integrity = 3


	proc
		remove_air_volume(volume_to_return)
			if (!air_contents)
				return null
			var/tank_pressure = air_contents.return_pressure()
			if (tank_pressure < distribute_pressure)
				distribute_pressure = tank_pressure
			var/moles_needed = distribute_pressure*volume_to_return/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
			return remove_air(moles_needed)

		check_status()
			//Handle exploding, leaking, and rupturing of the tank
			if (!air_contents)
				return 0
			var/pressure = air_contents.return_pressure()
			if (pressure > TANK_FRAGMENT_PRESSURE)
				if (!istype(src.loc,/obj/item/device/transfer_valve))
					message_admins("Explosive tank rupture! last key to touch the tank was [src.fingerprintslast].")
					log_game("Explosive tank rupture! last key to touch the tank was [src.fingerprintslast].")
				//world << "\blue[x],[y] tank is exploding: [pressure] kPa"
				//Give the gas a chance to build up more pressure through reacting
				air_contents.react()
				air_contents.react()
				air_contents.react()
				pressure = air_contents.return_pressure()
				var/range = (pressure-TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE
				range = min(range, MAX_EXPLOSION_RANGE)		// was 8 - - - Changed to a configurable define -- TLE
				var/turf/epicenter = get_turf(loc)
				//world << "\blue Exploding Pressure: [pressure] kPa, intensity: [range]"
				explosion(epicenter, round(range*0.25), round(range*0.5), round(range), round(range*1.5))
				del(src)
			else if (pressure > TANK_RUPTURE_PRESSURE)
				//world << "\blue[x],[y] tank is rupturing: [pressure] kPa, integrity [integrity]"
				if (integrity <= 0)
					loc.assume_air(air_contents)
					//TODO: make pop sound
					del(src)
				else
					integrity--
			else if (pressure > TANK_LEAK_PRESSURE)
				//world << "\blue[x],[y] tank is leaking: [pressure] kPa, integrity [integrity]"
				if (integrity <= 0)
					var/datum/gas_mixture/leaked_gas = air_contents.remove_ratio(0.25)
					loc.assume_air(leaked_gas)
				else
					integrity--
			else if (integrity < 3)
				integrity++
	/* redundant. --rastaf0
	/obj/item/weapon/tank/attack(mob/M as mob, mob/user as mob)
		..()
	*/
		/*
		if ((prob(30) && M.stat < 2))
			var/mob/living/carbon/human/H = M
	// ******* Check
			if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
				M << "\red The helmet protects you from being hit hard in the head!"
				return
			var/time = rand(2, 6)
			if (prob(90))
				if (M.paralysis < time)
					M.paralysis = time
			else
				if (M.stunned < time)
					M.stunned = time
			if (M.stat != 2)	M.stat = 1
			for(var/mob/O in viewers(M, null))
				if ((O.client && !( O.blinded )))
					O << text("\red <B>[] has been knocked unconscious!</B>", M)
		return
		*/