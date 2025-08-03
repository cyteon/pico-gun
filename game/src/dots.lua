--[[pod_format="raw",created="2025-07-21 18:41:11",modified="2025-08-03 16:12:21",revision=116]]
function _dots_init()
	dots = {}
	
	for ty=15, 2, -1 do 
		for tx=28, 1, -1 do
		
			if not fget(mget(tx, ty), flags.no_dots) then
				local type_ = "dot"	
		
				if math.random(1,20) == 1 then
					type_ = "ammo"
				elseif math.random(1,50) == 1 then
					type_ = "speed"
				elseif math.random(1,80) == 1 then
					type_ = "power"
				elseif math.random(1,100) == 1 then
					type_ = "multi_shoot"
				elseif math.random(1,200) == 1 then
					type_ = "heart"
				end
			
				add(dots, { x = tx * 16, y = ty * 16, type = type_ })
			end
		end
	end
end

function _dots_update()
	for dot in all(dots) do
		if spr_collides(dot.x + 6, dot.y + 6, 2, 2, p.x + 1, p.y + 1, 15, 15) then
			if dot.type == "ammo" then p.ammo += 1
			elseif dot.type == "heart" then p.hp += 1
			elseif dot.type == "power" then
				p.power_up = true
				p.power_up_end = time() + 5
			elseif dot.type == "multi_shoot" then
				p.multi_shoot = true
				p.multi_shoot_end = time() + 10
			elseif dot.type == "speed" then
				p.double_speed = true
				p.double_speed_end = time() + 10
			else p.score += 10
			end
		
			del(dots, dot)
		end
	end
	
	if #dots == 0 then
		level += 1
		local tmp_score = p.score

		_dots_init()
		_ghosts_init()
		_player_init()
		
		p.score = tmp_score
	end
end

function _dots_draw()
	for dot in all(dots) do
		if dot.type == "ammo" then spr(26, dot.x, dot.y)
		elseif dot.type == "heart" then spr(15, dot.x, dot.y)
		elseif dot.type == "power" then spr(13, dot.x, dot.y)
		elseif dot.type == "multi_shoot" then spr(12, dot.x, dot.y)
		elseif dot.type == "speed" then spr(11, dot.x, dot.y)
		else spr(14, dot.x, dot.y)
		end
	end
end