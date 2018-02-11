package valleyrace.datatype;

/**
 * ...
 * @author Krisztian Somoracz
 */
typedef CarData =
{
	var name( default, default ):String;

	var id( default, default ):UInt;
	var graphicId( default, default ):UInt;

	var speed( default, default ):Float;
	var rotation( default, default ):Float;
	var elasticity( default, default ):Float;

	@:optional var starRequired( default, default ):UInt;
	@:optional var firstWheelXOffset( default, default ):UInt;
	@:optional var firstWheelYOffset( default, default ):UInt;
	@:optional var backWheelXOffset( default, default ):UInt;
	@:optional var backWheelYOffset( default, default ):UInt;
	@:optional var unlockInformation( default, default ):String;
}