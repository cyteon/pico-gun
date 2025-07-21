--[[pod_format="raw",created="2025-07-20 11:02:19",modified="2025-07-20 18:44:18",revision=21]]
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