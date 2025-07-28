--[[pod_format="raw",created="2025-07-22 08:22:49",modified="2025-07-28 18:32:38",revision=377]]
function _gui_init()
	show_lb = false
	lb_entries = {}
	scroll_offset = 0

	show_info = false

	main_menu = create_gui()
	
	buttons = main_menu:attach({
		x = 165, y = 78,
		width = 150, height = 115,
	})
	
	start_btn = buttons:attach({
		x = 0, y = 0,
		width = 150, height = 25,
		draw = function (self)
			rectfill(0, 0, self.width, self.height, 1)
			print("Start Game", 50, 9, 7)
		end,
		click = function (self)
			_player_init()
			_bullets_init()
			_ghosts_init()
			_dots_init()	
	
			menu = false
			gameOver = false
		end
	})
	
	info_btn = buttons:attach({
		x = 0, y = 30,
		width = 150, height = 25,
		draw = function (self)
			rectfill(0, 0, self.width, self.height, 1)
			print("Info", 66, 9, 7)
		end,
		click = function (self)
			show_info = true
		end
	})
	
	lb_btn = buttons:attach({
		x = 0, y = 60,
		width = 150, height = 25,
		draw = function (self)
			rectfill(0, 0, self.width, self.height, 1)
			print("Leaderboard", 48, 9, 7)
		end,
		click = function (self)
			show_lb = true
			
			data = fetch(apiUrl.."/lb/get")
			
			i = 1
			for l in data:gmatch("([^\r\n]*)([\r\n]*)") do
				local words = {}
			   for word in l:gmatch("%S+") do
			       table.insert(words, word)
			   end
			   
			  	local score = tonumber(table.remove(words))
			  	local name = table.concat(words, " ")
			  	add(lb_entries, { name = name, score = score, i = i })
			  	
			  	i += 1
			end
		end
	})
	
	quit_btn = buttons:attach({
		x = 0, y = 90,
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
	if (btnp(4)) show_info = false show_lb = false

	if show_lb then
		if btn(2) and scroll_offset < 0 then
			scroll_offset += 2
		elseif btn(3) then
			scroll_offset -= 2
		end
	elseif not show_info then
		main_menu:update_all()
	end
end

function _gui_draw()
	if show_info then
		print("O - back to menu", 4, 4)
		
		print("On keyboard the O button is the'z' key, and the X button is the 'z' key", 4, 20)
		print("Move around with the left/right/up/down arrows", 4, 32)
		print("Shoot with the X button", 4, 44)
		print("Score increases by 10 for eating a dot, 100 for killing a ghost", 4, 56)
	
		return
	elseif show_lb then
		print("O - back to menu", 4, 4)
		print("Use arrows to scroll", 4, 12)

		i = 3
		for entry in all(lb_entries) do
			i_len = 0
			tostring(entry.i):gsub("%d", function() i_len = i_len + 1 end)
			
			print("#"..tostring(entry.i), 170 - i_len * 4, 16 * i + scroll_offset, 7)
			print(entry.name, 190, 16 * i + scroll_offset, 7)
			print(entry.score, 290, 16 * i + scroll_offset, 7)
			i += 1
		end
		
		rectfill(120, 0, 480, 37, 0) -- do a huge chunk just incase big numbers
		print("Name", 190, 16, 7)
		print("Score", 290, 16, 7)	
		print("-------------------------", 190, 32, 7)
	else
		main_menu:draw_all()
		
		print("High Score: "..tostring(hi), 8, 8, 7)
		print("Made by cyteon", 8, 254, 7)
	end
end