--[[pod_format="raw",created="2025-07-15 17:18:57",modified="2025-07-27 10:06:37",revision=51]]
include("src/player.lua")
include("src/bullets.lua")
include("src/utils.lua")
include("src/ghosts.lua")
include("src/dots.lua")
include("src/gui.lua")

-- putting this here so its not affected by _init()
gameOver = false
apiUrl = "http://localhost:3000"

function _init()
	flags = {
		wall = 0,
		wall_allow_up = 1,
		no_dots = 2,
		ghost = 3,
		bullet = 4
	}

	freeze = false
	menu = true

	_gui_init()
end

function _update()
	if (menu) _gui_update(); return	

	_player_update()
	_dots_update()
	_bullets_update()
	_ghosts_update()
end

function _draw()
	cls()
	
	if (menu) _gui_draw(); return	

	map()
	
	_player_draw()
	_dots_draw()
	_bullets_draw()
	_ghosts_draw()
end