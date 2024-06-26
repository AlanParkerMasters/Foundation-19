/datum/spell/targeted/equip_item/holy_relic
	name = "Summon Holy Relic"
	desc = "This spell summons a relic of purity into your hand for a short while. The relic will disrupt occult and magical energies - be wary, as this includes your own."
	charge_type = SPELL_RECHARGE
	spell_flags = NEEDSCLOTHES | INCLUDEUSER
	invocation = "Yee'Ro Su!"
	invocation_type = INVOKE_SHOUT
	range = 0
	max_targets = 1
	level_max = list(UPGRADE_TOTAL = 2, UPGRADE_SPEED = 1, UPGRADE_POWER = 1)
	charge_max = 60 SECONDS
	duration = 25 SECONDS
	cooldown_min = 35 SECONDS
	delete_old = 0
	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "purge1"

	equipped_summons = list("active hand" = /obj/item/nullrod)

/datum/spell/targeted/equip_item/holy_relic/cast(list/targets, mob/user = usr)
	..()
	for(var/mob/M in targets)
		M.visible_message(SPAN_DANGER("A rod of metal appears in \the [M]'s hand!"))

/datum/spell/targeted/equip_item/holy_relic/ImproveSpellPower()
	if(!..())
		return 0

	duration += 50

	return "The holy relic now lasts for [duration/10] seconds."
