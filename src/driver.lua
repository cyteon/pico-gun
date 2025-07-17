--[[pod_format="raw",created="2025-07-15 17:22:09",modified="2025-07-17 07:25:54",revision=202]]
function _init()
	p = {
		x = 16,
		y = 32,
		dir = -1,
		sprite = 2,
		h_flip = false,
		v_flip = true,
		hp = 3,
		ammo = 10
	}
	
	bullets = {}
end

function _update()
	if (btnp(0)) p.dir = 0; p.sprite = 2; p.h_flip = true -- left
	if (btnp(1)) p.dir = 1; p.sprite = 2; p.h_flip = false -- right
	if (btnp(2)) p.dir = 2; p.sprite = 3; p.v_flip = false -- up
	if (btnp(3)) p.dir = 3; p.sprite = 3; p.v_flip = true -- down
	
	if (btnp(5) and p.ammo > 0) spawn_bullet(p.x, p.y, p.dir); p.ammo -= 1

	if (p.dir == 0 and not fget(mget(p.x \ 16, (p.y + 8) \ 16), 1)) p.x -= 1
	if (p.dir == 1 and not fget(mget((p.x + 15) \ 16, (p.y + 8) \ 16), 1)) p.x += 1
	if (p.dir == 2 and not fget(mget((p.x + 8)  \ 16, p.y \ 16), 1)) p.y -= 1
	if (p.dir == 3 and not fget(mget((p.x + 8)  \ 16, (p.y + 15) \ 16), 1)) p.y += 1
	
	_bullets_update()
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
	
	print(p.ammo, 448, 5)
	spr(5, 464, 0)
	
	_bullets_draw()
end