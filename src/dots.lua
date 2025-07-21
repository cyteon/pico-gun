--[[pod_format="raw",created="2025-07-21 18:41:11",modified="2025-07-21 19:05:24",revision=37]]
function _dots_init()
	dots = {}
	
	for iy=15,2,-1 do 
		for ix=28,1,-1 do
		
			if not fget(mget(ix, iy), flags.no_dots) then
				local is_bullet = math.random(1,10) == 1
				add(dots, { x = ix * 16, y = iy * 16, is_bullet = is_bullet })
			end
		end
	end
end

function _dots_update()
	for dot in all(dots) do
		if spr_collides(dot.x + 6, dot.y + 6, 2, 2, p.x + 1, p.y + 1, 15, 15) then
			if dot.is_bullet then p.ammo += 1
			else p.score += 10
			end
		
			del(dots, dot)
		end
	end
end

function _dots_draw()
	for dot in all(dots) do
		if dot.is_bullet then spr(6, dot.x, dot.y)
		else spr(14, dot.x, dot.y)
		end
	end
end