package bd
{
	import net.AssetData;

	import utils.BDUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;



	public class BDFont extends Sprite {

		private var _chars : Array;

		private var _width : int;

		private var _height : int;

		private var _leading : int;

		private var _bdData : BDData;

		private var _bitmap : Bitmap;

		private var _source : Object;

		public function BDFont(source : AssetData,chars : Array,width : int,height : int,leading : int = 0) {
			_chars = chars;
			_width = width;
			_height = height;
			_leading = leading;
			_bdData = BDUtil.cutBDData(source, _width, _height);
			_bitmap = new Bitmap();
			addChild(_bitmap);
		}

		public function set text(value : String) : void {
			var width : int = _width + _leading;
			var bid : BitmapData = new BitmapData(value.length * width - _leading, _height, true, 0);
			for(var i : int = 0;i < value.length;i++) {
				var unit : String = value.charAt(i);
				var index : int = _chars.indexOf(unit);
				if(index != -1) {
					var cut : BitmapData = _bdData.getBDUnit(index).bds;
					bid.copyPixels(cut, cut.rect, new Point(i * width, 0), null, null, true);
				}
			}
			_bitmap.bitmapData = bid;
		}

		override public function get width() : Number {
			return _bitmap.width;
		}

		override public function get height() : Number {
			return _bitmap.height;	
		}

		public function set source(value : *) : void {
			_source = value;
		}

		public function get source() : * {
			return _source;
		}

		public function clear() : void {
			if(_bitmap.bitmapData) {
				_bitmap.bitmapData.dispose();
				_bitmap.bitmapData = null;
			}
		}
	}
}
