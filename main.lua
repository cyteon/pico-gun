--[[pod_format="raw",created="2025-07-15 17:18:57",modified="2025-07-21 18:43:36",revision=18]]
include("src/driver.lua")
include("src/bullets.lua")
include("src/utils.lua")
include("src/ghosts.lua")
include("src/dots.lua")

flags = {
	wall = 0,
	wall_allow_up = 1,
	no_dots = 2,
	ghost = 3,
	bullet = 4
}