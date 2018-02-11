package valleyrace.util;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AppVersionUtil
{
	public static function isLowerThan(baseVersion:String, comparedVersion:String):Bool
	{
		var baseVersionNumbers:Array<String> = baseVersion.split(".");
		var comparedVersionNumbers:Array<String> = comparedVersion.split(".");

		for (i in 0...baseVersionNumbers.length)
		{
			if (baseVersionNumbers[i] < comparedVersionNumbers[i]) return true;
			else if (baseVersionNumbers[i] > comparedVersionNumbers[i]) return false;
		}

		return false;
	}
}