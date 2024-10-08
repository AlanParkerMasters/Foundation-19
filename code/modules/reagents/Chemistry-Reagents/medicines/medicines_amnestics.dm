/datum/reagent/medicine/amnestics
	name = "Amnestics"
	description = "Amnestics are applied to remove or alter memories from a target, often to different degrees."
	taste_description = "something you already forgot"
	reagent_state = LIQUID
	color = "#ff0080"
	color_weight = 25
	addiction_types = list(/datum/addiction/amnestics = 5)
	var/isamnesticized = FALSE //failsafe to make sure players aren't amnesticized twice from the same dosage
	var/threshold = 5 //threshold for sleep.

/datum/reagent/medicine/amnestics/classa
	name = "Class-A Amnestics"
	description = "Class-A amnestics cause retrograde of the subject's short-term memory. Every 5 units administered results in the loss of the last 10 minutes."
	color = "#dd0030"
	metabolism = 0.5 //higher metabolism, since class-a's are usually given in higher doses
	overdose = 30 //30 units * 2 minutes each = maximum of an hour in a single dose.
	value = 15
	addiction_types = list(/datum/addiction/amnestics = 5)

/datum/reagent/medicine/amnestics/classa/affect_blood(mob/living/carbon/M, removed)

	if((volume <= 0.55) && !isamnesticized) //when the amnestic is fully metabolized, trigger amnesia
		isamnesticized = TRUE
		M.visible_message(SPAN_WARNING("[M] looks confused for a moment."))
		to_chat(M, "<font size='5' color='red'>Your recent memories are fading away... You completely forget the last [round(M.chem_doses[type], 1) * 2] minutes.</font>")

	if(prob(10))
		M.adjust_drowsiness(5 SECONDS)
	if(prob(35))
		M.adjust_dizzy_up_to(15 SECONDS, 100 SECONDS)

/datum/reagent/medicine/amnestics/classa/overdose(mob/living/carbon/M, removed)
	M.adjustBrainLoss(14 * removed)

/datum/reagent/medicine/amnestics/classb
	name = "Class-B Amnestics"
	description = "Class-B amnestics cause regressive retrograde of the subject's long-term memory. Every unit administered results in the loss of a full day."
	color = "#00D9D9"
	overdose = 15 //15 units * 1 day each = maximum of 15 days in a single dose
	value = 20
	addiction_types = list(/datum/addiction/amnestics = 15)

/datum/reagent/medicine/amnestics/classb/affect_blood(mob/living/carbon/M, removed)
	if((volume <= 0.25) && !isamnesticized)
		isamnesticized = TRUE
		M.visible_message(SPAN_WARNING("[M] looks confused."))
		to_chat(M, "<font size='5' color='red'>Your memories are melting away... You have lost all memory of the last [round(M.chem_doses[type], 1)] days.</font>")

	if(prob(15))
		M.adjust_drowsiness(5 SECONDS)
	if(prob(35))
		M.adjust_dizzy_up_to(15 SECONDS, 100 SECONDS)

/datum/reagent/medicine/amnestics/classb/overdose(mob/living/carbon/M, removed)
	M.adjustBrainLoss(20 * removed)

/datum/reagent/medicine/amnestics/classc
	name = "Class-C Amnestics"
	description = "Class-C amnestics cause retrograde of targetted, specific memories."
	color = "#ffd900"
	overdose = 5
	threshold = 5
	value = 25
	addiction_types = list(/datum/addiction/amnestics = 30)

/datum/reagent/medicine/amnestics/classc/affect_blood(mob/living/carbon/M, removed)

	if(M.chem_doses[type] >= 4.8 && !isamnesticized)
		isamnesticized = TRUE
		M.visible_message(SPAN_WARNING("[M] looks deeply confused."))
		to_chat(M, "<font size='5' color='red'>Your memories are disappearing rapidly... You completely forget the existence of the anomalous, the Foundation, and anything else supernatural.</font>")

	M.add_chemical_effect(CE_SEDATE, 1) //sedative logic stolen from chloral hydrate.
	if (M.chem_doses[type] <= metabolism * threshold)
		M.adjust_confusion(2 SECONDS)
		M.adjust_drowsiness(2 SECONDS)
	else
		M.Weaken(30)
		M.set_eye_blur_if_lower(10 SECONDS)

	if(prob(35))
		M.adjust_dizzy_up_to(15 SECONDS, 100 SECONDS)

/datum/reagent/medicine/amnestics/classc/overdose(mob/living/carbon/M, removed)
	M.adjustBrainLoss(25 * removed)
	M.adjustToxLoss(5 * removed)

/datum/reagent/medicine/amnestics/classe
	name = "Class-E Amnestics"
	description = "Class-E amnestics induce complacency with the anomalous. They will remember all anomalous events, but act as if they're an ordinary part of life."
	taste_description = "something that's exceedingly normal"
	color = "#5c1942"
	overdose = 5
	value = 65
	addiction_types = list(/datum/addiction/amnestics = 20)

/datum/reagent/medicine/amnestics/classe/affect_blood(mob/living/carbon/M, removed)
	if(M.chem_doses[type] >= 4.8 && !isamnesticized)
		isamnesticized = TRUE
		M.visible_message(SPAN_WARNING("[M] looks calmer and more relaxed."))
		to_chat(M, "<font size='5' color='red'>Your memories alter irreparably... All of a sudden, the anomalous just feels like a normal part of your world, something not worth even mentioning.</font>")

	M.add_chemical_effect(CE_SEDATE, 1) //sedative logic stolen from chloral hydrate.
	if (M.chem_doses[type] <= metabolism * threshold)
		M.adjust_confusion(2 SECONDS)
		M.adjust_drowsiness(2 SECONDS)
	else
		M.Weaken(30)
		M.set_eye_blur_if_lower(10 SECONDS)

	if(prob(35))
		M.adjust_dizzy_up_to(15 SECONDS, 100 SECONDS)

/datum/reagent/medicine/amnestics/classe/overdose(mob/living/carbon/M, removed)
	M.adjustBrainLoss(20 * removed)
	M.adjustToxLoss(3 * removed)

/datum/reagent/medicine/amnestics/classf
	name = "Class-F Amnestics"
	description = "Class-F amnestics induce a permanent fugue state, causing the subject to completely forget their past identity."
	color = "#a0a0a0"
	overdose = 5
	threshold = 1
	value = 75
	addiction_types = list(/datum/addiction/amnestics = 100)

/datum/reagent/medicine/amnestics/classf/affect_blood(mob/living/carbon/M, removed)
	M.Weaken(10)
	if(M.chem_doses[type] >= 19.8 && !isamnesticized) //OD is lower than the amount of doses it needs to work. So you need to give it as an IV over a long time.
		isamnesticized = TRUE
		//No visible message because they are sleeping.
		to_chat(M, "<font size='5' color='red'> All your memories are melting away... You have lost every memory you hold dear and every aspect of your identity has been torn away. You will adopt whatever new personality is presented to you, if any.</font>")

	M.add_chemical_effect(CE_SEDATE, 1) //sedative logic stolen from chloral hydrate.
	if (M.chem_doses[type] <= metabolism * threshold)
		M.adjust_confusion(2 SECONDS)
		M.adjust_drowsiness(2 SECONDS)
	if (M.chem_doses[type] < 2 * threshold)
		M.Weaken(30)
		M.set_eye_blur_if_lower(10 SECONDS)
	else
		M.sleeping = max(M.sleeping, 30)
	M.add_chemical_effect(CE_BREATHLOSS, 1.5)
	if(prob(10))
		M.adjustBrainLoss(2.5 * removed)
	if(prob(35))
		M.adjust_dizzy_up_to(10 SECONDS, 100 SECONDS)

/datum/reagent/medicine/amnestics/classg
	name = "Class-G Amnestics"
	description = "Class-G amnestics gaslight the subject into distrusting their memory. They will remember all anomalous events, but believe them to be a dream or their imagination."
	taste_description = "forgotten dreams"
	color = "#0ca139"
	overdose = 5
	value = 45
	addiction_types = list(/datum/addiction/amnestics = 30)

/datum/reagent/medicine/amnestics/classg/affect_blood(mob/living/carbon/M, removed)
	if(M.chem_doses[type] >= 4.8 && !isamnesticized)
		isamnesticized = TRUE
		M.visible_message(SPAN_WARNING("[M] looks like \he just woke up from a dream."))
		to_chat(M, "<font size='5' color='red'> Your memories alter irreparably... You remember strange things happening, but it all must have just been an overactive imagination.</font>") //TODO

	M.add_chemical_effect(CE_SEDATE, 1) //sedative logic stolen from chloral hydrate.
	if (M.chem_doses[type] <= metabolism * threshold)
		M.adjust_confusion(2 SECONDS)
		M.adjust_drowsiness(2 SECONDS)
	else
		M.Weaken(30)
		M.set_eye_blur_if_lower(10 SECONDS)

	if(prob(35))
		M.adjust_dizzy_up_to(15 SECONDS, 100 SECONDS)

/datum/reagent/medicine/amnestics/classg/overdose(mob/living/carbon/M, removed)
	M.adjustBrainLoss(20 * removed)
	M.adjustToxLoss(3 * removed)

/datum/reagent/medicine/amnestics/classh
	name = "Class-H Amnestics"
	description = "Class-H amnestics cause anterograde, blocking formation of new memories. Every 5 units administered results in 400 seconds of effect."
	taste_description = "sickly bitterness"
	color = "#32e919"
	metabolism = 0.025
	overdose = 20 //20 units * 80 seconds each = maximum of 26.6 minutes in a single dose.
	value = 35
	addiction_types = list(/datum/addiction/amnestics = 10)

/datum/reagent/medicine/amnestics/classh/affect_blood(mob/living/carbon/M, removed)

	if((volume > 0.25) && !isamnesticized) //Upon initial check, inform about amnestic
		isamnesticized = TRUE
		M.visible_message(SPAN_WARNING("[M]'s eyes grow dim."))
		to_chat(M, "<font size='5' color='red'>It feels like a haze falls in your head... You can remember everything just fine, but you'll forget what happens later on.</font>")

	if((volume <= 0.25) && isamnesticized) //Once the amnestic wears off, re-inform about memory regain
		isamnesticized = FALSE
		M.visible_message(SPAN_WARNING("[M]'s eyes regain their focus."))
		to_chat(M, "<font size='5' color='red'>Your mind feels a lot clearer, but... You can't recall the last [2 * round(M.chem_doses[type], 1) / metabolism] seconds.</font>")

	if(prob(1))
		M.adjust_drowsiness(2 SECONDS)
	if(prob(2))
		M.adjust_dizzy_up_to(7 SECONDS, 100 SECONDS)

/datum/reagent/medicine/amnestics/classh/overdose(mob/living/carbon/M, removed)
	M.adjustBrainLoss(16 * removed)

/datum/reagent/medicine/amnestics/classi
	name = "Class-I Amnestics"
	description = "Class-I amnestics cause transient amnesia, preventing recall of the past. Every 5 units administered results in 400 seconds of effect."
	color = "#ef7dfa"
	metabolism = 0.025
	overdose = 20 //20 units * 80 seconds each = maximum of 26.6 minutes in a single dose.
	value = 30
	addiction_types = list(/datum/addiction/amnestics = 15)

/datum/reagent/medicine/amnestics/classi/affect_blood(mob/living/carbon/M, removed)

	if((volume > 0.25) && !isamnesticized) //Upon initial check, inform about amnestic
		isamnesticized = TRUE
		M.visible_message(SPAN_WARNING("[M] looks confused and scared, and \his eyes dart from side to side."))
		to_chat(M, "<font size='5' color='red'>You feel your memories slide beyond your gasp... You've lost the ability to remember anything for the next [2 * round(volume, 1) / metabolism] seconds.</font>")

	if((volume <= 0.25) && isamnesticized) //Once the amnestic wears off, re-inform about memory regain
		isamnesticized = FALSE
		M.visible_message(SPAN_WARNING("[M]'s eyes noticably recognize \his surroundings."))
		to_chat(M, "<font size='5' color='red'>Your memories suddenly rush back into place... You can remember your past again.</font>")

	if(prob(1))
		M.adjust_drowsiness(2 SECONDS)
	if(prob(2))
		M.adjust_dizzy_up_to(7 SECONDS, 100 SECONDS)

/datum/reagent/medicine/amnestics/classi/overdose(mob/living/carbon/M, removed)
	M.adjustBrainLoss(15 * removed)

//Pills and autoinjectors.
/obj/item/storage/pill_bottle/amnesticsa
	name = "pill bottle (Class-A Amnestics)"
	desc = "Contains Class-A Amnestics, used to erase recently-formed memories before they enter long-term storage."
	startswith = list(/obj/item/reagent_containers/pill/amnestics/classa = 14)
	wrapper_color = COLOR_RED

/obj/item/reagent_containers/pill/amnestics/classa
	name = "class a amnestic pill (10u)"
	icon_state = "pill1"
	desc = "Looking at this pill invokes a feeling of dread in you, although you can't remember actually taking it."

/obj/item/reagent_containers/pill/amnestics/classa/New()
	..()
	reagents.add_reagent(/datum/reagent/medicine/amnestics/classa, 10)
	color = reagents.get_color()

/obj/item/storage/pill_bottle/amnesticsb
	name = "pill bottle (Class-B Amnestics)"
	desc = "Contains Class-B Amnestics, used to erase memories from the last two weeks."
	startswith = list(/obj/item/reagent_containers/pill/amnestics/classb = 14)
	wrapper_color = COLOR_CYAN

/obj/item/reagent_containers/pill/amnestics/classb
	name = "class b amnestic pill (3u)"
	icon_state = "pill1"
	desc = "You're not sure why, but something about this pill gives a sense of sadness and loss."

/obj/item/reagent_containers/pill/amnestics/classb/New()
	..()
	reagents.add_reagent(/datum/reagent/medicine/amnestics/classb, 3)
	color = reagents.get_color()

/obj/item/reagent_containers/syringe/amnesticsc
	name = "Syringe (Class-C Amnestics)"
	desc = "A syringe filled with Class-C Amnestics. Used to erase the entire existence of the anomalous from someone's memory. Use only under supervision of medical staff."

/obj/item/reagent_containers/syringe/amnesticsc/New()
	..()
	reagents.add_reagent(/datum/reagent/medicine/amnestics/classc, 15)
	update_icon()

/obj/item/reagent_containers/syringe/amnesticse
	name = "Syringe (Class-E Amnestics)"
	desc = "A syringe filled with Class-E Amnestics. Used to psychologically normalize the anomalous. Use only under supervision of medical staff."

/obj/item/reagent_containers/syringe/amnesticse/New()
	..()
	reagents.add_reagent(/datum/reagent/medicine/amnestics/classe, 15)
	update_icon()

/obj/item/reagent_containers/ivbag/amnesticsf
	name = "\improper IV bag Class-F Amnestics"
	desc = "An IV bag filled with heavily diluted Class-F Amnestics. Used to erase the patient's entire identity, turning them into a blank slate. It has instructions on it that read : 'To avoid overdose, configure IV drip to tranfer speed of 1u. Only inject one bag, as overdose will cause severe brain damage."
	volume = 50

/obj/item/reagent_containers/ivbag/amnesticsf/New()
	..()
	reagents.add_reagent(/datum/reagent/medicine/amnestics/classf, 20)
	reagents.add_reagent(/datum/reagent/water, 30)

/obj/item/reagent_containers/syringe/amnesticsg
	name = "Syringe (Class-G Amnestics)"
	desc = "A syringe filled with Class-G Amnestics. Used to alter memories of the anomalous to a more dreamlike state. Use only under supervision of medical staff."

/obj/item/reagent_containers/syringe/amnesticsg/New()
	..()
	reagents.add_reagent(/datum/reagent/medicine/amnestics/classg, 15)
	update_icon()

/obj/item/storage/pill_bottle/amnesticsh
	name = "pill bottle (Class-H Amnestics)"
	desc = "Contains Class-H Amnestics, used to temporarily prevent the creation of new memories."
	startswith = list(/obj/item/reagent_containers/pill/amnestics/classh = 14)
	wrapper_color = COLOR_GREEN

/obj/item/reagent_containers/pill/amnestics/classh
	name = "class h amnestic pill (5u)"
	icon_state = "pill1"
	desc = "The taste of this pill is usually the last thing you remember for the day."

/obj/item/reagent_containers/pill/amnestics/classh/New()
	..()
	reagents.add_reagent(/datum/reagent/medicine/amnestics/classh, 5)
	color = reagents.get_color()

/obj/item/storage/pill_bottle/amnesticsi
	name = "pill bottle (Class-I Amnestics)"
	desc = "Contains Class-I Amnestics, used to temporarily prevent the recall of the past."
	startswith = list(/obj/item/reagent_containers/pill/amnestics/classi = 14)
	wrapper_color = COLOR_PURPLE

/obj/item/reagent_containers/pill/amnestics/classi
	name = "class i amnestic pill (5u)"
	icon_state = "pill1"
	desc = "You always regret the things you do after you take this pill."

/obj/item/reagent_containers/pill/amnestics/classi/New()
	..()
	reagents.add_reagent(/datum/reagent/medicine/amnestics/classi, 5)
	color = reagents.get_color()

//Amnestic chemical reactions.

/datum/chemical_reaction/classa
	name = "Class-A Amnestics"
	result = /datum/reagent/medicine/amnestics/classa
	required_reagents = list(/datum/reagent/mindbreaker_toxin = 1, /datum/reagent/medicine/alkysine = 1, /datum/reagent/impedrezene = 1)
	result_amount = 3

/datum/chemical_reaction/classb
	name = "Class-B Amnestics"
	result = /datum/reagent/medicine/amnestics/classb
	required_reagents = list(/datum/reagent/medicine/amnestics/classa = 1, /datum/reagent/radium = 1, /datum/reagent/medicine/antidepressant/citalopram = 1)
	result_amount = 3

/datum/chemical_reaction/classc
	name = "Class-C Amnestics"
	result = /datum/reagent/medicine/amnestics/classc
	required_reagents = list(/datum/reagent/medicine/amnestics/classb = 1, /datum/reagent/mindbreaker_toxin = 1, /datum/reagent/medicine/antidepressant/paroxetine = 1)
	result_amount = 3

/datum/chemical_reaction/classe
	name = "Class-E Amnestics"
	result = /datum/reagent/medicine/amnestics/classe
	required_reagents = list(/datum/reagent/medicine/amnestics/classc = 1, /datum/reagent/medicine/noexcutite = 1, /datum/reagent/soporific = 1)
	result_amount = 3

/datum/chemical_reaction/classg
	name = "Class-G Amnestics"
	result = /datum/reagent/medicine/amnestics/classg
	required_reagents = list(/datum/reagent/medicine/amnestics/classc = 1, /datum/reagent/psilocybin = 1)
	result_amount = 2

/datum/chemical_reaction/classh
	name = "Class-H Amnestics"
	result = /datum/reagent/medicine/amnestics/classh
	required_reagents = list(/datum/reagent/medicine/amnestics/classa = 1, /datum/reagent/medicine/painkiller/deletrathol = 1, /datum/reagent/impedrezene = 1)
	result_amount = 3

/datum/chemical_reaction/classi
	name = "Class-I Amnestics"
	result = /datum/reagent/medicine/amnestics/classi
	required_reagents = list(/datum/reagent/medicine/amnestics/classa = 1, /datum/reagent/cryptobiolin = 1)
	result_amount = 2
