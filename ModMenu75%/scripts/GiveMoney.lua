function GiveMoney()
	globals.set_int(1964171, 1)
	sleep(15)
	globals.set_int(1964171, 2)
	sleep (3)
	globals.set_int(1964171, 0)
end

function GiveMoney2()
	sleep(12)
	globals.set_int(1964171, 2)
	sleep(4)
	globals.set_int(1964171, 0)
	sleep(4)
	globals.set_int(1964171, 2)
	sleep(4)
	globals.set_int(1964171, 0)
	sleep(4)
	globals.set_int(1964171, 2)
	sleep(4)
	globals.set_int(1964171, 0)
	sleep(4)
	globals.set_int(1964171, 2)
	sleep(4)
	globals.set_int(1964171, 0)
end

function GiveMoney3()
	globals.set_int(1964171, 2)
	sleep(4)
	globals.set_int(1964171, 0)
end

function Reset()
	globals.set_int(1964171, 0)
end

menu.add_action("----------------[Give Money]---------------", function() end)
menu.add_action("Give 3 Mil", GiveMoney2)
menu.add_action("Give 1.5 Mil", GiveMoney)
menu.add_action("Give 750K", GiveMoney3)
menu.add_action("Reset", Reset)
menu.add_action("----------------------------------------------", function() end)