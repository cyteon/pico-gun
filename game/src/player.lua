--[[pod_format="raw",created="2025-07-15 17:22:09",modified="2025-08-02 14:08:31",revision=367]]
function _player_init()
	p = {
		x = 16,
		y = 240,
		dir = -1,
		last_dir = -1,
		sprite = 2,
		h_flip = false,
		v_flip = true,
		hp = 3,
		ammo = 10,
		score = 0,
		can_shoot_at = 0,
		
		power_up = false, -- this goes true after eating a power pellet
		power_up_end = 0
	}
end

function _player_update()
	if p.hp <= 0 and not freeze then
		reset_time = time() + 1
		freeze = true
		
		-- despawn all ghosts
		blinky = nil; clyde = nil; pinky = nil; inky = nil
		
		if p.score > fetch("/appdata/pacman_hi.pod") then
			store("/appdata/pacman_hi.pod", p.score)
		end
	end
	
	if freeze then
		if time() >= reset_time then
			game_over = true
			_init()
		end
		return
	end
	
	if (p.power_up and p.power_up_end < time()) p.power_up = false

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
			if p.power_up then p.x -= 2
			else p.x -= 1
			end
		end
	elseif p.dir == 1 then
		if p.y > ty then p.y -= min(1, p.y - ty)
		elseif p.y < ty then p.y += min(1, ty - p.y)
		end
		
		if not collides_right(p.x, p.y, flags.wall) then
			if p.power_up then p.x += 2
			else p.x += 1
			end
		end
	elseif p.dir == 2 then
		if p.x > tx then p.x -= min(1, p.x - tx)
		elseif p.x < tx then p.x += min(1, tx - p.x)
		end
		
		if not collides_up(p.x, p.y, flags.wall) then
			if p.power_up then p.y -= 2
			else p.y -= 1
			end
		end
	elseif p.dir == 3 then
		if p.x > tx then p.x -= min(1, p.x - tx)
		elseif p.x < tx then p.x += min(1, tx - p.x)
		end
		
		if not collides_down(p.x, p.y, flags.wall) then
			if p.power_up then p.y += 2
			else p.y += 1
			end
		end
	end
	
	p.last_dir = p.dir

	if btnp(5) and p.ammo > 0 and p.can_shoot_at < time() then
		spawn_bullet(p.x, p.y, p.dir)
		p.ammo -= 1
		
		p.can_shoot_at = time() + 0.5
	end
end

function _player_draw()
	spr(p.sprite, p.x, p.y, p.h_flip, p.v_flip)
	
	-- hearts
	for i = p.hp, 1, -1 do
		spr(24, (i-1)*16, 0)
	end
	
	print(string.format("%02d", p.ammo), 230, 5)
	spr(25, 238, 0)
	
	print(string.format("%06d", p.score), 448, 5)
end