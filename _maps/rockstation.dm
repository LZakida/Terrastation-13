/*
This is more or less copypasta from cyberiad except I assraped it and stuff so I guess it isn't anymore?
Blah blah blah >=7 z-levels blah blah blarg
Order is important, the order here means order ingame
Names irrelevant, order matters a shitload because revheads (n'stuff) might get fucked otherwise cuz game code looking at z1
current as of idunfukkenknoe
z1 = station
z2 = centcomm
z3 = telecommunications center
z4 = AI satellite and other hogshit
z5 = mining
z6 = ruskie station and other spessdiver goodies
z7 = salvage yard
z8 = terralabs



*/

//This is for the next block of shit; only putting above it in case it doesn't like comments in its pingas (too lazy to test it)
//		#include "map_files\rockstation\(whatever Z is named goes here).dmm"

#if !defined(MAP_FILE)

		#include "map_files\rockstation\Rock2.dmm"
		#include "map_files\rockstation\z2.dmm"
        #include "map_files\rockstation\z3.dmm"
        #include "map_files\rockstation\z4.dmm"
        #include "map_files\rockstation\z5.dmm"
        #include "map_files\rockstation\z6.dmm"
        #include "map_files\rockstation\z7.dmm"
        #include "map_files\rockstation\z8.dmm"

		#define MAP_FILE "rockstation.dmm"
        #define MAP_NAME "NSS Rock"

#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring Rock2.

#endif


//I'M ABOUT TO KILL SOME MOTHERFUCKERS
/*
NIGGER! DO NOTE THE FOLLOWING!!!!! :

Your space_levels config text must look like this:
{
Main Station;1;linked

Central Command;2;unlinked

Telecommunications Satellite;3;linked

AI Sat;4;linked

Mining Asteroid;5;linked

Ruskie plus;6;linked

Salvage Yard;7;linked

Terralabs;8;unlinked
}
Yes, BOTH centcom AND terralabs are unlinked! Failure to do this will potentially BREAK SHIT.
By which I mean possibly (but not likely) causing server crashes, and VERY possibly causing the ingame to break.
Remember how Trorbes and it's terralabs wing behaved? yeah. Don't link that Z-Level. It's going to be WAY harder to get stuff in it,
but ONLY if the players are accessing it from the direction they should. If someone flies in from outside they have the potential to bypass
the hazards which is COMPLETE HOGSHIT.

I also would like to note that I switched the order of the salvage yard and the AI satellite. This is because the new space ruins feature
will always load into z7 and as of writing this I haven't found where it is defined to do this or what its method is. It makes more sense
to spawn these into a Z-Level such as the salvage yard where this kind of shit would logically be anyway.
*/
