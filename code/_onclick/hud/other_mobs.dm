/mob/living/carbon/slime
	hud_type = /datum/hud/slime

/datum/hud/slime/FinalizeInstantiation(ui_style = 'icons/mob/screen1_Midnight.dmi')
	src.adding = list()

	var/atom/movable/screen/using

	using = new /atom/movable/screen/intent()
	src.adding += using
	action_intent = using

	mymob.client.screen = list()
	mymob.client.screen += src.adding

/mob/living/simple_animal/construct
	hud_type = /datum/hud/construct

/datum/hud/construct/FinalizeInstantiation()
	var/constructtype

	if(istype(mymob,/mob/living/simple_animal/construct/armoured) || istype(mymob,/mob/living/simple_animal/construct/behemoth))
		constructtype = "juggernaut"
	else if(istype(mymob,/mob/living/simple_animal/construct/builder))
		constructtype = "artificer"
	else if(istype(mymob,/mob/living/simple_animal/construct/wraith))
		constructtype = "wraith"
	else if(istype(mymob,/mob/living/simple_animal/construct/harvester))
		constructtype = "harvester"

	if(constructtype)
		mymob.fire = new /atom/movable/screen()
		mymob.fire.icon = 'icons/mob/screen1_construct.dmi'
		mymob.fire.icon_state = "fire0"
		mymob.fire.SetName("fire")
		mymob.fire.screen_loc = ui_construct_fire

		mymob.healths = new /atom/movable/screen()
		mymob.healths.icon = 'icons/mob/screen1_construct.dmi'
		mymob.healths.icon_state = "[constructtype]_health0"
		mymob.healths.SetName("health")
		mymob.healths.screen_loc = ui_construct_health

		mymob.pullin = new /atom/movable/screen()
		mymob.pullin.icon = 'icons/mob/screen1_construct.dmi'
		mymob.pullin.icon_state = "pull0"
		mymob.pullin.SetName("pull")
		mymob.pullin.screen_loc = ui_construct_pull

		mymob.zone_sel = new /atom/movable/screen/zone_sel()
		mymob.zone_sel.icon = 'icons/mob/screen1_construct.dmi'
		mymob.zone_sel.overlays.len = 0
		mymob.zone_sel.add_overlay(image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]"))

		mymob.purged = new /atom/movable/screen()
		mymob.purged.icon = 'icons/mob/screen1_construct.dmi'
		mymob.purged.icon_state = "purge0"
		mymob.purged.SetName("purged")
		mymob.purged.screen_loc = ui_construct_purge

	mymob.client.screen = list()
	mymob.client.screen += list(mymob.fire, mymob.healths, mymob.pullin, mymob.zone_sel, mymob.purged)
