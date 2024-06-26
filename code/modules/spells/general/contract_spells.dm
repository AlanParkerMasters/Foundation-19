//These spells are given to the owner of a contract when a victim signs it.
//As such they are REALLY REALLY powerful (because the victim is rewarded for signing it, and signing contracts is completely voluntary)

/datum/spell/contract
	name = "Contract Spell"
	desc = "A spell perfecting the techniques of keeping a servant happy and obedient."

	spell_flags = 0
	invocation = "none"
	invocation_type = INVOKE_NONE


	var/mob/subject

/datum/spell/contract/New(mob/M)
	..()
	subject = M
	name += " ([M.real_name])"

/datum/spell/contract/choose_targets(mob/user = usr)
	perform(user, list(subject))

/datum/spell/contract/cast(mob/target,mob/user)
	if(!subject)
		to_chat(usr, "This spell was not properly given a target. Contact a coder.")
		return null

	if(istype(target,/list))
		target = target[1]
	return target


/datum/spell/contract/reward
	name = "Reward Contractee"
	desc = "A spell that makes your contracted victim feel better."

	charge_max = 300
	cooldown_min = 100

	hud_state = "wiz_jaunt_old"

/datum/spell/contract/reward/cast(mob/living/target,mob/user)
	target = ..(target,user)
	if(!target)
		return

	to_chat(target, SPAN_INFO("You feel great!"))
	target.ExtinguishMob()

/datum/spell/contract/punish
	name = "Punish Contractee"
	desc = "A spell that sets your contracted victim ablaze."

	charge_max = 300
	cooldown_min = 100

	hud_state = "gen_immolate"

/datum/spell/contract/punish/cast(mob/living/target,mob/user)
	target = ..(target,user)
	if(!target)
		return

	to_chat(target, SPAN_DANGER("You feel punished!"))
	target.fire_stacks += 15
	target.IgniteMob()
