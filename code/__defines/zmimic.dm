#define TURF_IS_MIMICING(T) (isturf(T) && (T:z_flags & ZM_MIMIC_BELOW))
#define CHECK_OO_EXISTENCE(OO) if (OO && !TURF_IS_MIMICING(OO.loc)) { qdel(OO); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(bound_overlay); if (bound_overlay) { update_above(); }

// Turf MZ flags.
/// If this turf should mimic the turf on the Z below.
#define ZM_MIMIC_BELOW		(1<<0)
/// If this turf is Z-mimicing, overwrite the turf's appearance instead of using a movable. This is faster, but means the turf cannot have its own appearance (say, edges or a translucent sprite).
#define ZM_MIMIC_OVERWRITE	(1<<1)
/// If this turf should permit passage of lighting.
#define ZM_ALLOW_LIGHTING	(1<<2)
/// If this turf permits passage of air.
#define ZM_ALLOW_ATMOS		(1<<3)
/// If the turf shouldn't apply regular turf AO and only do Z-mimic AO.
#define ZM_MIMIC_NO_AO		(1<<4)
/// Fix bigturf (greater than world.icon_size) rendering at the cost of breaking object layering a bit. This flag is infectious, so all Z-turfs above this one will also get this flag. Valid on non-zturfs.
#define ZM_FIX_BIGTURF		(1<<5)

// Convenience flag.
#define ZM_MIMIC_DEFAULTS (ZM_MIMIC_BELOW|ZM_ALLOW_LIGHTING)

// For debug purposes, should contain the above defines in ascending order.
var/list/mimic_defines = list(
	"ZM_MIMIC_BELOW",
	"ZM_MIMIC_OVERWRITE",
	"ZM_ALLOW_LIGHTING",
	"ZM_ALLOW_ATMOS",
	"ZM_MIMIC_NO_AO",
	"ZM_FIX_BIGTURF"
)
