/atom/movable/screen/psi/hub
	name = "Psi"
	icon_state = "psi_suppressed"
	screen_loc = "EAST-1:28,CENTER-3:11"
	hidden = FALSE
	maptext_x = 6
	maptext_y = -8
	var/image/on_cooldown
	var/list/components

/atom/movable/screen/psi/hub/New(mob/living/_owner)
	on_cooldown = image(icon, "cooldown")
	components = list(
		new /atom/movable/screen/psi/armour(_owner),
		new /atom/movable/screen/psi/toggle_psi_menu(_owner, src)
		)
	..()
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/psi/hub/on_update_icon()

	if(!owner.psi)
		return

	icon_state = owner.psi.suppressed ? "psi_suppressed" : "psi_active"
	if(world.time < owner.psi.next_power_use)
		add_overlay(on_cooldown)
	else
		cut_overlays()
	var/offset = 1
	for(var/thing in components)
		var/atom/movable/screen/psi/component = thing
		component.update_icon()
		if(!component.invisibility) component.screen_loc = "EAST-[++offset]:28,CENTER-3:11"

/atom/movable/screen/psi/hub/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	owner = null
	for(var/thing in components)
		qdel(thing)
	components.Cut()
	. = ..()

/atom/movable/screen/psi/hub/Process()
	if(!istype(owner))
		qdel(src)
		return
	if(!owner.psi)
		return
	maptext = "[round((owner.psi.stamina/owner.psi.max_stamina)*100)]%"
	update_icon()

/atom/movable/screen/psi/hub/Click(location, control, params)
	var/list/click_params = params2list(params)
	if(click_params["shift"])
		owner.show_psi_assay(owner)
		return

	if(owner.psi.suppressed && owner.psi.stun)
		to_chat(owner, SPAN_WARNING("You are dazed and reeling, and cannot muster enough focus to do that!"))
		return

	owner.psi.suppressed = !owner.psi.suppressed
	to_chat(owner, SPAN_NOTICE("You are <b>[owner.psi.suppressed ? "now suppressing" : "no longer suppressing"]</b> your psi-power."))
	if(owner.psi.suppressed)
		owner.psi.cancel()
		owner.psi.hide_auras()
	else
		sound_to(owner, sound('sounds/effects/psi/power_unlock.ogg'))
		owner.psi.show_auras()
	update_icon()
