--[[pod_format="raw",created="2025-07-20 19:14:24",modified="2025-08-02 13:44:17",revision=410]]
function _ghosts_init()
	ghost_spawn_locations = {
		{ x = 224, y = 128 },
		{ x = 240, y = 128 },
	}
	
	-- each ghost has diffrent behaviour
	-- max_hp is to determine when to show remaining hp
	blinky = { x = 224, y = 128, dir = 2, s = 17, c = 8, hp = 1, max_hp = 1 }
	clyde = { x = 224, y = 128, dir = 2, s = 17, c = 10, hp = 1, max_hp = 1 }
	pinky = { x = 240, y = 128, dir = 2, s = 17, c = 14, hp = 1, max_hp = 1 }
	inky = { x = 240, y = 128, dir = 2, s = 17, c = 16, hp = 1, max_hp = 1 }
	
	blinky_respawn_at = 0
	clyde_respawn_at = 0
	clyde_respawn_at = 0
	inky_respawn_at = 0
	
	scatter_mode = true
	scatter_end = time() + 7
	next_scatter = 0
end

function move_toward(ghost, tx, ty)
	if (ghost.x % 16 != 0 or ghost.y % 16 != 0) return

	possible_dirs = {}
	
	local collision_left = collides_left(ghost.x, ghost.y, flags.wall)
	local collision_right = collides_right(ghost.x, ghost.y, flags.wall)
	local collision_up = (
		collides_up(ghost.x, ghost.y, flags.wall) and 
		not collides_up(ghost.x, ghost.y, flags.wall_allow_up)
	)
	local collision_down = collides_down(ghost.x, ghost.y, flags.wall)
	
	-- check if you are facing other way, to prevent 180 degree turns
	if (not collision_left and ghost.dir != 1) add(possible_dirs, 0)
	if (not collision_right and ghost.dir != 0) add(possible_dirs, 1)
	if (not collision_up and ghost.dir != 3) add(possible_dirs, 2)
	if (not collision_down and ghost.dir != 2) add(possible_dirs, 3)
	
	local best_dir = ghost.dir
	local shortest_dist = 9999

	for dir in all(possible_dirs) do
		local ox = ({-1,1,0,0})[dir + 1]
		local oy = ({0,0,-1,1})[dir + 1]	
		
		local nx = ghost.x + ox * 16
		local ny = ghost.y + oy * 16

		local dx = nx - tx
		local dy = ny - ty
		
		local dist = sqrt(dx^2 + dy^2)
		
		if dist < shortest_dist then
			shortest_dist = dist
			best_dir = dir
		end
	end
	
	ghost.dir = best_dir
end

function move_random(ghost)
	if (ghost.x % 16 != 0 or ghost.y % 16 != 0) return
	
	possible_dirs = {}
	
	local collision_left = collides_left(ghost.x, ghost.y, flags.wall)
	local collision_right = collides_right(ghost.x, ghost.y, flags.wall)
	local collision_up = (
		collides_up(ghost.x, ghost.y, flags.wall) and
		not collides_up(ghost.x, ghost.y, flags.wall_allow_upz)
	)
	local collision_down = collides_down(ghost.x, ghost.y, flags.wall)
	
	if (not collision_left and ghost.dir != 1) add(possible_dirs, 0)
	if (not collision_right and ghost.dir != 0) add(possible_dirs, 1)
	if (not collision_up and ghost.dir != 3) add(possible_dirs, 2)
	if (not collision_down and ghost.dir != 2) add(possible_dirs, 3)
	
	ghost.dir = possible_dirs[math.random(#possible_dirs)]
end

function _ghosts_update()
	if (freeze) return
	
	if scatter_mode and time() > scatter_end then 
		scatter_mode = false
		next_scatter = time() + 20
	elseif not scatter_mode and time() > next_scatter then
		scatter_mode = true
		scatter_end = time() + 7
	end

	-- blinky	

	if blinky then
		if p.power_up then
			move_random(blinky)
		elseif scatter_mode then -- frightened mode
			move_toward(blinky, 464, 0)
		else
			move_toward(blinky, p.x, p.y)
		end

		if (blinky.dir == 0) blinky.x -= 1; blinky.s = 16; blinky.hf = true
		if (blinky.dir == 1) blinky.x += 1; blinky.s = 16; blinky.hf = false
		if (blinky.dir == 2) blinky.y -= 1; blinky.s = 17
		if (blinky.dir == 3) blinky.y += 1; blinky.s = 18
		
		if spr_collides(blinky.x, blinky.y, 16, 16, p.x, p.y, 16, 16) then
			if not blinky.recent_collision then
				if p.power_up then
					blinky = nil
					blinky_respawn_at = time() + 2
					p.score += 200
				else 
					p.hp -= 1
					blinky.recent_collision = true
				end	
			end
		else
			blinky.recent_collision = false
		end	

		for bullet in all(bullets) do
			if spr_collides(bullet.x + 8, bullet.y + 8, 4, 4, blinky.x, blinky.y, 16, 16) then
				blinky.hp -= 1
				del(bullets, bullet)
				
				if blinky.hp <= 0 then
					blinky = nil
					blinky_respawn_at = time() + 2
				end
			
				p.score += 200 -- i think u should get point no matter what if u hit
				
				break
			end
		end
	else
		if blinky_respawn_at < time() then
			local loc = ghost_spawn_locations[math.random(#ghost_spawn_locations)]
			blinky = { x = loc.x, y = loc.y, dir = 2, s = 17, c = 8, hp = 1, max_hp = 1 }
		end
	end

	-- clyde
	
	if clyde then
		if p.power_up then
			move_random(clyde)
		elseif scatter_mode then
			move_toward(clyde, 0, 270)
		else
			local dist = sqrt((p.x - clyde.x)^2 + (p.y - clyde.y)^2)
		
			if dist > 128 then
				move_toward(clyde, p.x, p.y)
			else
				move_toward(clyde, 0, 270)
			end
		end	

		if (clyde.dir == 0) clyde.x -= 1; clyde.s = 16; clyde.hf = true
		if (clyde.dir == 1) clyde.x += 1; clyde.s = 16; clyde.hf = false
		if (clyde.dir == 2) clyde.y -= 1; clyde.s = 17
		if (clyde.dir == 3) clyde.y += 1; clyde.s = 18
		
		if spr_collides(clyde.x, clyde.y, 16, 16, p.x, p.y, 16, 16) then
			if not clyde.recent_collision then
				if p.power_up then
					clyde = nil
					clyde_respawn_at = time() + 2
					p.score += 200
				else 
					p.hp -= 1
					clyde.recent_collision = true
				end
			end
		else
			clyde.recent_collision = false
		end

		for bullet in all(bullets) do
			if spr_collides(bullet.x + 8, bullet.y + 8, 4, 4, clyde.x, clyde.y, 16, 16) then
				clyde.hp -= 1
				del(bullets, bullet)
				
				if clyde.hp <= 0 then
					clyde = nil
					clyde_respawn_at = time() + 2
				end	
		
				p.score += 200
				
				break
			end
		end
	else
		if clyde_respawn_at < time() then
			local loc = ghost_spawn_locations[math.random(#ghost_spawn_locations)]
			clyde = { x = loc.x, y = loc.y, dir = 2, s = 17, c = 10, hp = 1, max_hp = 1 }
		end
	end
	
	-- pinky
	
	if pinky then
		if p.power_up then	
			move_random(pinky)
		elseif scatter_mode then
			move_toward(pinky, 0, 0)
		else
			local tx = p.x
			local ty = p.y
			
			if p.dir == 0 then tx -= 64
			elseif p.dir == 1 then tx += 64
			elseif p.dir == 2 then tx -= 64; ty -= 64
			elseif p.dir == 3 then ty += 64
			end
	
			move_toward(pinky, tx, ty)
		end

		if (pinky.dir == 0) pinky.x -= 1; pinky.s = 16; pinky.hf = true
		if (pinky.dir == 1) pinky.x += 1; pinky.s = 16; pinky.hf = false
		if (pinky.dir == 2) pinky.y -= 1; pinky.s = 17
		if (pinky.dir == 3) pinky.y += 1; pinky.s = 18
		
		if spr_collides(pinky.x, pinky.y, 16, 16, p.x, p.y, 16, 16) then
			if not pinky.recent_collision then
				if p.power_up then
					pinky = nil
					pinky_respawn_at = time() + 2
					p.score += 200
				else 
					p.hp -= 1
					pinky.recent_collision = true
				end
			end
		else
			pinky.recent_collision = false
		end	

		for bullet in all(bullets) do
			if spr_collides(bullet.x + 8, bullet.y + 8, 4, 4, pinky.x, pinky.y, 16, 16) then
				pinky.hp -= 1
				del(bullets, bullet)
				
				if pinky.hp <= 0 then
					pinky = nil
					pinky_respawn_at = time() + 2
				end	
			
				p.score += 200
				
				break
			end
		end
	elseif pinky_respawn_at then -- for some reason i got a nil comparation error only here
		if pinky_respawn_at < time() then
			local loc = ghost_spawn_locations[math.random(#ghost_spawn_locations)]
			pinky = { x = loc.x, y = loc.y, dir = 2, s = 17, c = 14, hp = 1, max_hp = 1 }
		end
	end
	
	-- inky
	
	if inky then
		if p.power_up then
			move_random(inky)	
		elseif scatter_mode or not blinky then
			-- it uses blinky to calc where to go, no blinky = no calculate
			move_toward(inky, 480, 270)
		else
			local ax = p.x
			local ay = p.y
			
			if p.dir == 0 then ax -= 32
			elseif p.dir == 1 then ax += 32
			elseif p.dir == 2 then ay -= 32
			elseif p.dir == 3 then ay += 32
			end
			
			local dx = ax - blinky.x
			local dy = ay - blinky.y
			
			local tx = blinky.x + dx * 2
			local ty = blinky.y + dy * 2
	
			move_toward(inky, tx, ty)
		end

		if (inky.dir == 0) inky.x -= 1; inky.s = 16; inky.hf = true
		if (inky.dir == 1) inky.x += 1; inky.s = 16; inky.hf = false
		if (inky.dir == 2) inky.y -= 1; inky.s = 17;
		if (inky.dir == 3) inky.y += 1; inky.s = 18;
		
		if spr_collides(inky.x, inky.y, 16, 16, p.x, p.y, 16, 16) then
			if not inky.recent_collision then
				if p.power_up then
					inky = nil
					inky_respawn_at = time() + 2
					p.score += 200
				else 
					p.hp -= 1
					inky.recent_collision = true
				end
			end
		else
			inky.recent_collision = false
		end	

		for bullet in all(bullets) do
			if spr_collides(bullet.x + 8, bullet.y + 8, 4, 4, inky.x, inky.y, 16, 16) then
				inky.hp -= 1
				del(bullets, bullet)
				
				if inky.hp <= 0 then
					inky = nil
					inky_respawn_at = time() + 2
				end
			
				p.score += 200
				
				break
			end
		end
	else
		if inky_respawn_at < time() then
			local loc = ghost_spawn_locations[math.random(#ghost_spawn_locations)]
			inky = { x = loc.x, y = loc.y, dir = 2, s = 17, c = 16, hp = 1, max_hp = 1 }
		end
	end
end

function _ghosts_draw()
	if blinky then
		if p.power_up then
			if p.power_up_end - time() < 3 and math.floor((p.power_up_end - time())) % 2 == 0  then
				pal(8, 7)
			else
				pal(8, 16)
			end
		else pal(8, blinky.c)
		end

		spr(blinky.s, blinky.x, blinky.y, blinky.hf)
		pal()
		
		if blinky.hp != blinky.max_hp then
			rectfill(blinky.x + 3, blinky.y - 2, blinky.x + 12, blinky.y - 2, 8)
			rectfill(
				blinky.x + 3, 
				blinky.y - 2, 
				blinky.x + 3 + 9 * blinky.hp / blinky.max_hp,
				blinky.y - 2, 
				11
			)
		end
	end
	

	if clyde then
		if p.power_up then 
			if p.power_up_end - time() < 3 and math.floor((p.power_up_end - time())) % 2 == 0  then
				pal(8, 7)
			else
				pal(8, 16)
			end
		else pal(8, clyde.c)	
		end

		spr(clyde.s, clyde.x, clyde.y, clyde.hf)
		pal()
	end
	
	if pinky then
		if p.power_up then
			if p.power_up_end - time() < 3 and math.floor((p.power_up_end - time())) % 2 == 0  then
				pal(8, 7)
			else
				pal(8, 16)
			end
		else pal(8, pinky.c)
		end
		
		spr(pinky.s, pinky.x, pinky.y, pinky.hf)
		pal()
	end
	
	if inky then
		if p.power_up then
			if p.power_up_end - time() < 3 and math.floor((p.power_up_end - time())) % 2 == 0  then
				pal(8, 7)
			else
				pal(8, 16)
			end
		else pal(8, inky.c)
		end
		
		spr(inky.s, inky.x, inky.y, inky.hf)
		pal()
	end
end