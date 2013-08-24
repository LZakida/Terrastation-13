
/obj/vaultspawner
	var
		maxX = 6
		maxY = 6
		minX = 2
		minY = 2

	New(turf/location as turf,lX = minX,uX = maxX,lY = minY,uY = maxY,var/type = null)
		if (!type)
			type = pick("sandstone","rock","alien")
		var/lowBoundX = location.x
		var/lowBoundY = location.y
		var/hiBoundX = location.x + rand(lX,uX)
		var/hiBoundY = location.y + rand(lY,uY)
		var/z = location.z
		for(var/i = lowBoundX,i<=hiBoundX,i++)
			for(var/j = lowBoundY,j<=hiBoundY,j++)
				if (i == lowBoundX || i == hiBoundX || j == lowBoundY || j == hiBoundY)
					new /turf/simulated/wall/vault(locate(i,j,z),type)
				else
					new /turf/simulated/floor/vault(locate(i,j,z),type)

		del(src)