/obj/item/robot_module/janitor
	name = "janitorial robot module"
	display_name = "Janitor"
	channels = list(
		"Service" = TRUE
	)
	sprites = list(
		"Android - Basic Janitor"  = "janitorrobot",
		"Android - Custodian Tech"  = "sanitaryrobot",
		"Android - Cleaner"  = "cleanerrobot",
		"Mop Gear Rex" = "mopgearrex"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/soap,
		/obj/item/storage/bag/trash,
		/obj/item/mop/advanced,
		/obj/item/holosign_creator,
		/obj/item/device/lightreplacer,
		/obj/item/borg/sight/hud/jani,
		/obj/item/device/plunger/robot,
		/obj/item/crowbar,
		/obj/item/weldingtool
	)
	emag = /obj/item/reagent_containers/spray

/obj/item/robot_module/janitor/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/slippery_oil, 250)
	emag.SetName("Slippery oil spray")

/obj/item/robot_module/janitor/respawn_consumable(mob/living/silicon/robot/R, amount)
	..()
	var/obj/item/device/lightreplacer/LR = locate() in equipment
	LR.Charge(R, amount)
	if(emag)
		var/obj/item/reagent_containers/spray/S = emag
		S.reagents.add_reagent(/datum/reagent/slippery_oil, 20 * amount)
