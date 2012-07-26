package gameui.manager
{
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.skin.ASSkin;

	import log4a.Logger;

	import net.AssetData;
	import net.RESManager;

	import utils.GStringUtil;
	import utils.MathUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * UI Manager
	 */
	public class UIManager
	{
		public static const SHADOW : DropShadowFilter = new DropShadowFilter(1, 45, 0, 0.5, 1, 1);

		private static var _defaultFont : String;

		private static var _defaultCSS : StyleSheet;

		private static var _root : Sprite;

		private static var _url : String = "unkown";

		private static var _swfName : String = "unkown.swf";

		private static var _dragIng : Boolean = false;
		
		public static var appDomain : ApplicationDomain=ApplicationDomain.currentDomain;
	
		public static var hasEmbedFonts:Boolean=false;
		
		public static var version:String="52";

		public static function setRoot(value : Sprite) : void
		{
			_root = value;
			_url = UIManager._root.loaderInfo.url;
			_swfName = UIManager._url.split("/").pop();
		}

		private static var _stage : Stage;

		public static function setStage(stage : Stage) : void
		{
			_stage = stage;
		}

		public static function get root() : Sprite
		{
			return UIManager._root;
		}

		public static function get stage() : Stage
		{
			return _stage ? _stage : _root.stage;
		}

		public static function get url() : String
		{
			return UIManager._url;
		}

		public static function get swfName() : String
		{
			return UIManager._swfName;
		}

		public static function get defaultFont() : String
		{
			if (_defaultFont == null)
			{
				_defaultFont = "SimSun,宋体,Microsoft YaHei,微软雅黑";
				var os : String = Capabilities.os;
				if (os.indexOf("Mac") != -1)
				{
					_defaultFont = "Verdana,Hei";
				}
				else if (os.indexOf("Linux") != -1)
				{
					_defaultFont = "AR PL UMing CN";
				}
			}
			return _defaultFont;
		}

		public static function get defaultCSS() : StyleSheet
		{
			if (_defaultCSS == null)
			{
				_defaultCSS = new StyleSheet();
				_defaultCSS.setStyle(".font", {fontFamily:defaultCSS});
			}
			return _defaultCSS;
		}

		public static function getEdgeFilters(edgeColor : uint = 0x000000, edgeAlpha : Number = 1, strength : Number = 3) : Array
		{
			return [new GlowFilter(edgeColor, edgeAlpha, 2, 2, strength, 1, false, false)];
		}

		public static function getOffset(value : DisplayObject) : Point
		{
			var rect : Rectangle = MathUtil.toIntRect(value.getBounds(value));
			return rect.topLeft;
		}

		public static function getUI(asset : AssetData) : Sprite
		{
			if (asset == null)
			{
				return null;
			}
			var skin : Sprite;
			if (asset.libId == AssetData.AS_LIB)
			{
				skin = ASSkin.getBy(asset);
			}
			else
			{
				skin = RESManager.getMC(asset);
				if (!skin) skin = ASSkin.getBy(asset);
				else skin.mouseEnabled = skin.mouseChildren = false;
			}
			if (skin.name == "errorSkin")
			{
				Logger.error(GStringUtil.format("UIManager:{0} not found!", asset.key));
			}
			return skin;
		}

		public static function createRect(color : uint, alpha : Number = 1) : Sprite
		{
			var skin : Sprite = new Sprite();
			skin.mouseEnabled = skin.mouseChildren = false;
			var g : Graphics = skin.graphics;
			g.beginFill(0, 1);
			g.drawRect(0, 0, 20, 20);
			g.endFill();
			g.beginFill(color, alpha);
			g.drawRect(1, 1, 18, 18);
			g.endFill();
			skin.scale9Grid = new Rectangle(1, 1, 18, 18);
			return skin;
		}

		public static function createBorder(color : uint = 0x000000) : Sprite
		{
			var skin : Sprite = new Sprite();
			skin.mouseEnabled = skin.mouseChildren = false;
			var g : Graphics = skin.graphics;
			g.beginFill(0, 0.2);
			g.drawRect(1, 1, 18, 18);
			g.endFill();
			g.beginFill(color, 1);
			g.drawRect(0, 0, 20, 1);
			g.endFill();
			g.beginFill(color, 1);
			g.drawRect(0, 1, 1, 18);
			g.endFill();
			g.beginFill(color, 1);
			g.drawRect(19, 1, 1, 18);
			g.endFill();
			g.beginFill(color, 1);
			g.drawRect(0, 19, 20, 1);
			g.endFill();
			skin.scale9Grid = new Rectangle(1, 1, 18, 18);
			return skin;
		}

		public static function createBar(color : uint = 0xFFFF00) : Sprite
		{
			var skin : Sprite = new Sprite();
			skin.mouseEnabled = skin.mouseChildren = false;
			var g : Graphics = skin.graphics;
			g.beginFill(0x000000, 1);
			g.drawRect(0, 0, 20, 20);
			g.endFill();
			g.beginFill(color, 1);
			g.drawRect(1, 1, 18, 18);
			g.endFill();
			g.beginFill(0xFFFFFF, 0.2);
			g.drawRect(1, 1, 18, 1);
			g.endFill();
			g.beginFill(0xFFFFFF, 0.2);
			g.drawRect(1, 1, 1, 18);
			g.endFill();
			g.beginFill(0xFFFFFF, 0.2);
			g.drawRect(18, 1, 1, 18);
			g.endFill();
			g.beginFill(0x000000, 0.2);
			g.drawRect(1, 18, 18, 1);
			g.endFill();
			skin.scale9Grid = new Rectangle(2, 2, 16, 16);
			return skin;
		}

		public static function getMask() : Sprite
		{
			var mask : Sprite = new Sprite();
			mask.mouseEnabled = false;
			var g : Graphics = mask.graphics;
			g.beginFill(0x0000FF, 1);
			g.drawRect(0, 0, 10, 10);
			g.endFill();
			return mask;
		}

		public static function getTextFormat(size : int = 12, color : uint = 0x2f1f00, align : String = "left") : TextFormat
		{
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.size = size;
			textFormat.leading = 3;
			textFormat.color = color;
			textFormat.align = align;
			return textFormat;
		}

		public static function getTextField() : TextField
		{
			var textField : TextField = new TextField();
			textField.multiline=true;
			textField.wordWrap = true;
			textField.text=" ";
			textField.height = textField.textHeight + 4;
			return textField;
		}

		public static function getInputTextField() : TextField
		{
			var textField : TextField = new TextField();
			textField.defaultTextFormat = UIManager.getTextFormat();
			textField.text = "?";
			textField.tabEnabled = true;
			textField.height = textField.textHeight + 4;
			textField.type = TextFieldType.INPUT;
			return textField;
		}

		public static function getCloseButton() : GButton
		{
			var closeButtonData : GButtonData = new GButtonData();
			closeButtonData.width = closeButtonData.height = 20;
			closeButtonData.downAsset = new AssetData("close_button_down_skin");
			closeButtonData.upAsset = new AssetData("close_button_up_skin");
			closeButtonData.disabledAsset = new AssetData("close_button_down_skin");
			closeButtonData.overAsset = new AssetData("close_button_over_skin");
			return new GButton(closeButtonData);
		}

		public static function atParent(source : DisplayObject, target : DisplayObject) : Boolean
		{
			if (source == null || target == null) return false;
			if (source == target) return true;
			var parent : DisplayObjectContainer = source.parent;
			while (parent != null)
			{
				if (parent == target)
				{
					return true;
				}
				parent = parent.parent;
			}
			return false;
		}

		public static function hitTest(x : int, y : int, targe : Sprite = null) : DisplayObject
		{
			targe == null ? root : targe;
			if (!targe) return null;
			var result : Array = targe.getObjectsUnderPoint(new Point(x, y));
			if (!result) return null;
			return result.pop();
		}

		public static function findTarget(source : DisplayObject, target : Class) : DisplayObject
		{
			if (!source || source is target) return source;
			var temp : DisplayObject = source.parent;
			while (temp)
			{
				if (temp is target) return temp;
				temp = temp.parent;
			}
			return null;
		}

		public static function get dragModal() : Boolean
		{
			return _dragIng;
		}

		public static function set dragModal(value : Boolean) : void
		{
			_dragIng = value;
		}
	}
}