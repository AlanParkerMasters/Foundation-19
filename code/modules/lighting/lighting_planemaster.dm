/obj/lighting_plane
	screen_loc = "1,1"
	plane = LIGHTING_PLANE

	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	// use 20% ambient lighting; be sure to add full alpha

	color = list(
			-1, 00, 00, 00,
			00, -1, 00, 00,
			00, 00, -1, 00,
			00, 00, 00, 00,
			01, 01, 01, 01
		)

	mouse_opacity = MOUSE_OPACITY_TRANSPARENT    // nothing on this plane is mouse-visible

/obj/lighting_general
	plane = LIGHTING_PLANE
	screen_loc = "CENTER"

	icon = LIGHTING_ICON
	icon_state = LIGHTING_ICON_STATE_DARK

	color = "#ffffff"

	blend_mode = BLEND_MULTIPLY

/obj/lighting_general/Initialize()
	. = ..()

/obj/lighting_general/proc/sync(new_colour)
	color = new_colour

/mob
	var/obj/lighting_plane/l_plane
	var/obj/lighting_general/l_general


/mob/proc/change_light_colour(new_colour)
	if(l_general)
		l_general.sync(new_colour)

/mob/proc/update_lighting_size()
	if(!client)
		return
	if(!l_general)
		return

	var/list/actual_size = getviewsize(client.view)
	l_general.transform = matrix(actual_size[1], 0, 0, 0, actual_size[2], 0)
