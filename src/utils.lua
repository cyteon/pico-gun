--[[pod_format="raw",created="2025-07-20 11:02:19",modified="2025-07-20 11:03:32",revision=6]]
function collides_left(x, y)
	return fget(mget((p.x - 1) \ 16, p.y \ 16), 1)
end

function collides_right(x, y)
	return fget(mget((p.x + 16) \ 16, p.y \ 16), 1)
end

function collides_up(x, y)
	return fget(mget(p.x \ 16, (p.y - 1) \ 16), 1)
end

function collides_down(x, y)
	return fget(mget(p.x \ 16, (p.y + 16) \ 16), 1)
end