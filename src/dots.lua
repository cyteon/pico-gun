--[[pod_format="raw",created="2025-07-21 18:41:11",modified="2025-07-22 16:23:34",revision=62]]
function _dots_init()
	dots = {}
	
	for ty=15,2,-1 do 
		for tx=28,1,-1 do
		
			if not fget(mget(tx, ty), flags.no_dots) then
				local is_bullet = math.random(1,20) == 1 -- 5% chance
				local is_heart = math.random(1,200) == 1 and not is_bullet -- <0.5% chance
			
				add(dots, { x = tx * 16, y = ty * 16, is_bullet = is_bullet, is_heart = is_heart })
			end
		end
	end
end

function _dots_update()
	for dot in all(dots) do
		if spr_collides(dot.x + 6, dot.y + 6, 2, 2, p.x + 1, p.y + 1, 15, 15) then
			if dot.is_bullet then p.ammo += 1
			elseif dot.is_heart then p.hp += 1
			else p.score += 10
			end
		
			del(dots, dot)
		end
	end
	
	if math.random(1,20) == 1 then -- 5% chance to do anything
		local ty = math.random(2,15)
		local tx = math.random(1,28)	

		if not fget(mget(tx, ty), flags.no_dots) then
			local is_bullet = math.random(1,20) == 1 -- 5% chance
			local is_heart = math.random(1,100) == 1 and not is_bullet -- <1% chance	
			add(dots, { x = tx * 16, y = ty * 16, is_bullet = is_bullet, is_heart = is_heart})
		end
	end
end

function _dots_draw()
	for dot in all(dots) do
		if dot.is_bullet then spr(26, dot.x, dot.y)
		elseif dot.is_heart then spr(15, dot.x, dot.y)
		else spr(14, dot.x, dot.y)
		end
	end
end