/mob/living/simple_animal/hostile //TODO: cleanup
	faction = "hostile"
	var/stance = STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/ranged = 0
	var/rapid = 0
	var/sa_accuracy = 85 //base chance to hit out of 100
	var/fire_desc = "fires" //"X fire_desc at Y!"
	var/ranged_range = 6 //tiles of range for ranged attackers to attack
	var/attack_delay = CLICK_CD_ATTACK
	var/break_stuff_probability = 10
	var/destroy_surroundings = 1
	a_intent = I_HURT

	var/shuttletarget = null
	var/enroute = 0

	ai_holder_type = /datum/ai_holder/simple_animal/melee
