--[[pod_format="raw",created="2025-07-22 08:22:49",modified="2025-07-25 11:35:34",revision=191]]
function _gui_init()
	gui = create_gui()
	
	startMenu = gui:attach({
		x = 165, y = 107,
		width = 150, height = 85,
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
	
	infoBtn = startMenu:attach({
		x = 0, y = 30,
		width = 150, height = 25,
		draw = function (self)
			rectfill(0, 0, self.width, self.height, 1)
			print("Info", 66, 9, 7)
		end,
		click = function (self)
			showInfo = true
		end
	})
	
	quitBtn = startMenu:attach({
		x = 0, y = 60,
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
	if showInfo then
		if (btnp(4)) showInfo = false
	else
		gui:update_all()
	end
end

function _gui_draw()
	if showInfo then
		print("O - back to menu", 4, 4)
		
		print("On keyboard the O button is the'z' key, and the X button is the 'z' key", 4, 20)
		print("Move around with the left/right/up/down arrows", 4, 32)
		print("Shoot with the X button", 4, 44)
		print("Score increases by 10 for eating a dot, 100 for killing a ghost", 4, 56)
	
		return
	else
		gui:draw_all()
		
		print("High Score: "..tostring(hi), 8, 8, 7)
		print("Made by cyteon", 8, 254, 7)
	end
end