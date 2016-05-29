enc = os.loadAPI("enc")

--Base System API
--Should Handle background stuff
--e.g. first start, loading and decrypting user stuff, etc.

--Variablen
_ver = 0.1
_verstr = "0.1"
usrData = {}

--Funktionen
function clear(bg, fg)
	term.setCursorPos(1,1)
	term.setBackgroundColor(bg)
	term.setTextColor(fg)
	term.clear()
end

function readUsrData()
	local file = fs.open("/doorOS/sys/usrData","r")
	local inhalt = file.readAll()
	local inhalt = textutils.unseralize(inhalt)
	usrData = inhalt
	file.close()
	return usrData
end

function writeUsrData()
	local file = fs.open("/doorOS/sys/usrData","w")
	file.write(textutils.seralize(usrData))
	file.close()
end

function firstStart()
	clear(colors.blue, colors.white)
	oldTerm = term.native()
	grayWindow = window.create(oldTerm, 15, 5, 20, 10)
	term.redirect(grayWindow)
	term.setBackgroundColor(colors.lightGray)
	term.clear()
	term.setCursorPos(1,1)
	term.write("Welcome to")
	term.setCursorPos(1,2)
	term.write("the Installation.")
	term.setCursorPos(2, 9)
	term.setBackgroundColor(colors.lime)
	term.write("Exit")
	term.setCursorPos(16, 9)
	term.write("Next")
	page1 = true
	while page1 do
		local event, button, x, y = os.pullEventRaw("mouse_click")

		if button == 1 and x >= 16 and x <= 19  and y == 13 then
			page1 = false
			clear(colors.black, colors.white)
			break
		end
	end
end