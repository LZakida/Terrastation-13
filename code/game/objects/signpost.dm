
/obj/signpost
	icon = 'stationobjs.dmi'
	icon_state = "signpost"
	anchored = 1
	density = 1

/obj/signpost/attackby(obj/item/weapon/W as obj, mob/user as mob)
		return attack_hand(user)

/obj/signpost/attack_hand(mob/user as mob)
	switch(alert("Travel back to ss13?",,"Yes","No"))
		if("Yes")
			if(user.z != src.z)	return
			user.loc.loc.Exited(user)
			user.loc = pick(latejoin)
		if("No")
			return