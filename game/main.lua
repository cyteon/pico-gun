--[[pod_format="raw",created="2025-07-15 17:18:57",modified="2025-08-02 13:46:21",revision=93]]
-- i copied this entire 1600 line file from the system, to change one line
include("sys/gui_ed.lua")

include("src/player.lua")
include("src/bullets.lua")
include("src/utils.lua")
include("src/ghosts.lua")
include("src/dots.lua")
include("src/gui.lua")

-- putting this here so its not affected by _init()
game_over = false
api_url = "http://localhost:3000" -- for lb

flags = {
	wall = 0,
	wall_allow_up = 1, -- so ghosts can exit their box, but nothing can enter
	no_dots = 2, -- where dots cant spawn
	ghost = 3,
	bullet = 4
}

function _init()
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
	
	-- refrence lines so i can center shit
	-- rectfill(0, 135, 480, 135, 8)
	-- rectfill(240, 0, 240, 270, 8)
	
	if (menu) _gui_draw(); return	

	map()
	
	_player_draw()
	_dots_draw()
	_bullets_draw()
	_ghosts_draw()
end