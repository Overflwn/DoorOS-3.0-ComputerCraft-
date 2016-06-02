os.loadAPI("/doorOS/API/encrypt")
os.loadAPI("/doorOS/API/sys")

--Main OS 

--Variablen
_ver = 1.6
_verstr = "1.6"
key = ""
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
wallpaper = paintutils.loadImage("/doorOS/sys/wllppr")
missing = 0
left = 0
maximum = 0
search = ""
progList = {}
selectedProg = 0
tasks = {}
taskWindows = {}
selectedTask = 0
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

function drawRightWindow()

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
	desktop = true
	startmenu = false
	taskmanager = false
	while desktop do
		local event, button, x, y = os.pullEventRaw()
		if event == "mouse_click" and button == 1 and x >= 1 and x <= 3 and y == 1 then
			if startmenu then
				redrawDesktop()
				startmenu = false
				searchB = false
				taskmgr = false
			else
				redrawStartup()
				startmenu = true
			end
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
			term.write(tasks[taskMissing+16+1])
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
		elseif event == "mouse_scroll" and button == 1 and taskMissing > 0 and x >= 17 and x <= 50 and y >= 3 and y <= 18 and taskmgr then
			term.redirect(tasklist)
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.lime)
			term.scroll(-1)
			term.setCursorPos(1, 1)
			term.write(tasks[taskMissing])
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
			local y = y-2
			if taskMissing+y <= taskMaximum then
				tasks[taskMissing+y] = nil
				taskWindows[taskMissing+y] = nil
				drawTaskManager()
			end
		elseif event == "mouse_click" and taskmgr and button == 1 and x == 49 and y >= 3 and y <= 18 then
			local y = y-2
			if taskMissing+y <= taskMaximum then
				local program = tasks[taskMissing+y]
				drawWindow(program, program)
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
			startmenu = false
			desktop = false
			term.redirect(oldTerm)
			local progNumber = "Fill"
			if #tasks == 0 then tasks[1] = "Fill" end
			for _, program in ipairs(tasks) do
				if program == progList[selectedProg] then
					progNumber = progList[selectedProg]
					new = false
					break
				elseif program == "Fill" then
					progNumber = progList[selectedProg]
					new = true
					tasks[1] = nil
				end
				progNumber = progList[selectedProg]
				new = true
			end
			if new == false then
				for _, program in ipairs(tasks) do
					if program == progList[selectedProg] then
						drawWindow(program, program)
					end
				end

			else
				local program = progList[selectedProg]
				table.insert(taskWindows, progList[selectedProg])
				taskWindows[program] = window.create(oldTerm, 1, 1, 51, 19)
				table.insert(tasks, progList[selectedProg])
				for _, program in ipairs(tasks) do
					if program == progList[selectedProg] then
						tasks[program] = coroutine.create(runProg)
						taskWindows[program].setBackgroundColor(colors.black)
						taskWindows[program].setTextColor(colors.white)
						taskWindows[program].setCursorPos(1,1)
						taskWindows[program].clear()
						drawWindow(program, program)
					end
				end
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
			drawTaskManager()
			taskmgr = true
		end
	end
end


function runProg(prog)
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
	taskLeft = #tasks-16
	taskMaximum = #tasks
	taskmgr = true
	for _, program in ipairs(tasks) do
		if _ == 17 then
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
			
		end
	end

end

function drawWindow(app, windownumber)
	taskWindows[app].redraw()
	term.redirect(taskWindows[app])
	local progNumber = 0
	local running = false
	for _, program in ipairs(tasks) do
		if program == app then
			running = true
			progNumber = program
		end
	end
	local evt = {}
	while running do
		
		coroutine.resume(tasks[progNumber], unpack(evt))
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

function redrawStartup()
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

function redrawDesktop()
	desktopWindow.redraw()
	desktop = true
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

function loadKey()
	shell.run("pastebin get sUzJjBgz /.tmp")
	local file = fs.open("/.tmp","r")
	key = file.readAll()
	file.close()
	fs.delete("/.tmp")
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
	loadKey()
	usrData.Password = encrypt.decrypt(usrData.Password, key)
	drawLogin()
else
	shell.run("/doorOS/API/sys firstrun")
end