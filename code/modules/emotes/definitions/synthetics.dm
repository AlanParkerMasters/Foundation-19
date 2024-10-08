/decl/emote/audible/synth
	key = "beep"
	emote_message_3p = "beeps."
	emote_sound = 'sounds/machines/twobeep.ogg'

/decl/emote/audible/synth/check_user(mob/living/user)
	if(istype(user) && user.isSynthetic())
		return ..()
	return FALSE

/decl/emote/audible/synth/ping
	key = "ping"
	emote_message_3p = "pings."
	emote_sound = 'sounds/machines/ping.ogg'

/decl/emote/audible/synth/buzz
	key = "buzz"
	emote_message_3p = "buzzes."
	emote_sound = 'sounds/machines/buzz-sigh.ogg'

/decl/emote/audible/synth/confirm
	key = "confirm"
	emote_message_3p = "emits an affirmative blip."
	emote_sound = 'sounds/machines/synth_yes.ogg'

/decl/emote/audible/synth/deny
	key = "deny"
	emote_message_3p = "emits a negative blip."
	emote_sound = 'sounds/machines/synth_no.ogg'

/decl/emote/audible/synth/security
	key = "law"
	emote_message_3p = "shows USER_HIS legal authorization barcode."
	emote_message_3p_target = "shows TARGET USER_THEIR legal authorization barcode."
	emote_sound = 'sounds/voice/biamthelaw.ogg'

/decl/emote/audible/synth/security/check_user(mob/living/silicon/robot/user)
	return (istype(user) && istype(user.module,/obj/item/robot_module/security))

/decl/emote/audible/synth/security/halt
	key = "halt"
	emote_message_3p = "USER's speakers skreech, \"Halt! Security!\"."
	emote_sound = 'sounds/voice/halt.ogg'
