package gameui.skin
{
	import utils.GDrawUtil;
	import utils.MathUtil;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;


	/**
	 * Polled Skin
	 * 
	 */
	public class PolledSkin extends Skin {

		private var _barSkin : Sprite;

		private var _patternSkin : Sprite;

		private var _topSkin : Sprite;

		private var _hatch : int = 28;

		private var _borderColor : uint = 0x000000;

		private var _timer : Timer;

		override protected function create() : void {
			addBarSkin();
			addPatternSkin();
			addTopSkin();
		}

		private function addBarSkin() : void {
			_barSkin = new Sprite();
			_barSkin.mouseEnabled = _barSkin.mouseChildren = false;
			var g : Graphics = _barSkin.graphics;
			GDrawUtil.drawFillBorder(g, 0x000000, 0.03, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.05, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0xCCCCCC,0x666666], [1,1], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			_barSkin.scale9Grid = new Rectangle(4, 4, 12, 12);
			addChild(_barSkin);
		}

		private function addPatternSkin() : void {
			_patternSkin = new Sprite();
			_patternSkin.mouseEnabled = _patternSkin.mouseChildren = false;
			_patternSkin.x = 2;
			_patternSkin.y = 2;
			redrawPattern();
			addChild(_patternSkin);
		}

		private function addTopSkin() : void {
			_topSkin = new Sprite();
			_topSkin.mouseEnabled = _topSkin.mouseChildren = false;
			_topSkin.x = _topSkin.y = 2;
			var g : Graphics = _topSkin.graphics;
			GDrawUtil.drawRect(g, 0xFFFFFF, 0.2, 0, 0, 20, 1);
			GDrawUtil.drawRect(g, 0xFFFFFF, 0.2, 0, 1, 1, 19);
			GDrawUtil.drawRect(g, 0xFFFFFF, 0.2, 19, 1, 1, 19);
			GDrawUtil.drawRect(g, 0x000000, 0.05, 0, 19, 20, 1);
			_topSkin.scale9Grid = new Rectangle(1, 1, 18, 18);
			addChild(_topSkin);
		}

		private function redrawPattern() : void {
			var g : Graphics = _patternSkin.graphics;
			g.clear();
			var w : int = _width + _hatch;
			var h : int = _height - 4;
			g.beginFill(_borderColor, 0.9);
			for (var i : int = 0;i < w;i += _hatch) {
				g.moveTo(i, 0);
				g.lineTo(Math.min(i + 14, w), 0);
				g.lineTo(Math.min(i + 10, w), h);
				g.lineTo(Math.max(i - 4, 0), h);
				g.lineTo(i, 0);
			}
			g.endFill();
		}

		override protected function layout() : void {
			_barSkin.width = _width;
			_barSkin.height = _height;
			_topSkin.width = _width - 4;
			_topSkin.height = _height - 4;
			redrawPattern();
			_patternSkin.scrollRect = new Rectangle(0, 0, _width - 4, _height - 4);
		}

		private function timerHandler(event : TimerEvent) : void {
			var rect : Rectangle = _patternSkin.scrollRect;
			if(rect.x < _hatch) {
				rect.x += 2;
			} else {
				rect.x = 0;
			}
			_patternSkin.scrollRect = rect;
		}

		override protected function onShow() : void {
			if(!_timer.running)_timer.start();
		}

		override protected function onHide() : void {
			if(_timer.running)_timer.stop();
		}

		public function PolledSkin() : void {
			_width = 100;
			_height = 10;
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			super();
		}

		override public function clone() : Skin {
			return new PolledSkin();
		}
	}
}
