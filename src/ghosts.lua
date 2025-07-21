--[[pod_format="raw",created="2025-07-20 19:14:24",modified="2025-07-21 19:06:20",revision=93]]
function _ghosts_init()
	ghosts = {}
	add(ghosts, { x = 208, y = 128, dir = 2, s = 8 })
	add(ghosts, { x = 224, y = 128, dir = 2, s = 9 })
	add(ghosts, { x = 240, y = 128, dir = 2, s = 10 })
	add(ghosts, { x = 256, y = 128, dir = 2, s = 11 })
end

function generate_dir_without(x, y, excl)
	local dir = math.random(0,3)
	
	if (dir == excl) return generate_dir_without(x, y, excl)
	
	if dir == 0 and not collides_left(x, y, flags.wall) then
		return 0
	elseif dir == 1 and not collides_right(x, y, flags.wall) then
		return 1
	elseif dir == 2 and (not collides_up(x, y, flags.wall) or collides_up(x, y, flags.wall_allow_up)) then
		return 2
	elseif dir == 3 and not collides_down(x, y, flags.wall) then
		return 3
	else
		return generate_dir_without(x, y, excl)
	end
end

function _ghosts_update()
	if (freeze) return

	for ghost in all(ghosts) do
		local collision_left = collides_left(ghost.x, ghost.y, flags.wall)
		local collision_right = collides_right(ghost.x, ghost.y, flags.wall)
		local collision_up = (
			collides_up(ghost.x, ghost.y, flags.wall) and 
			not collides_up(ghost.x, ghost.y, flags.wall_allow_up)
		)
		local collision_down = collides_down(ghost.x, ghost.y, flags.wall)
		
		if ghost.dir == 0 and collision_left then
			ghost.dir = generate_dir_without(ghost.x, ghost.y, 0)
		elseif ghost.dir == 1 and collision_right then
			ghost.dir = generate_dir_without(ghost.x, ghost.y, 1)
		elseif ghost.dir == 2 and collision_up then
			ghost.dir = generate_dir_without(ghost.x, ghost.y, 2)
		elseif ghost.dir == 3 and collision_down then
			ghost.dir = generate_dir_without(ghost.x, ghost.y, 3)
		else
			-- randomly go to possible dir so it just dosent go back and forward etc
			-- 50% chance, and only do it if in center of a tile
			if math.random(1,2) == 1 and ghost.x % 16 == 0 and ghost.y % 16 == 0 then
				if ghost.dir == 0 or ghost.dir == 1 then
					if not collision_up and not collision_down then
						ghost.dir = math.random(2,3)
					elseif not collision_up then
						ghost.dir = 2
					elseif not collision_down then
						ghost.dir = 3
					end
				elseif ghost.dir == 2 or ghost.dir == 3 then
					if not collision_left and not collision_right then
						ghost.dir = math.random(0,1)
					elseif not collision_left then
						ghost.dir = 0
					elseif not collision_right then
						ghost.dir = 1
					end
				end
			end
		end
		
		if (ghost.dir == 0) ghost.x -= 1
		if (ghost.dir == 1) ghost.x += 1
		if (ghost.dir == 2) ghost.y -= 1
		if (ghost.dir == 3) ghost.y += 1
		
		if spr_collides(ghost.x, ghost.y, 16, 16, p.x, p.y, 16, 16) then
			if not ghost.recent_collision then
				p.hp -= 1
				ghost.recent_collision = true
			end
		else
			ghost.recent_collision = false
		end
	end
end

function _ghosts_draw()
	for ghost in all(ghosts) do
		spr(ghost.s, ghost.x, ghost.y)
	end
end