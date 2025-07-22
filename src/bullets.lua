--[[pod_format="raw",created="2025-07-17 06:51:51",modified="2025-07-22 08:07:24",revision=60]]
function _bullets_init()
	bullets = {}
end

function spawn_bullet(x, y, dir)
	if (dir == 0) s = 7; h_flip = true; v_flip = false;
	if (dir == 1) s = 7; h_flip = false; v_flip = false;
	if (dir == 2) s = 6; h_flip = false; v_flip = false;
	if (dir == 3) s = 6; h_flip = false; v_flip = true;

	add(bullets, { x = x, y = y, dir = dir, s = s, h_flip = h_flip, v_flip = v_flip })
end

function _bullets_update()
	for bullet in all(bullets) do
		-- despawn bullet on collision
		if (bullet.dir == 0 and collides_left(bullet.x, bullet.y, flags.wall)) del(bullets, bullet)
		if (bullet.dir == 1 and collides_right(bullet.x, bullet.y, flags.wall)) del(bullets, bullet)
		if (bullet.dir == 2 and collides_up(bullet.x, bullet.y, flags.wall)) del(bullets, bullet)
		if (bullet.dir == 3 and collides_down(bullet.x, bullet.y, flags.wall)) del(bullets, bullet)

		for ghost in all(ghosts) do
			if spr_collides(bullet.x + 8, bullet.y + 8, 4, 4, ghost.x, ghost.y, 16, 16) then
				del(bullets, bullet)
				
				del(ghosts, ghost)
				add(ghost_unused_sprites, ghost.s)
			
				p.score += 100
			end
		end

		if (bullet.dir == 0) bullet.x -= 2
		if (bullet.dir == 1) bullet.x += 2
		if (bullet.dir == 2) bullet.y -= 2
		if (bullet.dir == 3) bullet.y += 2
	end
end

function _bullets_draw()
	for bullet in all(bullets) do
		spr(bullet.s, bullet.x, bullet.y, bullet.h_flip, bullet.v_flip)
	end
end