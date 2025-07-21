--[[pod_format="raw",created="2025-07-20 11:02:19",modified="2025-07-21 12:43:27",revision=27]]
function spr_collides(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
			 x2 < x1 + w1 and
			 y1 < y2 + h2 and
			 y2 < y1 + h1
end

function collides_left(x, y, f)
	return fget(mget((x - 1) \ 16, y \ 16), f)
end

function collides_right(x, y, f)
	return fget(mget((x + 16) \ 16, y \ 16), f)
end

function collides_up(x, y, f)
	return fget(mget(x \ 16, (y - 1) \ 16), f)
end

function collides_down(x, y, f)
	return fget(mget(x \ 16, (y + 16) \ 16), f)
end