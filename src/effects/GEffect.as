package effects
{
	import gameui.core.GComponent;
	import flash.events.EventDispatcher;

	/**
	 * @version 20100115
	 * @author wingox
	 */
	public class GEffect extends EventDispatcher implements IGEffect
	{
		public static const END : String = "end";

		protected var _delay : int;

		protected var _duration : int = 1;

		protected var _target : GComponent;

		protected var _isPlayIng : Boolean = false;

		protected function onChangeTarget() : void
		{
		}

		public function GEffect()
		{
		}

		public function set target(value : GComponent) : void
		{
			_target = value;
			onChangeTarget();
		}

		public function set duration(value : int) : void
		{
			_duration = value;
		}

		public function start() : void
		{
			_isPlayIng = true;
		}

		public function end() : void
		{
			_isPlayIng = false;
		}

		public function dispose() : void
		{
		}
	}
}
