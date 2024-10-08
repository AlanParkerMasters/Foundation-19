// /program/ files are executable programs that do things.
/datum/computer_file/program
	abstract_type = /datum/computer_file/program
	filetype = "PRG"
	/// File name. FILE NAME MUST BE UNIQUE IF YOU WANT THE PROGRAM TO BE DOWNLOADABLE FROM SCiPnet!
	filename = "UnknownProgram"
	/// User-friendly name of this program.
	var/filedesc = "Unknown Program"
	/// Short description of this program's function.
	var/extended_desc = "N/A"
	/// Icon to use for program's link in main menu
	var/program_menu_icon = "window-maximize-o"

	/// Program-specific screen icon state
	var/program_icon_state = null
	/// Program-specific keyboard icon state
	var/program_key_state = "standby_key"

	/// List of required accesses to download the program.
	var/required_access = null
	/// Whether the program can be downloaded from SCiPnet. Set to FALSE to disable.
	var/available_on_ntnet = TRUE
	/// Whether the program can be downloaded from SyndiNet (accessible via emagging the computer). Set to TRUE to enable.
	var/available_on_syndinet = FALSE
	/// Program doesn't show up in main menu, cant be in PROGRAM_STATE_ACTIVE, autoran on download, etc. Used by viruses
	var/program_malicious = FALSE
	/// Bitflags (PROGRAM_CONSOLE, PROGRAM_LAPTOP, PROGRAM_TABLET, PROGRAM_PDA combination) or PROGRAM_ALL
	var/usage_flags = PROGRAM_ALL & ~PROGRAM_PDA

	/// Set to 1 for program to require nonstop SCiPnet connection to run. If SCiPnet connection is lost program crashes.
	var/requires_ntnet = FALSE
	/// Optional, if above is set to 1 checks for specific function of SCiPnet (currently NTNET_SOFTWAREDOWNLOAD, NTNET_PEERTOPEER, NTNET_SYSTEMCONTROL and NTNET_COMMUNICATION)
	var/requires_ntnet_feature = 0
	/// Optional string that describes what SCiPnet server/system this program connects to. Used in default logging.
	var/network_destination = null


	/// If the program uses NanoModule, put it here and it will be automagically opened. Otherwise implement ui_interact.
	var/datum/nano_module/NM = null
	/// Path to nanomodule, make sure to set this if implementing new program.
	var/nanomodule_path = null

	/// If the program uses TGUIModule, put it here and it will be automagically opened. Otherwise implement tgui_interact.
	var/datum/tgui_module/TM = null
	/// Path to tguimodule, make sure to set this if implementing new program.
	var/tguimodule_path = null

	var/tgui_id


	/// PROGRAM_STATE_KILLED or PROGRAM_STATE_BACKGROUND or PROGRAM_STATE_ACTIVE - specifies whether this program is running.
	var/program_state = PROGRAM_STATE_KILLED
	/// Device that runs this program.
	var/obj/item/modular_computer/computer
	/// SCiPnet status, updated every tick by computer running this program. Don't use this for checks if SCiPnet works, computers do that. Use this for calculations, etc.
	var/ntnet_status = 1
	/// GQ/s - current network connectivity transfer rate
	var/ntnet_speed = 0
	/// Set to TRUE if computer that's running us was emagged. Computer updates this every Process() tick
	var/computer_emagged = FALSE
	/// Example: "something.gif" - a header image that will be rendered in computer's UI when this program is running at background. Images are taken from /nano/images/status_icons. Be careful not to use too large images!
	var/ui_header = null

/datum/computer_file/program/New(obj/item/modular_computer/comp = null)
	..()
	if(comp && istype(comp))
		computer = comp

/datum/computer_file/program/Destroy()
	computer = null
	. = ..()

/datum/computer_file/program/nano_host()
	return computer.nano_host()

/datum/computer_file/program/tgui_host()
	return computer.tgui_host()

/datum/computer_file/program/clone()
	var/datum/computer_file/program/temp = ..()
	temp.required_access = required_access
	temp.nanomodule_path = nanomodule_path
	temp.filedesc = filedesc
	temp.program_icon_state = program_icon_state
	temp.requires_ntnet = requires_ntnet
	temp.requires_ntnet_feature = requires_ntnet_feature
	temp.usage_flags = usage_flags
	temp.program_malicious = program_malicious
	return temp

// Used by programs that manipulate data files.
/datum/computer_file/program/proc/get_data_file(filename)
	var/obj/item/stock_parts/computer/storage/hard_drive/HDD = computer.hard_drive
	if(!HDD)
		return
	var/datum/computer_file/data/F = HDD.find_file_by_name(filename)
	if(!istype(F))
		return
	return F

/datum/computer_file/program/proc/create_data_file(newname, data = "", file_type = /datum/computer_file/data)
	if(!newname)
		return
	var/obj/item/stock_parts/computer/storage/hard_drive/HDD = computer.hard_drive
	if(!HDD)
		return
	if(get_data_file(newname))
		return
	var/datum/computer_file/data/F = new file_type
	F.filename = newname
	F.stored_data = data
	F.calculate_size()
	if(HDD.store_file(F))
		return F

// Relays icon update to the computer.
/datum/computer_file/program/proc/update_computer_icon()
	if(computer)
		computer.update_icon()

// Attempts to create a log in global ntnet datum. Returns 1 on success, 0 on fail.
/datum/computer_file/program/proc/generate_network_log(text)
	if(computer)
		return computer.add_log(text)
	return 0

/datum/computer_file/program/proc/is_supported_by_hardware(hardware_flag = 0, loud = 0, mob/user = null)
	if(!(hardware_flag & usage_flags))
		if(loud && computer && user)
			to_chat(user, SPAN_WARNING("\The [computer] flashes: \"Hardware Error - Incompatible software\"."))
		return 0
	return 1

/datum/computer_file/program/proc/get_signal(specific_action = 0)
	if(computer)
		return computer.get_ntnet_status(specific_action)
	return 0

// Called by Process() on device that runs us, once every tick.
/datum/computer_file/program/proc/process_tick()
	update_netspeed()
	return 1

/datum/computer_file/program/proc/update_netspeed()
	ntnet_speed = 0
	switch(ntnet_status)
		if(1)
			ntnet_speed = NTNETSPEED_LOWSIGNAL
		if(2)
			ntnet_speed = NTNETSPEED_HIGHSIGNAL
		if(3)
			ntnet_speed = NTNETSPEED_ETHERNET

// Check if the user can download program. Only humans can download files.
// User has to wear their ID or have it inhand for ID Scan to work.
// Can also be called manually, with optional parameter being access_to_check to scan the user's ID
/datum/computer_file/program/proc/program_has_access(mob/living/user, loud = 0, access_to_check)
	// Admin override - allows operation of any computer as aghosted admin, as if you had any required access.
	if(isghost(user) && check_rights(R_ADMIN, 0, user))
		return 1

	if(!istype(user))
		return 0

	// Defaults to required_access
	if(!access_to_check)
		access_to_check = required_access
	if(!access_to_check) // No required_access, allow it.
		return 1

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		if(loud)
			to_chat(user, SPAN_NOTICE("\The [computer] flashes an \"RFID Error - Unable to scan ID\" warning."))
		return 0

	if(access_to_check in I.access)
		return 1
	else if(loud)
		to_chat(user, SPAN_NOTICE("\The [computer] flashes an \"Access Denied\" warning."))

// This attempts to retrieve header data for NanoUIs. If implementing completely new device of different type than existing ones
// always include the device here in this proc. This proc basically relays the request to whatever is running the program.
/datum/computer_file/program/proc/get_header_data()
	if(computer)
		return computer.get_header_data()
	return list()

// This is performed on program startup. May be overriden to add extra logic. Return TRUE on success, FALSE on failure.
// When implementing new program based device, use this to run the program.
/datum/computer_file/program/proc/run_program(mob/living/user)
	SHOULD_CALL_PARENT(TRUE)

	if(corrupt)
		computer.visible_message(SPAN_WARNING("Random bits flash on the screen of [computer] before it suddenly crashes!"), range = 4)
		computer.balloon_alert_to_viewers("blue screen of death!", vision_distance = 4)
		computer.forced_shutdown(10 SECONDS)
		return

	if(program_malicious)
		computer.idle_threads.Add(src)
		program_state = PROGRAM_STATE_BACKGROUND
	else
		computer.active_program = src
		if(nanomodule_path)
			NM = new nanomodule_path(src, new /datum/topic_manager/program(src), src)
			if(user)
				NM.using_access = user.GetAccess()
		if(tguimodule_path)
			TM = new tguimodule_path(src)
			if(user)
				TM.using_access = user.GetAccess()
		program_state = PROGRAM_STATE_ACTIVE

	if(requires_ntnet && network_destination)
		generate_network_log("Connection opened to [network_destination].")
	return TRUE

// Use this proc to kill the program. Designed to be implemented by each program if it requires on-quit logic, such as the SCPRC client.
/datum/computer_file/program/proc/kill_program(forced = 0)
	SHOULD_CALL_PARENT(TRUE)

	program_state = PROGRAM_STATE_KILLED
	if(requires_ntnet && network_destination)
		generate_network_log("Connection to [network_destination] closed.")
	QDEL_NULL(NM)
	if(TM)
		SStgui.close_uis(TM)
		qdel(TM)
		TM = null
	return 1

// This is called every tick when the program is enabled. Ensure you do parent call if you override it. If parent returns 1 continue with UI initialisation.
// It returns 0 if it can't run or if NanoModule was used instead. I suggest using NanoModules where applicable. // don't listen to that guy, nanomodules fucking SUCK
/datum/computer_file/program/tgui_interact(mob/user, datum/tgui/ui)
	if(program_state != PROGRAM_STATE_ACTIVE) // Our program was closed. Close the ui if it exists.
		if(ui)
			ui.close()
		return computer.tgui_interact(user)
	if(istype(NM))
		NM.ui_interact(user)
		return 0
	if(istype(TM))
		TM.tgui_interact(user)
		return 0
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui && tgui_id)
		ui = new(user, src, tgui_id, filedesc)
		ui.open()
	return 1

// CONVENTIONS, READ THIS WHEN CREATING NEW PROGRAM AND OVERRIDING THIS PROC:
// Topic calls are automagically forwarded from NanoModule this program contains.
// Calls beginning with "PRG_" are reserved for programs handling.
// Calls beginning with "PC_" are reserved for computer handling (by whatever runs the program)
// ALWAYS INCLUDE PARENT CALL ..() OR DIE IN FIRE.
/datum/computer_file/program/Topic(href, href_list)
	if(..())
		return 1
	if(computer)
		return computer.Topic(href, href_list)

// CONVENTIONS, READ THIS WHEN CREATING NEW PROGRAM AND OVERRIDING THIS PROC:
// Topic calls are automagically forwarded from NanoModule this program contains.
// Calls beginning with "PRG_" are reserved for programs handling.
// Calls beginning with "PC_" are reserved for computer handling (by whatever runs the program)
// ALWAYS INCLUDE PARENT CALL ..() OR DIE IN FIRE.
/datum/computer_file/program/tgui_act(action,list/params, datum/tgui/ui)
	if(..())
		return 1
	if(computer)
		switch(action)
			if("PC_exit")
				computer.kill_program()
				ui.close()
				return 1
			if("PC_shutdown")
				computer.shutdown_computer()
				ui.close()
				return 1
			if("PC_minimize")
				var/mob/user = usr
				if(!computer.active_program)
					return

				computer.idle_threads.Add(computer.active_program)
				program_state = PROGRAM_STATE_BACKGROUND // Should close any existing UIs

				computer.active_program = null
				computer.update_icon()
				ui.close()

				if(user && istype(user))
					computer.tgui_interact(user) // Re-open the UI on this computer. It should show the main screen now.

// Relays the call to nano module, if we have one
/datum/computer_file/program/proc/check_eye(mob/user)
	if(NM)
		return NM.check_eye(user)
	if(TM)
		return TM.check_eye(user)
	else
		return -1

/obj/item/modular_computer/initial_data()
	return get_header_data()

/obj/item/modular_computer/update_layout()
	return TRUE

/datum/nano_module/program
	available_to_ai = FALSE
	var/datum/computer_file/program/program = null	// Program-Based computer program that runs this nano module. Defaults to null.

/datum/nano_module/program/New(host, topic_manager, program)
	..()
	src.program = program

/datum/topic_manager/program
	var/datum/program

/datum/topic_manager/program/New(datum/program)
	..()
	src.program = program

// Calls forwarded to PROGRAM itself should begin with "PRG_"
// Calls forwarded to COMPUTER running the program should begin with "PC_"
/datum/topic_manager/program/Topic(href, href_list)
	return program && program.Topic(href, href_list)

/datum/computer_file/program/apply_visual(mob/M)
	if(NM)
		NM.apply_visual(M)

/datum/computer_file/program/remove_visual(mob/M)
	if(NM)
		NM.remove_visual(M)
