//This file is for miscellaneous 3spoopy5me whatevershit that adds to the lore of our build in some way
//Gonna be full of random fluffy shit. Things that actually function are probably going to be in different places.


//noticeboard on geostation
/obj/structure/noticeboard/geostation
	notices = 5
	icon_state = "nboard05"

/obj/structure/noticeboard/geostation/New()
	var/obj/item/weapon/stamp/rd/stamp = new
	//add some memos
	var/obj/item/weapon/paper/P = new()
	P.name = "Standard Shit, DO NOT REMOVE"
	P.info = "<br>Welcome to The Geostation. <br> There are a couple rules everyone must abide by. Failure to adhere to these rules will result in a write-up. Not trying to be a prick, but I need to impress on you all how serious you need to take your work.<br>1. Do not force the airlocks. Ever. There is no properly functioning atmos system on-board and canister shipments are few and far between. Wasting air is a huge no-no. <br>2.Do not carry any radio device that is set to our frequency out with you. This includes headsets. If you need to make a call out in the field, set the correct frequency to broadcast, and then set it back.<br>3. Do not leave the station without a kinetic accelerator on your person. You are difficult and expensive to replace. You are also expensive and time-consuming to recover in the event you die outside. <br>4. If you have a personality conflict with any of your partners, make a note in writing when you file your paperwork. All employees stationed here should know what company policy is for such events, and as such will not be posted here."
	P.stamp(stamp)
	src.contents += P

	P = new()
	P.name = "Notice regarding the recent shipment - DO NOT REMOVE"
	P.info = "Yes, I understand saying \"recent\" will stop being accurate over the long term. <br><br>As you all probably know by now, this outpost has recently been shipped a stock of industrial explosives. To be perfectly clear, these ARE NOT for mining purposes. These are for the exact opposite. Due to a recent sighting of abnormal xeno behavior in your sector, it has been decided that it may in the future become necessary to deny hostile lifeforms access to the facility. The bundle has instructions on how to utilize these explosives safely and effectively. In addition, all crewmembers are being assigned a service weapon that they must carry on them at all times. IT IS IMPORTANT THAT YOU DO NOT ASSUME THIS WEAPON CAN REPLACE YOUR KINETIC ACCELERATORS. The weapons you each will be assigned are NOT effective on the native wildlife whereas the kinetic accelerators ARE."
	P.stamp(stamp)
	src.contents += P

	P = new()
	P.name = "Memo: Xenos and Explosives"
	P.info = "It has come to my attention that the station crew have recently been attacked by- and subsequently quashed- a sudden xeno infestation. While I commend you for putting this down without use of the explosives you were sent for the purpose of route denial and am legitimately impressed by it, I can't help but notice that your reported stock of explosives has diminished despite not being called for. I understood a few field tests on the day they were delivered. I do not understand or condone their use for recreation in light of the recent victory-- which is what I can only assume is what you all are doing. I appreciate each and every one of you, but our operation is of utmost importance and we can not afford to disregard safety. <br><br>You are all doing great work, and I am overjoyed you are all alive. Please post this on the noticeboard."
	P.stamp(stamp)
	src.contents += P

	P = new()
	P.name = "URGENT"
	P.info = "I'm posting this on the noticeboard before our command rep gets here and posts something about it, because we can't fuckin afford to wait on this. We need to blow all our tunnels. Those xenos we killed last month weren't here to colonize us or whatevershit. They were running. I'm going to start doing what I can; when your cryo wears off, you need to start doing the same. DO NOT ENGAGE NATIVE WILDLIFE UNLESS ABSOLUTELY NECESSARY.<br><br>-Rick"
	src.contents += P

	P = new()
	P.name = "report"
	P.info = "I destroyed the bluespace beacon. I had to; if command tries to come here the usual way they risk getting hit too. And I don't know what that thing's truly capable of, for all I know it could follow it back to base. <br><br>Rick and Bob are both dead. I couldn't explain how. They just... one minute they were in one place, and then their gps stopped tracking. When I went to their last location to find them, they weren't there. <br>They were everywhere else. <br><br>I'm posting this to the notice board in case command manages to get back here to let them know what happened. Assuming, of course, they want to after they consider what they already know. <br>I hid the access code. Yes, I know the access code. I also know that the control module it goes to is in what's left of Terralabs. Oh, I know about that too. I know how to move among it's current inhabitants without being shot at. You'll be able to extract it with your manpower, I'm sure.<br><br>And if someone from Nanotrasen finds this before command does- cuz god forbid they are stupid enough to try and set up a mining base here- leave this system. It probably never left. And don't try to get to Terralabs. Whatever happened there pissed it off. That outpost is proof."
	src.contents += P

	qdel(stamp)



//barrelfire stolen right out of goon's butthole

/obj/structure/burning_barrel
	name = "burning barrel"
	desc = "Strangely cozy, but the flames feel somewhat unnatural. What the hell is burning in there?"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "barrel1"
	density = 1
	anchored = 1
	opacity = 0
/* what follows is the original code pulled from goon. It doesn't work here. Because codebase differences. and stuff.
	var/datum/particleSystem/barrelSmoke/particles
	var/datum/light/light

	New()
		particles = particleMaster.SpawnSystem(new /datum/particleSystem/barrelSmoke(src))
		light = new /datum/light/point
		light.attach(src)
		light.set_brightness(1)
		light.set_color(0.5, 0.3, 0)
		light.enable()

		..()

	Del()
		particleMaster.RemoveSystem(/datum/particleSystem/barrelSmoke, src)
		..()
A temporary solution will be implemented below. It will be expanded upon/improved/replaced at some point. maybe.*/
	light_color = "#FF9933"
	light_range = 4


//Void/etc turfs stolenageifieded from goon


/turf/simulated/wall/void
	name = "dense void"
	icon = 'icons/turf/oldwalls.dmi'
	icon_state = "darkvoid"
	desc = "It seems solid..."
	opacity = 1
	density = 1

	ex_act()
		return

	ex_act(severity)
		return

	blob_act(var/power)
		return

	attack_hand(mob/user as mob)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		return


/turf/simulated/floor/void
	name = "void"
	icon = 'icons/turf/oldwalls.dmi'
	icon_state = "void"
	desc = "A strange shifting void ..."

	ex_act()
		return

	ex_act(severity)
		return

	blob_act(var/power)
		return

	attack_hand(mob/user as mob)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		return

/obj/effect/decal/floatingtiles
	name = "floating tiles"
	desc = "These tiles are just floating around in the void."
	opacity = 0
	density = 0
	anchored = 1
	icon = 'icons/turf/oldwalls.dmi'
	icon_state = "floattiles1"

/area/timewarp/ship
	name = "Strange Craft"
	icon_state = "shuttle"
	//RL_Lighting = 1
	requires_power = 0
	//ambientSound = 'sound/ambience/timeship_amb2.ogg' //gotta go find this var later and find out what it actually is
/*
	New()
		..()
		fxlist = timewarp_interior_sounds*/ //what even does this do in goon code

/turf/simulated/floor/void/timewarp
	name = "time-space breach"
	desc = "Uhh.  UHHHH.  uh."
	//RL_Ignore = 0
	icon_state = "timehole"


/obj/effect/decal/timeplug
	name = "time-space breach"
	desc = "Uhh.  UHHH.  uh!!"
	icon = 'icons/turf/oldwalls.dmi'
	icon_state = "timehole_edge"
	anchored = 1

//piggies
/turf/simulated/floor/void/airless
	oxygen = 0.01
	nitrogen = 0.01
/turf/simulated/floor/void/timewarp/airless
	oxygen = 0.01
	nitrogen = 0.01

//this is not stolen stuff
/obj/effect/decal/anus
	name = "LZ's Butt"
	desc = "This appears to be what has been left behind after LZ's poot fractured spacetime. This ugly scar on reality appears otherwise immovable and will likely persist in the depths of space until the end of time."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	anchored = 1
	opacity = 0
	density = 1
	light_color = "#000000"
	light_range = 3
/* //attempting to build up a method to shoost the fugger to a landmark or summat
/obj/effect/decal/anus/attack_hand(mob/user)
	teleport(user)
/obj/effect/decal/anus/teleport(atom/movable/M) //stolen from wormhole, and then modified
	if(istype(M, /obj/effect))	//sparks don't teleport
		return
	if(M.anchored && istype(M, /obj/mecha))
		return
	if(istype(M, /mob/living/simple_animal)) //No critters are allowed through this; players only.
		return

	if(istype(M, /atom/movable))
		var/turf/target
		//<INSERT CODE HERE THAT FINDS THE ANUS LANDMARK INSIDE MY BUTT AND SETS target TO THE TURF IT'S ON>
		if(!target)	return
		M.forceMove(target) //forcemove instead of do_teleport because fuck bitches get money smoke weed hail satan etc
*/

//Insert get out here
/*
/obj/effect/decal/froge
	name = "Get Out frog"
	desc = "It wants you to get out."
	icon = //Put some shit here pls
	icon_state = "getout"
	anchored = 1
	opacity = 0
	density = 1
	light_range = 3

/obj/effect/decal/froge/attack_hand(mob/user)
	teleport(user)
/obj/effect/decal/froge/teleport(atom/movable/M) //stolen from the anus hole
	if(istype(M, /obj/effect))	//sparks don't teleport
		return
	if(M.anchored && istype(M, /obj/mecha))
		return
	if(istype(M, /mob/living/simple_animal)) //No critters are allowed through this; players only.
		return

	if(istype(M, /atom/movable))
		var/turf/target
		//<INSERT CODE HERE THAT SPITS THE INTERACTOR INTO THAT ONE ROOM ON THE STATION THAT IS PURE WTF
		//by which I mean the return landmark I plan on putting in there ofc lol yeah>
		if(!target)	return
		do_teleport(M, target, 1, 1, 0, 0) 	//so this supposedly puts you adjacent to the place but I want it on the same tile. How does this method work?
*/											//also I figured I'd use do_teleport here instead of forcemove like above

/area/timewarp/ship/rectum
	name = "up LZ's butt"
	icon = 'icons/turf/areas2.dmi'
	icon_state = "turds"