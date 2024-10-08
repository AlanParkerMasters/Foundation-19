#define IS_WEAKREF_OF(thing, potential_weakref) (isdatum(thing) && !isnull(potential_weakref) && thing.weak_reference == potential_weakref)

/datum
	var/weakref/weakref

//obtain a weak reference to a datum
/proc/weakref(datum/D)
	if(istype(D) && !QDELETED(D))
		if(isweakref(D))
			return D
		if(!D.weakref)
			D.weakref = new/weakref(D)
		return D.weakref

/**
 * A weakref holds a non-owning reference to a datum.
 * The datum can be referenced again using `resolve()`.
 *
 * To figure out why this is important, you must understand how deletion in
 * BYOND works.
 *
 * Imagine a datum as a TV in a living room. When one person enters to watch
 * TV, they turn it on. Others can come into the room and watch the TV.
 * When the last person leaves the room, they turn off the TV because it's
 * no longer being used.
 *
 * A datum being deleted tells everyone who's watching the TV to stop.
 * If everyone leaves properly (AKA cleaning up their references), then the
 * last person will turn off the TV, and everything is well.
 * However, if someone is resistant (holds a hard reference after deletion),
 * then someone has to walk in, drag them away, and turn off the TV forecefully.
 * This process is very slow, and it's known as hard deletion.
 *
 * This is where weak references come in. Weak references don't count as someone
 * watching the TV. Thus, when what it's referencing is destroyed, it will
 * hopefully clean up properly, and limit hard deletions.
 *
 * A common use case for weak references is holding onto what created itself.
 * For example, if a machine wanted to know what its last user was, it might
 * create a `var/mob/living/last_user`. However, this is a strong reference to
 * the mob, and thus will force a hard deletion when that mob is deleted.
 * It is often better in this case to instead create a weakref to the user,
 * meaning this type definition becomes `var/weakref/last_user`.
 *
 * A good rule of thumb is that you should hold strong references to things
 * that you *own*. For example, a dog holding a chew toy would be the owner
 * of that chew toy, and thus a `var/obj/item/chew_toy` reference is fine
 * (as long as it is cleaned up properly).
 * However, a chew toy does not own its dog, so a `var/mob/living/dog/owner`
 * might be inferior to a weakref.
 * This is also a good rule of thumb to avoid circular references, such as the
 * chew toy example. A circular reference that doesn't clean itself up properly
 * will always hard delete.
 */
/weakref
	var/ref

	// Handy info for debugging
	var/tmp/ref_name
	var/tmp/ref_type

/weakref/New(datum/D)
	ref = REF(D)
	ref_name = "[D]"
	ref_type = D.type

/weakref/Destroy(force)
	var/datum/target = resolve()
	qdel(target)

	if(!force)
		return QDEL_HINT_LETMELIVE //Let BYOND autoGC this when nothing is using it anymore.
	target?.weakref = null
	return ..()

/**
 * Retrieves the datum that this weakref is referencing.
 *
 * This will return `null` if the datum was deleted. This MUST be respected.
 */
/weakref/proc/resolve()
	var/datum/D = locate(ref)
	return (!QDELETED(D) && D?.weakref == src) ? D : null

/**
 * SERIOUSLY READ THE AUTODOC COMMENT FOR THIS PROC BEFORE EVEN THINKING ABOUT USING IT
 *
 * Like resolve, but doesn't care if the datum is being qdeleted but hasn't been deleted yet.
 *
 * The return value of this proc leaves hanging references if the datum is being qdeleted but hasn't been deleted yet.
 *
 * Do not do anything that would create a lasting reference to the return value, such as giving it a tag, putting it on the map,
 * adding it to an atom's contents or vis_contents, giving it a key (if it's a mob), attaching it to an atom (if it's an image),
 * or assigning it to a datum or list referenced somewhere other than a temporary value.
 *
 * Unless you're resolving a weakref to a datum in a COMSIG_PARENT_QDELETING signal handler registered on that very same datum,
 * just use resolve instead.
 */
/weakref/proc/hard_resolve()
	var/datum/D = locate(ref)
	return (D?.weakref == src) ? D : null

/weakref/get_log_info_line()
	return "[ref_name] ([ref_type]) ([ref]) (WEAKREF)"
