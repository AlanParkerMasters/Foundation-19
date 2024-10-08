/*
//////////////////////////////////////

Coughing

	Noticable.
	Little Resistance.
	Doesn't increase stage speed much.
	Transmissibile.
	Low Level.

BONUS
	Spreads the virus in a small square around the host.
	Can force the affected mob to drop small items!

//////////////////////////////////////
*/

/datum/symptom/cough
	name = "Cough"
	desc = "The virus irritates the throat of the host, causing occasional coughing. Each cough will try to infect bystanders who are within 1 tile of the host with the virus."
	stealth = -1
	resistance = 3
	stage_speed = 1
	transmittable = 2
	level = 1
	severity = 1
	base_message_chance = 15
	symptom_delay_min = 2
	symptom_delay_max = 15
	var/spread_range = 1
	threshold_descs = list(
		"Resistance 11" = "The host will drop small items when coughing.",
		"Resistance 15" = "Occasionally causes coughing fits that stun the host. The extra coughs do not spread the virus.",
		"Stage Speed 6" = "Increases cough frequency.",
		"Transmission 7" = "Coughing will now infect bystanders up to 2 tiles away.",
		"Stealth 4" = "The symptom remains hidden until active.",
	)

/datum/symptom/cough/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 11) //strong enough to drop items
		power = 1.5
	if(A.properties["resistance"] >= 15) //strong enough to stun (occasionally)
		power = 2
	if(A.properties["stage_rate"] >= 6) //cough more often
		symptom_delay_max = 10
	if(A.properties["transmittable"] >= 7)
		spread_range = 2
	if(A.properties["stealth"] >= 4)
		suppress_warning = TRUE

/datum/symptom/cough/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3)
			if(prob(base_message_chance) && !suppress_warning)
				to_chat(M, "<span notice='warning'>[pick("You swallow excess mucus.", "You lightly cough.")]</span>")
		else
			M.emote("cough")
			if(M.CanSpreadAirborneDisease())
				A.Spread(spread_range)
			if(power >= 1.5)
				var/obj/item/I = M.get_active_hand()
				if(I && I.w_class == ITEM_SIZE_SMALL)
					M.drop_from_inventory(I)
			if(power >= 2 && prob(30))
				to_chat(M, "<span notice='userdanger'>[pick("You have a coughing fit!", "You can't stop coughing!")]</span>")
				M.Stun(20)
				addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "cough"), 6)
				addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "cough"), 12)
				addtimer(CALLBACK(M, TYPE_PROC_REF(/mob, emote), "cough"), 18)
