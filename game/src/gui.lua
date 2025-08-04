--[[pod_format="raw",created="2025-07-22 08:22:49",modified="2025-08-04 15:53:01",revision=644]]
function _gui_init()
	show_lb = false
	lb_entries = {}
	scroll_offset = 0
	saved_lb_entry = false

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
			
			data = fetch(api_url.."/lb/get")
			
			i = 1
			for l in data:gmatch("([^\r\n]*)([\r\n]*)") do
				local words = {}
			   for word in l:gmatch("%S+") do
			       table.insert(words, word)
			   end
			   
			  	if #words != 0 then
			  		local score = tonumber(table.remove(words))
			  		local name = table.concat(words, " ")
			  		add(lb_entries, { name = name, score = score, i = i })
			  	
			  		i += 1
			  	end
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
	
	game_over_ui = create_gui()
	
	main_menu_button = game_over_ui:attach({
		x = 240-75, y = 140,
		width = 150, height = 25,
		draw = function (self)
			rectfill(0, 0, 150, 25, 1)
			print("Main Menu", 75-(9*5\2), 9, 7)
		end,
		click = function (self)
			game_over = false
		end
	})
	
	username_text = attach_text_editor_fixed(game_over_ui, {
		x = 165, y = 115,
		width = 70, height = 15,
		bgcol = 1, fgcol = 7,
		margin_top = 4
	})
	
	username_text:set_keyboard_focus(true)

	save_button = game_over_ui:attach({
		x = 245, y = 115,
		width = 70, height = 15,
		draw = function (self)
			rectfill(0, 0, 150, 25, 1)
			
			if saved_lb_entry then
				print("Saved!", 70/2-(5*5\2)-1, 4, 11)
			else
				print("Save", 70/2-(4*5\2), 4, 7)
			end
		end,
		click = function (self)
			uuid = fetch("/appdata/pacman_uuid.pod")
			
			score = 0
			if (p) score = p.score	
	
			if uuid then
				res = fetch(
					api_url.."/lb/set?user="
					..username_text:get_text()[1]:gsub(" ", "%%20")
					.."&score="..tostring(score)
					.."&id="..uuid
				)
			else
				res = fetch(
					api_url.."/lb/set?user="
					..username_text:get_text()[1]:gsub(" ", "%s")
					.."&score="..tostring(score)
				) 
				
				local words = {}
				
				for word in res:gmatch("%S+") do
					table.insert(words, word)
				end
				   
				local uuid = table.remove(words)
				store("/appdata/pacman_uuid.pod", uuid)
			end
			
			saved_lb_entry = true
		end
	})
	
	highscore = fetch("/appdata/pacman_hi.pod") or "none"
end

function _gui_update()
	if (btnp(4)) show_info = false show_lb = false

	if show_lb then
		if btn(2) and scroll_offset < 0 then
			scroll_offset += 2
		elseif btn(3) then
			scroll_offset -= 2
		end
	elseif game_over then
		game_over_ui:update_all()
	elseif not show_info then
		main_menu:update_all()
	end
end

function _gui_draw()
	if show_info then
		print("O (z) - back to menu", 4, 4)
		
		print("On keyboard the O button is the'z' key, and the X button is the 'x' key", 4, 20)
		print("Move around with the left/right/up/down arrows", 4, 32)
		print("Shoot with the X button", 4, 44)
		print("Score increases by 10 for eating a dot, 200 for killing a ghost", 4, 56)
		print("Across the map you might find some powerups", 4, 68)
		
		spr(13, 4, 80) print("gives you the ability to eat ghosts and gives you double speed, lasts 5 seconds", 24, 84, 7)
		spr(12, 4, 94) print("makes you shoot in every direction for the cost of 1 bullet, lasts 10 seconds", 24, 98, 7)	
		spr(11, 4, 108) print("doubles your speed for 10 seconds", 24, 112, 7)
		spr(10, 4, 122) print("spawns 3 random powerups", 24, 126, 7)
		spr(15, 4, 136) print("gives you one more heart", 24, 140, 7)
		spr(23, 4, 150) print("makes your next bullet bounce around until it hits a ghost", 24, 154, 7)
	
		return
	elseif show_lb then
		print("O (z) - back to menu", 4, 4)
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
	elseif game_over then
		print("\^w\^tYou Died :(", 240-(11*5)+2, 16, 7)
		
		score = 0
		if (p) score = p.score
		score_text = "Score: "..tostring(score)
		print(score_text, 240-(#score_text*2)-3, 32, 7)
		
		game_over_ui:draw_all()
		
		print("Username:", 165, 106, 7)
	else
		main_menu:draw_all()
		
		print("High Score: "..tostring(highscore), 8, 8, 7)
		print("Made by cyteon", 8, 254, 7)
	end
end