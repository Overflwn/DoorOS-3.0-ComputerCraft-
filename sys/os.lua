os.loadAPI("/doorOS/API/sha")
os.loadAPI("/doorOS/API/sys")

--Main OS 

--Variablen
_ver = 2.0
_verstr = "2.0"
tmpUsrNm = ""
tmpPw = ""
usrData = {
	Username = "",
	Password = "",
	Language = "",
}
lang = {
	
}
oldTerm = term.current()
wallpaper = paintutils.loadImage("/doorOS/sys/wllppr.nfp")
missing = 0
left = 0
maximum = 0
search = ""
progList = {}
selectedProg = 0
tasks = {}
taskWindows = {}
selectedTask = 0
taskMissing = 0
taskLeft = 0
taskMaximum = 0

minimized = {
	
}

t = {
	w = {},
	uw = {},
	c = {},
	tb = {},
	xA = {},
	yA = {},
	xO = {},
	yO = {},

}

--Funktionen

function drawLogin()
	clear(colors.lightBlue, colors.white)
	loginWindow = window.create(oldTerm, 15, 5, 20, 10)
	term.redirect(loginWindow)
	term.setBackgroundColor(colors.lightGray)
	term.setTextColor(colors.white)
	term.clear()
	usrTxtBx = window.create(term.current(), 2, 2, 18, 1)
	usrTxtBx.setBackgroundColor(colors.gray)
	usrTxtBx.setTextColor(colors.lime)
	usrTxtBx.clear()
	usrTxtBx.write(usrData.Username)
	pwTxtBx = window.create(term.current(), 2, 4, 18, 1)
	pwTxtBx.setBackgroundColor(colors.gray)
	pwTxtBx.setTextColor(colors.lime)
	pwTxtBx.clear()
	pwTxtBx.write(lang.Password)
	term.setCursorPos(2,9)
	term.setBackgroundColor(colors.lime)
	term.setTextColor(colors.white)
	term.write(" > ")
	local login = true
	while login do
		local event, button, x, y = os.pullEvent("mouse_click")
		if button == 1 and x >= 16 and x <= 33 and y == 8 then
			term.redirect(pwTxtBx)
			term.setCursorPos(1,1)
			term.clear()
			tmpPw = sys.limitRead(18, "*")
			tmpPw = sha.sha256(tmpPw)
			term.redirect(loginWindow)
		elseif button == 1 and x >= 16 and x <= 18 and y == 13 then
			if tmpPw == "" or tmpPw == nil then
				pwTxtBx.setCursorPos(1,1)
				pwTxtBx.clear()
				pwTxtBx.setTextColor(colors.red)
				pwTxtBx.write(lang.PlsFill)
				pwTxtBx.setTextColor(colors.lime)
			elseif tmpPw == usrData.Password then
				login = false
				term.redirect(oldTerm)
				loginWindow.setVisible(false)
				pwTxtBx.setVisible(false)
				usrTxtBx.setVisible(false)
				drawDesktop()
			else
				pwTxtBx.setCursorPos(1,1)
				pwTxtBx.clear()
				pwTxtBx.setTextColor(colors.red)
				pwTxtBx.write(lang.WrongPW)
				pwTxtBx.setTextColor(colors.lime)
			end
		end 
	end
end

function drawSettings()
	set = true
	settings = window.create(oldTerm, 16, 2, 36, 18)
	settings.setBackgroundColor(colors.cyan)
	settings.setTextColor(colors.white)
	settings.setCursorPos(1,1)
	settings.clear()
	usrTxtBx = window.create(settings, 2, 2, 18, 1)
	usrTxtBx.setBackgroundColor(colors.gray)
	usrTxtBx.setTextColor(colors.lime)
	usrTxtBx.clear()
	usrTxtBx.setCursorPos(1,1)
	usrTxtBx.write(usrData.Username)
	setUsrname = window.create(settings, 20, 2, 16, 1)
	setUsrname.setBackgroundColor(colors.cyan)
	setUsrname.setTextColor(colors.white)
	setUsrname.clear()
	setUsrname.write(lang.Username)
	pwTxtBx = window.create(settings, 2, 4, 18, 1)
	pwTxtBx.setBackgroundColor(colors.gray)
	pwTxtBx.setTextColor(colors.lime)
	pwTxtBx.clear()
	pwTxtBx.setCursorPos(1,1)
	pwTxtBx.write("*****")
	setPw = window.create(settings, 20, 4, 16, 1)
	setPw.setBackgroundColor(colors.cyan)
	setPw.setTextColor(colors.white)
	setPw.clear()
	setPw.write(lang.Password)
	changeWallpaper = window.create(settings, 2, 6, 18, 1)
	changeWallpaper.setBackgroundColor(colors.lime)
	changeWallpaper.setTextColor(colors.white)
	changeWallpaper.clear()
	changeWallpaper.write(lang.changeWallpaper)
	manageSoftware = window.create(settings, 2, 8, 18, 1)
	manageSoftware.setBackgroundColor(colors.lime)
	manageSoftware.setTextColor(colors.white)
	manageSoftware.clear()
	manageSoftware.write(lang.softManager)
end

local function isminimized(prog)
	local exists = false
	for _, program in ipairs(minimized) do
		if prog == program then
			exists = true
			break
		else
			exists = false
		end
	end
	if exists == true then
		return true
	else
		return false
	end
end

function drawDesktop()
	desktopWindow = window.create(oldTerm, 1, 1, 51, 19)
	term.redirect(desktopWindow)
	clear(colors.black, colors.white)
	paintutils.drawImage(wallpaper, 1, 1)
	term.setCursorPos(1,1)
	term.setBackgroundColor(colors.lightGray)
	term.setTextColor(colors.white)
	term.clearLine()
	term.setBackgroundColor(colors.gray)
	term.write(" @ ")
	term.setCursorPos(51,1)
	term.setBackgroundColor(colors.red)
	term.write("S")
	term.setCursorPos(50,1)
	term.setBackgroundColor(colors.blue)
	term.write("R")
	desktop = true
	onDesktop = true
	_startmen = false
	taskmgr = false
	set = false
	seachB = false
	_sftmngr = false
	while desktop do
		evt = {os.pullEventRaw()}

		if onDesktop then
			for _, a in pairs(t.c) do
				local stat = coroutine.status(t.c[_])
				if evt[1] == "mouse_click" or evt[1] == "mouse_drag" or evt[1] == "mouse_up" or evt[1] == "mouse_down" or evt[1] == "key" or evt[1] == "char" then
					if _ == progList[selectedProg] and stat == "suspended" and isminimized(_) == false then
						term.redirect(t.w[_])
						coroutine.resume(t.c[_], unpack(evt))
					end
				elseif stat == "suspended" then
					term.redirect(t.w[_])
					coroutine.resume(t.c[_], unpack(evt))
				elseif stat == "dead" then
					t.c[_] = nil
					t.w[_] = nil
					t.uw[_] = nil
					t.xA[_] = nil
					t.yA[_] = nil
					t.xO[_] = nil
					t.yO[_] = nil
					redrawDesktop()
					drawWindows()
				end
			end
		end
		local event = evt[1]
		local button = evt[2]
		local x = evt[3]
		local y = evt[4]
		term.redirect(oldTerm)
		if event == "mouse_click" and button == 1 and x >= 1 and x <= 3 and y == 1 then
			if _startmen then
				redrawDesktop()
				_startmen = false
				searchB = false
				taskmgr = false
				set = false
				_sftmngr = false
				local exists = false
				for _, a in ipairs(minimized) do
					if a == progList[selectedProg] then
						exists = true
						break
					else
						exists = false
					end
				end
				if exists == false then
					drawWindows(progList[selectedProg])
				else
					drawWindows()
				end
			else
				redrawStartup()
				_startmen = true
			end
		elseif event == "mouse_click" and button == 1 and x == 51 and y == 1 then
			os.shutdown()
		elseif event == "mouse_click" and button == 1 and x == 50 and y == 1 then
			os.reboot()
		elseif event == "mouse_click" and button == 1 and x >= 2 and x <= 14 and y == 3 and searchB then
			term.redirect(searchBar)
			term.setCursorPos(1,1)
			term.clear()
			searchBox.clear()
			search = sys.limitRead(13)
			if #search > 0 then
				reSearch(search)
			else
				redrawStartup()
			end
			term.redirect(desktopWindow)
		elseif event == "mouse_click" and button == 1 and x == 12 and y == 19 and searchB then
			onDesktop = false
			drawSettings()
		elseif event == "mouse_click" and button == 1 and x >= 16 and x <= 33 and y == 3 and set then
			term.redirect(usrTxtBx)
			term.setCursorPos(1,1)
			term.clear()
			tmpUsrNm = limitRead(18)
			if tmpUsrNm == nil or tmpUsrNm == "" then
				term.write(usrData.Username)
				term.redirect(oldTerm)
			else
				usrData.Username = tmpUsrNm
				sys.writeUsrData(usrData)
				term.redirect(oldTerm)
			end
		elseif event == "mouse_click" and button == 1 and x >= 16 and x <= 33 and y == 5 and set then
			term.redirect(pwTxtBx)
			term.setCursorPos(1,1)
			term.clear()
			tmpPw = limitRead(18,"*")
			if tmpPw == nil or tmpPw == "" then
				term.write("*****")
				term.redirect(oldTerm)
			else
				usrData.Password = sha.sha256(tmpPw)
				sys.writeUsrData(usrData)
				term.redirect(oldTerm)
			end
		elseif event == "mouse_click" and button == 1 and x >= 16 and x <= 33 and y == 7 and set then
			shell.run("/doorOS/API/np","/doorOS/sys/wllppr.nfp")
			wallpaper = paintutils.loadImage("/doorOS/sys/wllppr.nfp")
			drawDesktop()
		elseif event == "mouse_click" and button == 1 and x >= 16 and x <= 33 and y == 9 and set then
			set = false
			_sftmngr = true
			onDesktop = false
			drawSoftwareManager()
		elseif event == "mouse_scroll" and button == 1 and x >= 2 and x <= 14 and y >= 5 and y <= 17 and searchB and left > 0 then
			term.redirect(searchBox)
			term.scroll(1)
			term.setCursorPos(1,13)
			if missing+13+1 == selectedProg then
				term.setBackgroundColor(colors.lightBlue)
				term.clearLine()
			end
			term.write(progList[missing+13+1])
			term.setBackgroundColor(colors.gray)
			missing = missing+1
			left = left-1
			term.redirect(desktopWindow)
		elseif event == "mouse_scroll" and button == -1 and x >= 2 and x <= 14 and y >= 5 and y <= 17 and searchB and missing > 0 then
			term.redirect(searchBox)
			term.scroll(-1)
			term.setCursorPos(1,1)
			if missing == selectedProg then
				term.setBackgroundColor(colors.lightBlue)
				term.clearLine()
			end
			term.write(progList[missing])
			term.setBackgroundColor(colors.gray)
			missing = missing-1
			left = left+1
			term.redirect(desktopWindow)
		elseif event == "mouse_scroll" and button == 1 and taskLeft > 0 and x >= 17 and x <= 50 and y >= 3 and y <= 18 and taskmgr then
			term.redirect(tasklist)
			term.setTextColor(colors.lime)
			term.setBackgroundColor(colors.gray)
			term.scroll(1)
			term.setCursorPos(1, 16)
			local a = progList[taskMissing+16+1]
			for _, b in pairs(t.c) do
				if _ == a then
					term.write(_)
				end
			end
			--term.write(tasks[taskMissing+16+1])
			term.setCursorPos(34, 16)
			term.setBackgroundColor(colors.red)
			term.setTextColor(colors.white)
			term.write("X")
			term.setCursorPos(33, 16)
			term.setBackgroundColor(colors.blue)
			term.write(">")
			taskMissing = taskMissing+1
			taskLeft = taskLeft-1
			term.redirect(oldTerm)
		elseif event == "mouse_scroll" and button == -1 and taskMissing > 0 and x >= 17 and x <= 50 and y >= 3 and y <= 18 and taskmgr then
			term.redirect(tasklist)
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.lime)
			term.scroll(-1)
			term.setCursorPos(1, 1)
			local a = progList[taskMissing]
			for _, b in pairs(t.c) do
				if _ == a then
					term.write(_)
				end
			end
			--term.write(tasks[taskMissing])
			term.setCursorPos(34, 16)
			term.setBackgroundColor(colors.red)
			term.setTextColor(colors.white)
			term.write("X")
			term.setCursorPos(33, 16)
			term.setBackgroundColor(colors.blue)
			term.write(">")
			taskMissing = taskMissing-1
			taskLeft = taskLeft+1
			term.redirect(oldTerm)
		elseif event == "mouse_click" and taskmgr and button == 1 and x == 50 and y >= 3 and y <= 18 then
			term.setCursorPos(2,2)
			term.setBackgroundColor(colors.green)
			term.write("TRUE")
			local y = y-2
			if taskMissing+y <= taskMaximum then
				local a = ts[taskMissing+y]
				--table.remove(t.c, a)
				term.setCursorPos(2,2)
				term.setBackgroundColor(colors.green)
				term.write(a)
				t.c[a] = nil
				t.w[a] = nil
				t.uw[a] = nil
				t.xA[a] = nil
				t.yA[a] = nil
				t.xO[a] = nil
				t.yO[a] = nil
				--table.remove(tasks, taskMissing+y)
				--[[table.remove(t.w, a)
				table.remove(t.uw, a)
				table.remove(t.xA, a)
				table.remove(t.yA, a)
				table.remove(t.xO, a)
				table.remove(t.yO, a)]]
				--table.remove(taskWindows, taskMissing+y)
				--tasks[taskMissing+y] = nil
				--taskWindows[taskMissing+y] = nil
				drawTaskManager()
			end
		elseif event == "mouse_click" and taskmgr and button == 1 and x == 49 and y >= 3 and y <= 18 then
			local y = y-2
			if taskMissing+y <= taskMaximum then
				local program = ts[taskMissing+y]
				redrawDesktop()
				drawWindows(program)
			end
		elseif event == "mouse_click" and button == 1 and x >= 2 and x <= 14 and y >= 5 and y <= 17 and searchB and maximum > 0 then
			local y = y-4
			local sel = missing+y
			oldMissing = missing
			oldLeft = left
			newMissing = 0
			newLeft = #progList-13
			missing = 0
			left = 0
			maximum = #progList
			local counter = 0
			if sel <= maximum then
					selectedProg = sel
					redrawStartup()
			end
		elseif event == "mouse_click" and searchB and selectedProg > 0 and button == 1 and x >= 2 and x <= 8 and y == 19 then
			searchB = false
			_startmen = false
			desktop = true
			onDesktop = true
			term.redirect(oldTerm)
			local progNumber = "Fill"
			--if #tasks == 0 then tasks[1] = "Fill" end
			--for _, program in ipairs(tasks) do
			for _, program in pairs(t.c) do
				if _ == progList[selectedProg] then
					progNumber = progList[selectedProg]
					new = false
					break
				end
			end
			if new == false then
				redrawDesktop()
				onDesktop = true
				for _, program in pairs(t.c) do
				--for _, program in ipairs(tasks) do
					if _ == progList[selectedProg] then
						drawWindows(_)
					end
				end

			else

				redrawDesktop()
				onDesktop = true
				local program = progList[selectedProg]
				--table.insert(taskWindows, progList[selectedProg])
				t.uw[program] = window.create(oldTerm, 1, 2, 51, 18)
				t.uw[program].setBackgroundColor(colors.lightGray)
				t.uw[program].setTextColor(colors.white)
				t.uw[program].clear()
				t.tb[program] = window.create(t.uw[program], 1, 1, 51, 1)
				t.tb[program].setBackgroundColor(colors.cyan)
				t.tb[program].clear()

				t.tb[program].setCursorPos(1,1)
				t.tb[program].setBackgroundColor(colors.gray)
				t.tb[program].write("M")
				t.tb[program].setBackgroundColor(colors.cyan)
				t.tb[program].write(" "..program)
				t.tb[program].setCursorPos(51,1)
				t.tb[program].setBackgroundColor(colors.red)
				t.tb[program].write("X")
				t.tb[program].setBackgroundColor(colors.green)
				t.tb[program].setCursorPos(50,1)
				t.tb[program].write("^")
				t.tb[program].setBackgroundColor(colors.orange)
				t.tb[program].setCursorPos(49,1)
				t.tb[program].write("_")
				t.w[program] = window.create(t.uw[program], 2, 2, 49, 16)
				--taskWindows[program] = window.create(oldTerm, 1, 1, 51, 19)
				t.c[program] = coroutine.create(runProg)
				t.w[program].setBackgroundColor(colors.black)
				t.w[program].setTextColor(colors.white)
				t.w[program].setCursorPos(1,1)
				t.w[program].clear()
				t.xA[program] = 1
				t.yA[program] = 2
				t.xO[program] = 51
				t.yO[program] = 19
				drawWindows(program)
				--table.insert(tasks, progList[selectedProg])
				--[[for _, program in ipairs(tasks) do
					if program == progList[selectedProg] then
						tasks[program] = coroutine.create(runProg)
						taskWindows[program].setBackgroundColor(colors.black)
						taskWindows[program].setTextColor(colors.white)
						taskWindows[program].setCursorPos(1,1)
						taskWindows[program].clear()
						drawWindow(program, program)
					end
				end]]
				--[[table.insert(taskWindows, "test")
				taskWindows["test"] = window.create(oldTerm, 1, 1, 51, 19)
				table.insert(tasks, "test")
				for _, program in ipairs(tasks) do
					if program == "test" then
						tasks[program] = coroutine.create(runProg)
						taskWindows[program].setBackgroundColor(colors.black)
						taskWindows[program].setTextColor(colors.white)
						taskWindows[program].setCursorPos(1,1)
						taskWindows[program].clear()
						drawWindow(program, program, true)
						break
					end
				end]]
			end
		elseif event == "mouse_click" and searchB and x == 10 and y == 19 and button == 1 then
			set = false
			_sftmngr = false
			onDesktop = false
			drawTaskManager()
			taskmgr = true
		elseif event == "mouse_click" and button == 1 and _sftmngr and x == 50 and y >= 9 and y <= 18 then
			local y = y-8
			if y <= progMaximum then
				local selectedProg = progList[y]
				--if taskMissing+y <= taskMaximum then
				for _, prog in pairs(t.c) do
					if selectedProg == _ then
						--table.remove(tasks, _)
						
						--table.remove(taskWindows, _)
						t.c[_] = nil
						t.w[_] = nil
						t.uw[_] = nil
						t.xA[_] = nil
						t.yA[_] = nil
						t.xO[_] = nil
						t.yO[_] = nil
						--tasks[taskMissing+y] = nil
						--taskWindows[taskMissing+y] = nil
					end
				end
				fs.delete("/doorOS/apps/"..selectedProg..".app")
				redrawStartup()
				drawSoftwareManager()
			end
		elseif event == "mouse_scroll" and button == 1 and _sftmngr and progLeft > 0 and x >= 17 and x <= 50 and y >= 9 and y <= 18 then
			term.redirect(softList)
			term.scroll(1)
			progMissing = progMissing+1
			progLeft = progLeft-1
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.lime)
			term.setCursorPos(1, 10)
			term.write(progList[progLeft+10+1])
			term.setCursorPos(34, 10)
			term.setBackgroundColor(colors.red)
			term.setTextColor(colors.white)
			term.write("X")
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.lime)
			term.redirect(oldTerm)
		elseif event == "mouse_scroll" and button == -1 and _sftmngr and progMissing > 0 and x >= 17 and x <= 50 and y >= 9 and y <= 18 then
			term.redirect(softList)
			term.scroll(-1)
			progMissing = progMissing-1
			progLeft = progLeft+1
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.lime)
			term.setCursorPos(1,1)
			term.write(progList[progMissing])
			term.setCursorPos(34,1)
			term.setBackgroundColor(colors.red)
			term.setTextColor(colors.white)
			term.write("X")
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.lime)
			term.redirect(oldTerm)
		elseif event == "mouse_click" and button == 1 and _sftmngr and x >= 17 and x <= 50 and y == 5 then
			term.redirect(installTxtBx)
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.lime)
			term.clear()
			term.setCursorPos(1,1)
			local eingabe = read()
			if #eingabe < 1 then
				term.redirect(oldTerm)
				installTxtBx.write(lang.enterInstallPath)
			else
				if fs.exists(eingabe) then
					a = eingabe
					term.setCursorPos(1,1)
					term.clear()
					term.write("Enter name..")
					sleep(2)
					term.setCursorPos(1,1)
					term.clear()
					local eingabe = read()
					if #eingabe < 1 then
						term.redirect(oldTerm)
						installTxtBx.setCursorPos(1,1)
						installTxtBx.clear()
						installTxtBx.write(lang.enterInstallPath)
					else
						if fs.exists("/doorOS/apps/"..eingabe..".app") then
							term.setCursorPos(1,1)
							term.setTextColor(colors.red)
							term.clear()
							term.write(lang.alreadyExists)
							sleep(2)
							term.setCursorPos(1,1)
							term.clear()
							term.setTextColor(colors.lime)
							term.write(lang.enterInstallPath)
							term.redirect(oldTerm)
						else
							b = eingabe
							fs.makeDir("/doorOS/apps/"..b..".app")
							local file = fs.open(a, "r")
							local installer = file.readLine()
							--installer = textutils.unserialize(installer)
							file.close()

							--if type(installer) == "table" and installer.installable then
							if installer == "--installable" then
								local ok, err = shell.run(a, "/doorOS/apps/"..b..".app/")
								if ok then
									term.redirect(oldTerm)
									
									redrawStartup()
									drawSoftwareManager()
								else
									fs.delete("/doorOS/apps/"..b..".app")
									term.setTextColor(colors.red)
									term.setCursorPos(1,1)
									term.clear()
									term.write(lang.errorInstaller)
									term.setTextColor(colors.lime)
									sleep(2)
									term.setCursorPos(1,1)
									term.clear()
									term.write(lang.enterInstallPath)
									term.redirect(oldTerm)
								end
							else
								fs.delete("/doorOS/apps/"..b..".app")
								term.setCursorPos(1,1)
								term.setTextColor(colors.red)
								term.clear()
								term.write(lang.notAnInstaller)
								term.setTextColor(colors.lime)
								term.setCursorPos(1,1)
								sleep(2)
								term.clear()
								term.write(lang.enterInstallPath)
								term.redirect(oldTerm)
							end
						end
					end
				else
					term.clear()
					term.setCursorPos(1,1)
					term.setTextColor(colors.red)
					term.write(lang.fileNotFound)
					term.setTextColor(colors.lime)
					term.redirect(oldTerm)
				end
			end	
		elseif event == "mouse_click" and onDesktop then
			local sel = nil
			
			for _, a in pairs(t.xA) do
				local _bx = t.xA[_]
				local _by = t.yA[_]
				local _ox = t.xO[_]
				local _oy = t.yO[_]
				if x > a and x < _ox-2 and y >= _by and y <= _oy and isminimized(_) == false and _ == progList[selectedProg] then
					for m, a in ipairs(progList) do
						if a == _ then
							selectedProg = nil
							selectedProg = m
							sel = a
						end
					end
					drawWindows(_)
				elseif x > a and x < _ox-2 and y >= _by and y <= _oy and isminimized(_) == false and _ ~= progList[selectedProg] then
					local z = progList[selectedProg]
					if t.xA[z] ~= nil and x >= t.xA[z] and x <= t.xO[z] and y >= t.yA[z] and y <= t.yO[z] then

					else
						for m, a in ipairs(progList) do
							if a == _ then
								selectedProg = nil
								selectedProg = m
								sel = a
							end
						end
						drawWindows(_)
					end
				end
				sel = progList[selectedProg]
			end
			local bx = t.xA[progList[selectedProg]]
			local by = t.yA[progList[selectedProg]]
			local ox = t.xO[progList[selectedProg]]
			local oy = t.yO[progList[selectedProg]]
			if bx ~= nil then
				if x == ox-2 and y == by and sel == progList[selectedProg] then
					table.insert(minimized, sel)
					t.uw[sel].setVisible(false)
					redrawDesktop()
					drawWindows()
				elseif x == ox and y == by then
					t.c[sel] = nil
					t.w[sel] = nil
					t.uw[sel] = nil
					t.xA[sel] = nil
					t.yA[sel] = nil
					t.xO[sel] = nil
					t.yO[sel] = nil
					for n, a in ipairs(minimized) do
						if a == sel then
							table.remove(minimized, n)
						end
					end
					redrawDesktop()
					drawWindows()
				elseif x == ox-1 and y == by and sel == progList[selectedProg] then
					t.xA[sel] = 1
					t.yA[sel] = 2
					t.xO[sel] = 51
					t.yO[sel] = 19
					t.uw[sel].reposition(1,2,51,18)
					t.tb[sel].reposition(1,1,51,1)
					t.w[sel].reposition(2,2,49,16)
					t.tb[sel].setBackgroundColor(colors.cyan)
					t.tb[sel].clear()
					t.tb[sel].setCursorPos(1,1)
					t.tb[sel].setBackgroundColor(colors.gray)
					t.tb[sel].write("M")
					t.tb[sel].setBackgroundColor(colors.cyan)
					t.tb[sel].write(" "..sel)
					t.tb[sel].setBackgroundColor(colors.red)
					local x, y = t.tb[sel].getSize()
					t.tb[sel].setCursorPos(x, 1)
					t.tb[sel].write("X")
					t.tb[sel].setBackgroundColor(colors.green)
					t.tb[sel].setCursorPos(x-1, 1)
					t.tb[sel].write("^")
					t.tb[sel].setBackgroundColor(colors.orange)
					t.tb[sel].setCursorPos(x-2, y)
					t.tb[sel].write("_")
					redrawDesktop()
					drawWindows(sel)
					local x, y = t.uw[sel].getSize()

					local counter = 2
					repeat
						t.uw[sel].setBackgroundColor(colors.lightGray)
						t.uw[sel].setCursorPos(x, counter)
						t.uw[sel].write(" ")
						counter = counter+1
					until counter == y+1
					bx = t.xA[sel]
					by = t.yA[sel]
					ox = t.xO[sel]
					oy = t.yO[sel]
				elseif x == bx and y == by and sel == progList[selectedProg] then
					repeat
						local m, b, nx, ny = os.pullEvent()
						if m == "mouse_drag" and ny > 1 then
							local w = t.xO[sel]-t.xA[sel]+1
							local h = t.yO[sel]-t.yA[sel]+1
							t.xA[sel] = nx
							t.yA[sel] = ny
							
							t.xO[sel] = nx+w-1
							t.yO[sel] = ny+h-1
							t.uw[sel].reposition(nx, ny)
							redrawDesktop()
							drawWindows(sel)

						end
					until m == "mouse_up"
					bx = t.xA[sel]
					by = t.yA[sel]
					ox = t.xO[sel]
					oy = t.yO[sel]
				elseif x == ox and y == oy and sel == progList[selectedProg] then
					repeat
						local m, b, nx, ny = os.pullEvent()
						if m == "mouse_drag" then
							local oldWidth = t.xO[sel]-t.xA[sel]+1
							local oldHeight = t.yO[sel]-t.yA[sel]+1
							local newWidth = nx-t.xA[sel]+1
							local newHeight = ny-t.yA[sel]+1
							t.xO[sel] = nx
							t.yO[sel] = ny
								
							t.uw[sel].reposition(t.xA[sel], t.yA[sel], newWidth, newHeight)
							t.uw[sel].clear()
							t.w[sel].reposition(2, 2, newWidth-2, newHeight-2)
							t.w[sel].redraw()
							t.tb[sel].reposition(1,1, newWidth, 1)
							t.tb[sel].setBackgroundColor(colors.cyan)
							t.tb[sel].clear()
							t.tb[sel].setCursorPos(1,1)
							t.tb[sel].setBackgroundColor(colors.gray)
							t.tb[sel].write("M")
							t.tb[sel].setBackgroundColor(colors.cyan)
							t.tb[sel].write(" "..sel)
							t.tb[sel].setBackgroundColor(colors.red)
							local x, y = t.tb[sel].getSize()
							t.tb[sel].setCursorPos(x, 1)
							t.tb[sel].write("X")
							t.tb[sel].setBackgroundColor(colors.green)
							t.tb[sel].setCursorPos(x-1, 1)
							t.tb[sel].write("^")
							t.tb[sel].setBackgroundColor(colors.orange)
							t.tb[sel].setCursorPos(x-2, y)
							t.tb[sel].write("_")

							redrawDesktop()
							drawWindows(sel)
							local x, y = t.uw[sel].getSize()

							local counter = 2
							repeat
								t.uw[sel].setBackgroundColor(colors.lightGray)
								t.uw[sel].setCursorPos(x, counter)
								t.uw[sel].write(" ")
								counter = counter+1
							until counter == y+1
						end
					until m == "mouse_up"
					local x, y = t.uw[sel].getSize()

					local counter = 2
					repeat
						t.uw[sel].setBackgroundColor(colors.lightGray)
						t.uw[sel].setCursorPos(x, counter)
						t.uw[sel].write(" ")
						counter = counter+1
					until counter == y+1
					bx = t.xA[sel]
					by = t.yA[sel]
					ox = t.xO[sel]
					oy = t.yO[sel]
				end
			end
		end
	end
end


function runProg()
	shell.run("/doorOS/apps/"..progList[selectedProg]..".app/startup")
end

function reSearch(eingabe)
	local last = term.current()
	term.redirect(searchBox)
	progListRaw = fs.list("/doorOS/apps/")
	progList = {}
	term.clear()
	left = 0
	missing = 0
	maximum = 0
	for _, folder in ipairs(progListRaw) do
		local name, extension = string.match(folder, "(.*)%.(.*)")
		if extension == "app" then
			if name:match(eingabe) == eingabe then

				table.insert(progList, name)
			end
		end
	end
	left = #progList-13
	if left < 0 then left = 0 end
	maximum = #progList
	term.setCursorPos(1,1)
	for _, file in ipairs(progList) do
		if _ == 14 then
			break
		else
			if selectedProg == _ then
				term.setBackgroundColor(colors.lightBlue)
				term.clearLine()
				term.write(file)
				term.setBackgroundColor(colors.gray)
				local x, y = term.getCursorPos()
				term.setCursorPos(1, y+1)
			else
				term.write(file)
				local x, y = term.getCursorPos()
				term.setCursorPos(1, y+1)
			end
		end
	end
	if selectedProg > 0 then
		term.redirect(startmenu)
		term.setCursorPos(2,18)
		term.setBackgroundColor(colors.lime)
		term.setTextColor(colors.white)
		term.write("       ")
		term.setCursorPos(3,18)
		term.write(lang.Run) --Maximum 5 character
	end
	term.redirect(oldTerm)
end

local function getTableLength(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

function drawTaskManager()
	taskmanager = window.create(oldTerm, 16, 2, 36, 18)
	taskmanager.setBackgroundColor(colors.lightGray)
	taskmanager.setTextColor(colors.white)
	taskmanager.clear()
	term.redirect(taskmanager)
	tasklist = window.create(taskmanager, 2, 2, 34, 16)
	tasklist.setBackgroundColor(colors.gray)
	tasklist.setTextColor(colors.lime)
	tasklist.clear()
	term.redirect(tasklist)
	term.setCursorPos(1,1)
	taskMissing = 0
	taskMaximum = getTableLength(t.c)
	taskLeft = taskMaximum-16
	ts = {}
	for _ in pairs(t.c) do
		table.insert(ts, _)
	end
	taskmgr = true
	if taskLeft < 0 then taskLeft = 0 end
	local counter = 1
	for _, program in ipairs(ts) do
		if counter == 17 then
			break
		else
			term.write(program)
			local x, y = term.getCursorPos()
			term.setCursorPos(34, y)
			term.setBackgroundColor(colors.red)
			term.write("X")
			term.setCursorPos(33, y)
			term.setBackgroundColor(colors.blue)
			term.write(">")
			term.setBackgroundColor(colors.gray)
			term.setCursorPos(1, y+1)
			counter = counter+1
		end
	end

end

function drawWindow(app, windownumber)
	desktop = false
	--taskWindows[app].redraw()
	t.w[app].redraw()
	--term.redirect(taskWindows[app])
	term.redirect(t.w[app])
	local progNumber = 0
	local running = false
	for _, program in pairs(t.c) do
	--for _, program in ipairs(tasks) do
		if _ == app then
			running = true
			progNumber = _
			--progNumber = program
		end
	end
	local evt = {}
	while running do
		
		coroutine.resume(t.c[progNumber], unpack(evt))
		--coroutine.resume(tasks[progNumber], unpack(evt))
		evt = {os.pullEvent()}

		if evt[1] == "key" and evt[2] == 211 then
			redrawDesktop()
			running = false
			break
		end
		status = coroutine.status(tasks[progNumber])
		if status == "dead" then
			redrawDesktop()
			running = false
			break
		end
	end
end

function drawWindows(app)
  for _, a in pairs(t.uw) do
  	local b = isminimized(_)
  		if b == false then
  			t.uw[_].setVisible(true)
  			t.uw[_].redraw()
  		else
  			t.uw[_].setVisible(false)
  		end
  end

  if app ~= nil then
 	 if t.uw[app] then
 	 	t.uw[app].setVisible(true)
 	 	for _, a in ipairs(minimized) do
 	 		if app == a then
 	 			table.remove(minimized, _)
 	 		end
 	 	end
 	 	t.uw[app].redraw()
	 end
  end
  running = true
  onDesktop = true
end

function drawSoftwareManager()
	softMngr = window.create(oldTerm, 16, 2, 36, 18)
	softMngr.setBackgroundColor(colors.lightGray)
	softMngr.setTextColor(colors.white)
	softMngr.clear()
	term.redirect(softMngr)
	term.setCursorPos(2, 2)
	term.write(lang.install)
	installTxtBx = window.create(softMngr, 2, 4, 34, 1)
	installTxtBx.setBackgroundColor(colors.gray)
	installTxtBx.setTextColor(colors.lime)
	installTxtBx.clear()
	installTxtBx.write(lang.enterInstallPath)
	term.setCursorPos(2, 6)
	term.setTextColor(colors.white)
	term.write(lang.deleteSoftware)
	softList = window.create(softMngr, 2, 8, 34, 10)
	softList.setBackgroundColor(colors.gray)
	softList.setTextColor(colors.lime)
	softList.clear()
	progListRaw = fs.list("/doorOS/apps/")
	progList = {}
	for _, folder in ipairs(progListRaw) do
		local name, extension = string.match(folder, "(.*)%.(.*)")
		if extension == "app" then
			table.insert(progList, name)
		end
	end
	progMissing = 0
	progLeft = #progList-10
	progMaximum = #progList
	term.redirect(softList)
	term.setBackgroundColor(colors.gray)
	term.setTextColor(colors.lime)
	for _, file in ipairs(progList) do
		if _ == 11 then
			break
		else
			term.write(file)
			local x, y = term.getCursorPos()
			term.setCursorPos(34, y)
			term.setBackgroundColor(colors.red)
			term.setTextColor(colors.white)
			term.write("X")
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.lime)
			term.setCursorPos(1, y+1)
		end
	end
end

function redrawStartup()
	onDesktop = false
	startmenu = window.create(oldTerm, 1, 2, 15, 18)
	startmenu.setBackgroundColor(colors.cyan)
	startmenu.setTextColor(colors.black)
	startmenu.clear()
	searchB = true
	searchBar = window.create(startmenu, 2, 2, 13, 1)
	searchBar.setBackgroundColor(colors.gray)
	searchBar.setTextColor(colors.lime)
	searchBar.clear()
	searchBar.write(lang.SearchApp)
	searchBox = window.create(startmenu, 2, 4, 13, 13)
	searchBox.setBackgroundColor(colors.gray)
	searchBox.setTextColor(colors.white)
	searchBox.clear()
	startmenu.setCursorPos(10, 18)
	startmenu.setBackgroundColor(colors.gray)
	startmenu.setTextColor(colors.lime)
	startmenu.write("T")
	startmenu.setCursorPos(12, 18)
	startmenu.setBackgroundColor(colors.gray)
	startmenu.setTextColor(colors.lime)
	startmenu.write("S")
	if selectedProg > 0 then
		startmenu.setCursorPos(2, 17)
		startmenu.setBackgroundColor(colors.cyan)
		startmenu.setTextColor(colors.white)
		startmenu.write(progList[selectedProg])
	end
	left = 0
	missing = 0
	maximum = 0
	progListRaw = fs.list("/doorOS/apps/")
	progList = {}
	for _, folder in ipairs(progListRaw) do
		local name, extension = string.match(folder, "(.*)%.(.*)")
		if extension == "app" then
			table.insert(progList, name)
		end
	end
	left = #progList-13
	if left < 0 then left = 0 end
	maximum = #progList
	term.redirect(searchBox)
	term.setTextColor(colors.lime)
	term.setBackgroundColor(colors.gray)
	for _, file in ipairs(progList) do
		if _ == 14 then
			break
		else
			if selectedProg == _ then
				term.setBackgroundColor(colors.lightBlue)
				term.clearLine()
				term.write(file)
				term.setBackgroundColor(colors.gray)
				local x, y = term.getCursorPos()
				term.setCursorPos(1, y+1)
			else
				term.write(file)
				local x, y = term.getCursorPos()
				term.setCursorPos(1, y+1)
			end
		end
	end
	if selectedProg > 0 then
		runButton = window.create(startmenu, 2, 18, 7, 1)
		runButton.setBackgroundColor(colors.lime)
		runButton.setTextColor(colors.white)
		runButton.clear()
		runButton.write(lang.Run)
	end
	term.redirect(oldTerm)
end

function redrawDesktop()
	desktopWindow.redraw()
	desktop = true
	_startmen = false
	taskmgr = false
	set = false
	seachB = false
	_sftmngr = false
	onDesktop = true
end

function readd(replaceChar)
	term.setCursorBlink(true)
	local cX, cY = term.getCursorPos()
	local eingabe = ""

	if replaceChar == "" then replaceChar = nil end
	repeat
		local event, key = os.pullEvent()
		if event == "char" then
			eingabe = eingabe..key
			write(replaceChar or key)
		elseif event == "key" and key == keys.backspace and #eingabe >= 1 then
			--Lösche den letzten Buchstaben
			eingabe = string.sub(eingabe, 1, #eingabe-1)	--eingabe ist eingabe vom 1. buchstaben vom alten eingabe bis zu einem buchstaben weniger
			local xPos, yPos = term.getCursorPos()
			term.setCursorPos(xPos-1, yPos)
			write(" ")
			term.setCursorPos(xPos-1, yPos)
		end

	until event == "key" and key == keys.enter
	term.setCursorBlink(false)
	return eingabe
end

function limitRead(nLimit, replaceChar)
    term.setCursorBlink(true)
    local cX, cY = term.getCursorPos()
    local rString = ""
    if replaceChar == "" then replaceChar = nil end
    repeat
        local event, p1 = os.pullEvent()
        if event == "char" then
            -- Character event
            if #rString + 1 <= nLimit then
                rString = rString .. p1
                write(replaceChar or p1)
            end
        elseif event == "key" and p1 == keys.backspace and #rString >= 1 then
            -- Backspace
            rString = string.sub(rString, 1, #rString-1)
            xPos, yPos = term.getCursorPos()
            term.setCursorPos(xPos-1, yPos)
            write(" ")
            term.setCursorPos(xPos-1, yPos)
        end
    until event == "key" and p1 == keys.enter
    term.setCursorBlink(false)
    --print() -- Skip to the next line after clicking enter.
    return rString
end

function clear(bg, fg)
	term.setCursorPos(1,1)
	term.setBackgroundColor(bg)
	term.setTextColor(fg)
	term.clear()
end

--Code
clear(colors.black, colors.white)
term.setCursorPos(1,1)
print("OS Version: ".._verstr)
sleep(2)
clear(colors.black, colors.white)

if fs.exists("/doorOS/sys/usrData") then
	usrData = sys.readUsrData()
	print(usrData.Language)
	lang = sys.loadLanguage(usrData.Language)
	drawLogin()
else
	shell.run("/doorOS/API/sys firstrun")
end