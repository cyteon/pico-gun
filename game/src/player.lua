--[[pod_format="raw",created="2025-07-15 17:22:09",modified="2025-08-03 16:14:15",revision=467]]
function _player_init()
	p = {
		x = 16,
		y = 240,
		
		dir = -1,
		planned_dir = -1,
		
		sprite = 2,
		h_flip = false,
		v_flip = true,
		
		hp = 3,
		ammo = 10,
		score = 0,
		can_shoot_at = 0,
		
		power_up = false, -- lets you eat ghosts and make you go double speed
		power_up_end = 0,
		
		multi_shoot = false, -- makes you shoot in all 4 directions
		multi_shoot_end = 0,
		
		double_speed = false, -- self explanatory
		double_speed_end = 0,
		
		offset_x = 0,
		offset_y = 0,
		shake_strength = 2,
		shake_decay = 0.8,
		shake_timer = 0,
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
	if (p.multi_shoot and p.multi_shoot_end < time()) p.multi_shoot = false
	if (p.double_speed and p.double_speed_end < time()) p.double_speed = false
		
	if (btnp(0)) p.planned_dir = 0
	if (btnp(1)) p.planned_dir = 1
	if (btnp(2)) p.planned_dir = 2
	if (btnp(3)) p.planned_dir = 3

	if (p.x % 16 == 0 and (p.planned_dir == 2 or p.planned_dir == 3)) or 
		(p.y % 16 == 0 and (p.planned_dir == 0 or p.planned_dir == 1)) then
		if p.planned_dir == 0 and not collides_left(p.x, p.y, flags.wall) then -- left
			p.dir = 0
			p.sprite = 2
			p.h_flip = true
		elseif p.planned_dir == 1 and not collides_right(p.x, p.y, flags.wall) then -- right 
			p.dir = 1
			p.sprite = 2 
			p.h_flip = false
		elseif p.planned_dir == 2 and not collides_up(p.x, p.y, flags.wall) then -- up 
			p.dir = 2
			p.sprite = 3
			p.v_flip = false
		elseif p.planned_dir == 3 and not collides_down(p.x, p.y, flags.wall) then -- down 
			p.dir = 3
			p.sprite = 3
			p.v_flip = true
		end
	end
	
	local tx = (p.x \ 16) * 16
	local ty = (p.y \ 16) * 16 
	
	if p.dir == 0 then
		if not collides_left(p.x, p.y, flags.wall) then
			-- collision statement to make sure you 
			-- dont enter a pixel that wont let you move
			if (p.power_up or p.double_speed) and not collides_left(p.x - 1, p.y, flags.wall) then p.x -= 2
			else p.x -= 1
			end
		end
	elseif p.dir == 1 then
		if not collides_right(p.x, p.y, flags.wall) then
			if (p.power_up or p.double_speed) and not collides_right(p.x + 1, p.y, flags.wall) then p.x += 2
			else p.x += 1
			end
		end
	elseif p.dir == 2 then
		if not collides_up(p.x, p.y, flags.wall) then
			if (p.power_up or p.double_speed) and not collides_up(p.x, p.y - 1, flags.wall) then p.y -= 2
			else p.y -= 1
			end
		end
	elseif p.dir == 3 then
		if not collides_down(p.x, p.y, flags.wall) then
			if (p.power_up or p.double_speed) and not collides_down(p.x, p.y + 1, flags.wall) then p.y += 2
			else p.y += 1
			end
		end
	end

	if btnp(5) and p.ammo > 0 and p.can_shoot_at < time() then
		if p.multi_shoot then
			spawn_bullet(p.x, p.y, 0)
			spawn_bullet(p.x, p.y, 1)
			spawn_bullet(p.x, p.y, 2)
			spawn_bullet(p.x, p.y, 3)
		else
			spawn_bullet(p.x, p.y, p.dir)
		end	
	
		p.ammo -= 1
		p.can_shoot_at = time() + 0.5
	end
	
	if p.shake_timer > 0 then
		p.offset_x = sin(p.shake_timer * 0.1) * p.shake_strength
		p.offset_y = cos(p.shake_timer * 0.1) * p.shake_strength
		p.shake_timer *= p.shake_decay
	else
		p.offset_x = 0
		p.offset_y = 0
	end
	
	camera(p.offset_x, p.offset_y)
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