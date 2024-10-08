/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		Wrapping Paper
 */

/*
 * Wrapping Paper and Gifts
 */

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = ITEM_SIZE_HUGE

/obj/item/gift/New(newloc, obj/item/wrapped = null)
	..(newloc)

	if(istype(wrapped))
		gift = wrapped
		w_class = gift.w_class
		gift.forceMove(src)

		//a good example of where we don't want to use the w_class defines
		switch(gift.w_class)
			if(1) icon_state = "gift1"
			if(2) icon_state = "gift1"
			if(3) icon_state = "gift2"
			if(4) icon_state = "gift2"
			if(5) icon_state = "gift3"

/obj/item/gift/attack_self(mob/user as mob)
	user.drop_active_hand()
	if(src.gift)
		user.put_in_active_hand(gift)
		src.gift.add_fingerprint(user)
	else
		to_chat(user, SPAN_WARNING("The gift was empty!"))
	qdel(src)
	return

/obj/item/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper"
	var/amount = 2.5*BASE_STORAGE_COST(ITEM_SIZE_HUGE)

/obj/item/wrapping_paper/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (!( locate(/obj/structure/table, src.loc) ))
		to_chat(user, SPAN_WARNING("You MUST put the paper on a table!"))
	if (W.w_class < ITEM_SIZE_HUGE)
		if(isWirecutter(user.l_hand) || isWirecutter(user.r_hand))
			var/a_used = W.get_storage_cost()
			if (a_used == ITEM_SIZE_NO_CONTAINER)
				to_chat(user, SPAN_WARNING("You can't wrap that!"))//no gift-wrapping lit welders

				return
			if (src.amount < a_used)
				to_chat(user, SPAN_WARNING("You need more paper!"))
				return
			else
				if(istype(W, /obj/item/smallDelivery) || istype(W, /obj/item/gift)) //No gift wrapping gifts!
					return

				if(user.unEquip(W))
					var/obj/item/gift/G = new /obj/item/gift( src.loc, W )
					G.add_fingerprint(user)
					W.add_fingerprint(user)
					src.amount -= a_used

			if (src.amount <= 0)
				new /obj/item/c_tube( src.loc )
				qdel(src)
				return
		else
			to_chat(user, SPAN_WARNING("You need scissors!"))
	else
		to_chat(user, SPAN_WARNING("The object is FAR too large!"))
	return


/obj/item/wrapping_paper/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, text("There is about [] square units of paper left!", src.amount))

/obj/item/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if (!istype(target, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = target

	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || H.stat)
		if (src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
			src.amount -= 2

			if (H.client)
				H.client.perspective = EYE_PERSPECTIVE
				H.client.eye = present

			H.forceMove(present)
			admin_attack_log(user, H, "Used \a [src] to wrap their victim", "Was wrapepd with \a [src]", "used \the [src] to wrap")

		else
			to_chat(user, SPAN_WARNING("You need more paper."))
	else
		to_chat(user, "They are moving around too much. A straightjacket would help.")

/*
 * Effect
 */

/obj/effect/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	to_chat(user, SPAN_WARNING("You can't move."))

/obj/effect/spresent/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if(!isWirecutter(W))
		to_chat(user, SPAN_WARNING("I need wirecutters for that."))
		return

	to_chat(user, SPAN_NOTICE("You cut open the present."))

	for(var/mob/M in src) //Should only be one but whatever.
		M.dropInto(loc)
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	qdel(src)
