--[[pod_format="raw",created="2025-07-22 08:22:49",modified="2025-07-22 16:04:01",revision=129]]
function _gui_init()
	gui = create_gui()
	
	startMenu = gui:attach({
		x = 165, y = 107,
		width = 150, height = 55,
	})
	
	startBtn = startMenu:attach({
		x = 0, y = 0,
		width = 150, height = 25,
		draw = function (self)
			rectfill(0, 0, self.width, self.height, 1)
			print("Start Game", 50, 9, 7)
		end,
		click = function (self)
			menu = false
		end
	})
	
	quitBtn = startMenu:attach({
		x = 0, y = startBtn.height + 5,
		width = 150, height = 25,
		draw = function (self)
			rectfill(0, 0, self.width, self.height, 1)
			print("Quit Game", 53, 9, 7)
		end,
		click = function (self)
			exit()
		end
	})
	
	 hi = fetch("/appdata/pacman_hi.pod")
end

function _gui_update()
	gui:update_all()
end

function _gui_draw()
	gui:draw_all()
	
	print("High Score: "..tostring(hi), 8, 8, 7)
	print("Made by cyteon", 8, 254, 7)
end