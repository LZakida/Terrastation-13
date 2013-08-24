//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.


/obj/machinery/r_n_d
	name = "R&D Device"
	density = 1
	anchored = 1
	use_power = 1
	var
		busy = 0
		hacked = 0
		disabled = 0
		shocked = 0
		list/wires = list()
		hack_wire
		disable_wire
		shock_wire
		opened = 0
		obj/machinery/computer/rdconsole/linked_console

	New()
		..()
		wires["Red"] = 0
		wires["Blue"] = 0
		wires["Green"] = 0
		wires["Yellow"] = 0
		wires["Black"] = 0
		wires["White"] = 0
		var/list/w = list("Red","Blue","Green","Yellow","Black","White")
		src.hack_wire = pick(w)
		w -= src.hack_wire
		src.shock_wire = pick(w)
		w -= src.shock_wire
		src.disable_wire = pick(w)
		w -= src.disable_wire

	proc
		shock(mob/user, prb)
			if (stat & (BROKEN|NOPOWER))		// unpowered, no shock
				return 0
			if (!prob(prb))
				return 0
			var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
			s.set_up(5, 1, src)
			s.start()
			if (electrocute_mob(user, get_area(src), src, 0.7))
				return 1
			else
				return 0

	attack_hand(mob/user as mob)
		if (shocked)
			shock(user,50)
		if (opened)
			var/dat as text
			dat += "[src.name] Wires:<BR>"
			for(var/wire in src.wires)
				dat += text("[wire] Wire: <A href='?src=\ref[src];wire=[wire];cut=1'>[src.wires[wire] ? "Mend" : "Cut"]</A> <A href='?src=\ref[src];wire=[wire];pulse=1'>Pulse</A><BR>")

			dat += text("The red light is [src.disabled ? "off" : "on"].<BR>")
			dat += text("The green light is [src.shocked ? "off" : "on"].<BR>")
			dat += text("The blue light is [src.hacked ? "off" : "on"].<BR>")
			user << browse("<HTML><HEAD><TITLE>[src.name] Hacking</TITLE></HEAD><BODY>[dat]</BODY></HTML>","window=hack_win")
		return


	Topic(href, href_list)
		if (..())
			return
		usr.machine = src
		src.add_fingerprint(usr)
		if (href_list["pulse"])
			var/temp_wire = href_list["wire"]
			if (!istype(usr.equipped(), /obj/item/device/multitool))
				usr << "You need a multitool!"
			else
				if (src.wires[temp_wire])
					usr << "You can't pulse a cut wire."
				else
					if (src.hack_wire == href_list["wire"])
						src.hacked = !src.hacked
						spawn(100) src.hacked = !src.hacked
					if (src.disable_wire == href_list["wire"])
						src.disabled = !src.disabled
						src.shock(usr,50)
						spawn(100) src.disabled = !src.disabled
					if (src.shock_wire == href_list["wire"])
						src.shocked = !src.shocked
						src.shock(usr,50)
						spawn(100) src.shocked = !src.shocked
		if (href_list["cut"])
			if (!istype(usr.equipped(), /obj/item/weapon/wirecutters))
				usr << "You need wirecutters!"
			else
				var/temp_wire = href_list["wire"]
				wires[temp_wire] = !wires[temp_wire]
				if (src.hack_wire == temp_wire)
					src.hacked = !src.hacked
				if (src.disable_wire == temp_wire)
					src.disabled = !src.disabled
					src.shock(usr,50)
				if (src.shock_wire == temp_wire)
					src.shocked = !src.shocked
					src.shock(usr,50)
		src.updateUsrDialog()
