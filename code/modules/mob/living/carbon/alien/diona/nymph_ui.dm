/atom/movable/screen/intent/diona_nymph
	icon = 'icons/mob/gestalt.dmi'
	icon_state = "intent_devour"
	screen_loc = DIONA_SCREEN_LOC_INTENT

/atom/movable/screen/intent/diona_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_expel"
	else
		intent = I_DISARM
		icon_state = "intent_devour"

/atom/movable/screen/diona
	icon = 'icons/mob/gestalt.dmi'

/atom/movable/screen/diona/hat
	name = "equipped hat"
	screen_loc = DIONA_SCREEN_LOC_HAT
	icon_state = "hat"

/atom/movable/screen/diona/hat/Click()
	var/mob/living/carbon/alien/diona/chirp = usr
	if(istype(chirp) && chirp.hat)
		chirp.unEquip(chirp.hat)

/atom/movable/screen/diona/held
	name = "held item"
	screen_loc =  DIONA_SCREEN_LOC_HELD
	icon_state = "held"

/atom/movable/screen/diona/held/Click()
	var/mob/living/carbon/alien/diona/chirp = usr
	if(istype(chirp) && chirp.holding_item) chirp.unEquip(chirp.holding_item)

/datum/hud/diona_nymph
	var/atom/movable/screen/diona/hat/hat
	var/atom/movable/screen/diona/held/held

/datum/hud/diona_nymph/FinalizeInstantiation()

	src.adding = list()
	src.other = list()

	hat = new
	adding += hat

	held = new
	adding += held

	action_intent = new /atom/movable/screen/intent/diona_nymph()
	adding += action_intent

	mymob.healths = new /atom/movable/screen()
	mymob.healths.icon = 'icons/mob/gestalt.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.SetName("health")
	mymob.healths.screen_loc = DIONA_SCREEN_LOC_HEALTH

	mymob.client.screen = list(mymob.healths)
	mymob.client.screen += src.adding + src.other
