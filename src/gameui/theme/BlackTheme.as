package gameui.theme
{
	import gameui.manager.UIManager;

	import utils.GDrawUtil;
	import utils.MathUtil;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;



	public class BlackTheme implements ITheme {

		public function get cssText() : String {
			return "p{color:#EFEFEF;font-family:" + UIManager.defaultFont + ";leading:4;kerning:true}";
		}

		public function get GButton_upSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.1, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.1,0], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.08,0.03], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GButton_overSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.1, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.15,0.05], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.08,0.03], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GButton_downSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.1, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.05,0], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.08,0.03], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GButton_disabledSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.05, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.4, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.08,0], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.05,0], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GButton_selectedUpSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.1, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0x000000,0x000000], [0.5,0.4], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.1,0.05], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GButton_selectedOverSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.1, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0x000000,0x000000], [0.4,0.3], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.1,0.05], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GButton_selectedDownSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.1, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0x000000,0x000000], [0.5,0.4], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.1,0.05], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GButton_selectedDisabledSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.05, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.4, 1, 1, 18, 18);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0x000000,0x000000], [0.3,0.2], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.05,0], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GProgressBar_trackSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.1, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.6, 1, 1, 18, 18);
			GDrawUtil.drawRect(g, 0x000000, 0.05, 2, 2, 16, 16);
			GDrawUtil.drawRect(g, 0x000000, 0.2, 2, 2, 16, 1);
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GProgressBar_barSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0x000000, 0.03, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.05, 1, 1, 18, 18);
			GDrawUtil.drawRect(g, 0xFF6600, 1, 2, 2, 16, 16);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(16, 16, MathUtil.angleToRadian(90), 2, 2);
			g.beginGradientFill(GradientType.LINEAR, [0xFFCC00,0xFF6600], [1,1], [0,255], mtx);
			g.drawRect(2, 2, 16, 16);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.1,0.05], [0,255], mtx);
			GDrawUtil.drawBorder(g, 2, 2, 16, 16);
			g.endFill();
			skin.scale9Grid = new Rectangle(4, 4, 12, 12);
			return skin;
		}

		public function get GPanel_backgroundSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawRect(g, 0x000000, 0.7, 0, 0, 20, 20);
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 0, 0, 20, 20);
			var mtx : Matrix = new Matrix();
			mtx.createGradientBox(18, 18, MathUtil.angleToRadian(90), 1, 1);
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.08,0], [0,255], mtx);
			g.drawRect(1, 1, 18, 18);
			g.endFill();
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF,0xFFFFFF], [0.08,0.03], [0,255], mtx);
			GDrawUtil.drawBorder(g, 1, 1, 18, 18);
			g.endFill();
			skin.scale9Grid = new Rectangle(2, 2, 16, 16);
			return skin;
		}

		public function get GScrollBar_trackSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0x000000, 0.6, 0, 0, 20, 20);
			GDrawUtil.drawRect(g, 0x000000, 0.15, 1, 1, 18, 1);
			GDrawUtil.drawRect(g, 0x000000, 0.15, 1, 2, 1, 17);
			GDrawUtil.drawRect(g, 0x000000, 0.15, 18, 2, 1, 17);
			skin.scale9Grid = new Rectangle(2, 2, 16, 16);
			return skin;
		}

		public function get GScrollBar_thumbUpSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 0, 0, 20, 20);
			GDrawUtil.drawRect(g, 0xFFFFFF, 0.05, 1, 1, 18, 18);
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.15, 1, 1, 18, 18);
			skin.scale9Grid = new Rectangle(2, 2, 16, 16);
			return skin;
		}

		public function get GScrollBar_thumbOverSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 0, 0, 20, 20);
			GDrawUtil.drawRect(g, 0xFFFFFF, 0.15, 1, 1, 18, 18);
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.2, 1, 1, 18, 18);
			skin.scale9Grid = new Rectangle(2, 2, 16, 16);
			return skin;
		}

		public function get GScrollBar_thumbDownSkin() : Sprite {
			var skin : Sprite = new Sprite();
			var g : Graphics = skin.graphics;
			GDrawUtil.drawFillBorder(g, 0x000000, 0.7, 0, 0, 20, 20);
			GDrawUtil.drawRect(g, 0xFFFFFF, 0.05, 1, 1, 18, 18);
			GDrawUtil.drawFillBorder(g, 0xFFFFFF, 0.15, 1, 1, 18, 18);
			skin.scale9Grid = new Rectangle(2, 2, 16, 16);
			return skin;
		}
	}
}
