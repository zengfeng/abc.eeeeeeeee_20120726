package effects
{
	import com.greensock.TweenLite;
	/**
	 * @author yangyiqiang
	 */
	public class HideEffect extends GEffect
	{
		public function HideEffect()
		{
		}

		override public function start() : void
		{
			if (_isPlayIng)
				return;
				
			super.start();
			TweenLite.to(_target, 0.5, {alpha:0,onComplete:end, overwrite:0});
		}

		override public function end() : void
		{
			if (!_target.parent) return;
			_target.parent.removeChild(_target);
			_target.alpha = 1;
			if (_target.base.parent == null)
			{
				_target.base.parent = _target.parent;
			}
			super.end();
		}
	}
}
