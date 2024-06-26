/datum/codex_entry/apc
	associated_paths = list(/obj/machinery/power/apc)
	mechanics_text = "An APC (Area Power Controller) regulates and supplies backup power for the area they are in. Their power channels are divided \
	out into 'environmental' (Items that manipulate airflow and temperature), 'lighting' (the lights), and 'equipment' (Everything else that consumes power).<br>\
	Power consumption and backup power cell charge can be seen from the interface, further controls (turning a specific channel on, off or automatic, \
	toggling the APC's ability to charge the backup cell, or toggling power for the entire area via master breaker) first requires the interface to be unlocked \
	with an ID with Engineering access or by one of the station's robots or the artificial intelligence."
	antag_text = "This can be <span codexlink='cryptographic sequencer'>emagged</span> to unlock it.  It will cause the APC to have a blue error screen. \
	Wires can be pulsed remotely with a signaler attached to it.  A powersink will also drain any APCs connected to the same wire the powersink is on."

/datum/codex_entry/inflatable_item
	associated_paths = list(/obj/item/inflatable)
	mechanics_text = "Inflate by using it in your hand.  The inflatable barrier will inflate on your tile.  To deflate it, use the 'deflate' verb."

/datum/codex_entry/inflatable_deployed
	associated_paths = list(/obj/structure/inflatable)
	mechanics_text = "To remove these safely, use the 'deflate' verb.  Hitting these with any objects will probably puncture and break it forever."

/datum/codex_entry/inflatable_door
	associated_paths = list(/obj/structure/inflatable/door)
	mechanics_text = "Click the door to open or close it.  It only stops air while closed.<br>\
	To remove these safely, use the 'deflate' verb.  Hitting these with any objects will probably puncture and break it forever."

/datum/codex_entry/welding_pack
	associated_paths = list(/obj/item/weldpack)
	mechanics_text = "This pack acts as a portable source of welding fuel. Use a <l>welder</l> on it to refill its tank - but make sure it's not lit!<br>\
	You can use this kit on a fuel tank or appropriate reagent dispenser to replenish its reserves."
	lore_text = "Incident-065-134 was an industrial accident of note that occurred at Manufacturing Site 065. An apprentice welder failed to properly seal her fuel port, \
	triggering a chain reaction that vaporized a crew of seven. Don't let this happen to you!"
	antag_text = "In theory, you could hold an open flame to this pack and produce some pretty catastrophic results. The trick is getting out of the blast radius."

/datum/codex_entry/gripper
	associated_paths = list(/obj/item/gripper)
	mechanics_text = "Click an item to pick it up with your gripper. Use it as you would normally use anything in your hand. The Drop Item verb will allow you to release the item."

/datum/codex_entry/diffuser_item
	associated_paths = list(/obj/item/shield_diffuser)
	mechanics_text = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern), in a similar way the <span codexlink='shield diffuser'>floor mounted variant</span> does. \
	It is, however, portable and run by an internal battery. Can be recharged with a regular recharger."
