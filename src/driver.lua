--[[pod_format="raw",created="2025-07-15 17:22:09",modified="2025-07-15 20:06:32",revision=109]]
function _init()
	p = {
		x = 16,
		y = 16,
		dir = -1,
		sprite = 2,
		h_flip = false,
		v_flip = true,
	}
end

function _update()
	if btn(0) then dir = 0; p.sprite = 2; p.h_flip = true end -- left
	if btn(1) then dir = 1; p.sprite = 2; p.h_flip = false end -- right
	if btn(2) then dir = 2; p.sprite = 3; p.v_flip = false end -- up
	if btn(3) then dir = 3; p.sprite = 3; p.v_flip = true end -- down

	if dir == 0 and not fget(mget((p.x - 1)/16, p.y/16), 1) then p.x -= 1 end
	if dir == 1 and not fget(mget((p.x + 16)/16, p.y/16), 1) then p.x += 1 end
	if dir == 2 and not fget(mget(p.x/16, (p.y - 1)/16), 1) then p.y -= 1 end
	if dir == 3 and not fget(mget(p.x/16, (p.y + 16)/16), 1) then p.y += 1 end
end

function _draw()
	cls()
	map()
	
	spr(p.sprite, p.x, p.y, p.h_flip, p.v_flip)
end