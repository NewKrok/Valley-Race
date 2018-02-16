package valleyrace.game.constant;
import nape.phys.Material;

/**
 * ...
 * @author Krisztian Somoracz
 */
class CPhysicsValue
{
	public static inline var GRAVITY:UInt = 600;
	public static inline var STEP:Float = 1 / 60;

	public static inline var CAR_FILTER_CATEGORY:UInt = 2;
	public static inline var CAR_FILTER_MASK:UInt = 1;
	public static inline var GROUND_FILTER_CATEGORY:UInt = 1;
	public static inline var GROUND_FILTER_MASK:UInt = 2;
	public static inline var BRIDGE_FILTER_CATEGORY:UInt = 1;
	public static inline var BRIDGE_FILTER_MASK:UInt = 2;
	public static inline var CRATE_FILTER_CATEGORY:UInt = 3;
	public static inline var CRATE_FILTER_MASK:UInt = 3;

	public static var MATERIAL_NORMAL_GROUND( get, never ):Material;
	public static var MATERIAL_BRIDGE( get, never ):Material;

	static function get_MATERIAL_NORMAL_GROUND():Material { return Material.steel(); }
	static function get_MATERIAL_BRIDGE():Material { return Material.steel(); }
}