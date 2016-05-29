--Base System API
--Should Handle background stuff
--e.g. first start, loading and decrypting user stuff, etc.

--Variablen
_ver = 0.1
_verstr = "0.1"

--Funktionen
function clear(bg, fg)
	term.setCursorPos(1,1)
	term.setBackgroundColor(bg)
	term.setTextColor(fg)
	term.clear()
end

