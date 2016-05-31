dec = os.loadAPI("/doorOS/API/encrypt")
os.loadAPI("/doorOS/API/sys")

--Main OS 

--Variablen
_ver = 0.1
_verstr = "0.1"
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
oldTerm = term.native()

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
	usrTxtBx.write(lang.Username)
	pwTxtBx = window.create(term.current(), 2, 4, 18, 1)
	pwTxtBx.setBackgroundColor(colors.gray)
	pwTxtBx.setTextColor(colors.lime)
	pwTxtBx.clear()
	pwTxtBx.write(lang.Password)
	term.setCursorPos(2,8)
	term.setBackgroundColor(colors.lime)
	term.setTextColor(colors.white)
	term.write(" > ")
	local login = true
	while login do
		local event, button, x, y = os.pullEvent("mouse_click")
		if button == 1 and x >= 16 and x <= 33 and y == 6 then
			term.redirect(usrTxtBx)
			term.setCursorPos(1,1)
			term.clear()
			tmpUsrNm = sys.limitRead(18)
			term.redirect(loginWindow)
		end 
	end
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
	drawLogin()
else
	shell.run("/doorOS/API/sys firstrun")
end