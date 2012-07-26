package effects
{
	import core.IDispose;
	import gameui.core.GComponent;

	public interface IGEffect extends IDispose
	{
		function set target(target : GComponent) : void;

		function start() : void;

		function end() : void;
	}
}
