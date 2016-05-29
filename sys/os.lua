dec = os.loadAPI("/doorOS/API/encrypt")
os.loadAPI("/doorOS/API/sys")

--Main OS 

--Variablen
_ver = 0.1
_verstr = "0.1"
key = ""
usrData = {
	Username = "",
	Password = "",
	Language = "",
}
lang = {
	
}


--Funktionen

function drawLogin()

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
else
	shell.run("/doorOS/API/sys")
end