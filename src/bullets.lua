--[[pod_format="raw",created="2025-07-17 06:51:51",modified="2025-07-17 07:27:03",revision=37]]
function spawn_bullet(x, y, dir)
	if (dir == 0) s = 7; h_flip = true; v_flip = false;
	if (dir == 1) s = 7; h_flip = false; v_flip = false;
	if (dir == 2) s = 6; h_flip = false; v_flip = false;
	if (dir == 3) s = 6; h_flip = false; v_flip = true;

	add(bullets, { x = x, y = y, dir = dir, s = s, h_flip = h_flip, v_flip = v_flip })
end

function _bullets_update()
	for bullet in all(bullets) do
		if (bullet.dir == 0 and fget(mget(bullet.x \ 16, (bullet.y + 8) \ 16), 1)) del(bullets, bullet)
		if (bullet.dir == 1 and fget(mget((bullet.x + 15) \ 16, (bullet.y + 8) \ 16), 1)) del(bullets, bullet)
		if (bullet.dir == 2 and fget(mget((bullet.x + 8)  \ 16, bullet.y \ 16), 1)) del(bullets, bullet)
		if (bullet.dir == 3 and fget(mget((bullet.x + 8)  \ 16, (bullet.y + 15) \ 16), 1)) del(bullets, bullet)

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