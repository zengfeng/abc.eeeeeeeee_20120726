package gameui.skin
{
	import utils.GDrawUtil;

	import flash.display.BitmapData;


	/**
	 * Texture Skin
	 */
	public class TextureSkin extends Skin {
		private var _borderColor : uint;
		private var _borderAlpha : Number;
		private var _bd : BitmapData;

		override protected function layout() : void {
			redraw();
		}

		private function redraw() : void {
			graphics.clear();
			GDrawUtil.drawFillBorder(graphics, _borderColor, _borderAlpha, 0, 0, _width, _height);
			graphics.beginBitmapFill(_bd);
			graphics.drawRect(1, 1, _width - 2, _height - 2);
			graphics.endFill();
		}

		public function TextureSkin(borderColor : uint, borderAlpha : Number, bd : BitmapData) {
			_borderColor = borderColor;
			_borderAlpha = borderAlpha;
			_bd = bd;
			_width = 50;
			_height = 50;
			super();
		}

		override public function clone() : Skin {
			return new TextureSkin(_borderColor, _borderAlpha, _bd);
		}
	}
}
