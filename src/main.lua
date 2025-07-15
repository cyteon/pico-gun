--[[pod_format="raw",created="2025-07-15 13:06:56",modified="2025-07-15 16:14:54",revision=82]]
function _init()
	sheet = fetch("lib/0.gfx")
	layers = fetch("lib/0.map")
end

function _draw()
	cls()
	map(layers[1].bmp)
	spr(sheet[1].bmp, 0, 0, false)
end
