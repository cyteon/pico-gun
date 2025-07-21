--[[pod_format="raw",created="2025-07-15 17:22:09",modified="2025-07-21 11:01:33",revision=304]]
function _init()
	p = {
		x = 16,
		y = 32,
		dir = -1,
		last_dir = -1,
		sprite = 2,
		h_flip = false,
		v_flip = true,
		hp = 3,
		ammo = 10,
		score = 0
	}
	
	_bullets_init()
	_ghosts_init()
end

function _update()
	if btnp(0) and not collides_left(p.x, p.y, flags.wall) then -- left
		p.dir = 0
		p.sprite = 2
		p.h_flip = true
	elseif btnp(1) and not collides_right(p.x, p.y, flags.wall) then -- right 
		p.dir = 1
		p.sprite = 2 
		p.h_flip = false
	elseif btnp(2) and not collides_up(p.x, p.y, flags.wall) then -- up 
		p.dir = 2
		p.sprite = 3
		p.v_flip = false
	elseif btnp(3) and not collides_down(p.x, p.y, flags.wall) then -- down 
		p.dir = 3
		p.sprite = 3
		p.v_flip = true
	end
	
	local tx = (p.x \ 16) * 16
	local ty = (p.y \ 16) * 16 
	
	if p.dir == 0 then
		if p.y > ty then p.y -= min(1, p.y - ty)
		elseif p.y < ty then p.y += min(1, ty - p.y)
		end
		
		if not collides_left(p.x, p.y, flags.wall) then
			p.x -= 1
		end
	elseif p.dir == 1 then
		if p.y > ty then p.y -= min(1, p.y - ty)
		elseif p.y < ty then p.y += min(1, ty - p.y)
		end
		
		if not collides_right(p.x, p.y, flags.wall) then
			p.x += 1
		end
	elseif p.dir == 2 then
		if p.x > tx then p.x -= min(1, p.x - tx)
		elseif p.x < tx then p.x += min(1, tx - p.x)
		end
		
		if not collides_up(p.x, p.y, flags.wall) then
			p.y -= 1
		end
	elseif p.dir == 3 then
		if p.x > tx then p.x -= min(1, p.x - tx)
		elseif p.x < tx then p.x += min(1, tx - p.x)
		end
		
		if not collides_down(p.x, p.y, flags.wall) then
			p.y += 1
		end
	end
	
	p.last_dir = p.dir

	if (btnp(5) and p.ammo > 0) spawn_bullet(p.x, p.y, p.dir); p.ammo -= 1
	
	_bullets_update()
	_ghosts_update()
end

function _draw()
	cls()
	map()
	
	-- player
	spr(p.sprite, p.x, p.y, p.h_flip, p.v_flip)
	
	-- hearts
	for i = p.hp, 1, -1 do
		spr(4, (i-1)*16, 0)
	end
	
	print(string.format("%02d", p.ammo), 230, 5)
	spr(5, 238, 0)
	
	print(string.format("%06d", p.score), 448, 5)
	
	_bullets_draw()
	_ghosts_draw()
end