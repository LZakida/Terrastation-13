
/datum/construction/mecha/honker_chassis
	steps = list(list("key"="/obj/item/mecha_parts/part/honker_torso"),//1
					 list("key"="/obj/item/mecha_parts/part/honker_left_arm"),//2
					 list("key"="/obj/item/mecha_parts/part/honker_right_arm"),//3
					 list("key"="/obj/item/mecha_parts/part/honker_left_leg"),//4
					 list("key"="/obj/item/mecha_parts/part/honker_right_leg"),//5
					 list("key"="/obj/item/mecha_parts/part/honker_head")
					)

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		del used_atom
		return 1

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/mecha/honker(const_holder)
		const_holder.density = 1
		spawn()
			del src
		return