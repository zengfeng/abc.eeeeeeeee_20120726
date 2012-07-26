package utils
{
	import bd.BDData;
	import bd.BDUnit;

	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;
	import net.RESManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class BDUtil
	{
		private static var _cache : Dictionary = new Dictionary(true);
		

		public static function toBDS(mc : MovieClip) : BDData
		{
			if (mc == null) return null;
			var unit : BDUnit;
			var bp : Bitmap;
			var rect : Rectangle;
			var mtx : Matrix;
			mc.gotoAndStop(0);
			var list : Vector.<BDUnit> = new Vector.<BDUnit>;
			for (var i : int = 0;i < mc.totalFrames;i++)
			{
				unit = new BDUnit();
				if (mc.numChildren <= 0) continue;
				bp = mc.getChildAt(0) as Bitmap;
				if (bp == null)
				{
					rect = mc.getBounds(mc);
					if (rect.width < 1 || rect.height < 1)
					{
						list.push(null);
						continue;
					}
					else
					{
						unit.offset = new Point(Math.ceil(rect.x), Math.ceil(rect.y));
						unit.bds = new BitmapData(rect.width, rect.height, true, 0);
						mtx = new Matrix();
						mtx.translate(Math.floor(-rect.x), Math.floor(-rect.y));
						unit.bds.draw(mc, mtx, null, null, null, true);
//						 unit=getOffBD(unit.bds);
//						unit.offset = new Point(rect.x+unit.offset.x,rect.y+unit.offset.y);
						list.push(unit);
					}
				}
				else
				{
					bp.bitmapData.lock();
					unit = getOffBD(bp.bitmapData);
					unit.offset = new Point(bp.x + unit.offset.x, bp.y + unit.offset.y);
					list.push(unit);
				}
				mc.nextFrame();
			}
			return new BDData(list);
		}

		public static function getOffBD(source : BitmapData) : BDUnit
		{
			if (!source) return null;
			var rect : Rectangle = new Rectangle(0, 0, source.width, source.height);
			var vc : Vector.<uint>=source.getVector(rect);
			var max : int = vc.length;
			var minOffX : int = rect.width;
			var minOffY : int = rect.height;
			var maxOffX : int = 0;
			var maxOffY : int = 0;
			for (var i : int = 0;i < max;i++)
			{
				if (vc[i] != 0)
				{
					var n : int = int(i % rect.width);
					maxOffX = n > maxOffX ? n : maxOffX;
					minOffX = n < minOffX ? n : minOffX;
					n = int(i / rect.width);
					maxOffY = n > maxOffY ? n : maxOffY;
					minOffY = n < minOffY ? n : minOffY;
				}
			}
			source.lock();
			var newRect : Rectangle = new Rectangle(minOffX, minOffY, maxOffX - minOffX, maxOffY - minOffY);
			var copyBD : BitmapData = new BitmapData(maxOffX - minOffX, maxOffY - minOffY, true, 0);
			copyBD.copyPixels(source, newRect, new Point(0, 0));
			source.unlock();
			var unit : BDUnit = new BDUnit();
			unit.offset = new Point(minOffX, minOffY);
			unit.bds = copyBD;
			return unit;
		}

		private static function toBD(skin : Sprite) : BDUnit
		{
			if (skin == null || skin.numChildren < 1) return null;
			var bp : Bitmap = skin.getChildAt(0) as Bitmap;
			var unit : BDUnit;
			if (bp != null)
			{
				bp.bitmapData.lock();
				unit = new BDUnit();
				unit.offset = new Point(bp.x, bp.y);
				unit.bds = bp.bitmapData;
				return unit;
			}
			var rect : Rectangle = skin.getBounds(skin);
			if (rect.width < 1 || rect.height < 1)
			{
				return null;
			}
			unit = new BDUnit();
			unit.offset = new Point(rect.x, rect.y);
			unit.bds = new BitmapData(rect.width, rect.height, true, 0);
			var mtx : Matrix = new Matrix();
			mtx.translate(Math.floor(-rect.x), Math.floor(-rect.y));
			unit.bds.draw(skin, mtx, null, null, null, true);
			return unit;
		}

		public static function getResizeBD(source : IBitmapDrawable, w : int, h : int) : BitmapData
		{
			if (source == null) return null;
			var sw : int = 0;
			var sh : int = 0;
			if (source is DisplayObject)
			{
				sw = DisplayObject(source).width;
				sh = DisplayObject(source).height;
			}
			else if (source is BitmapData)
			{
				sw = BitmapData(source).width;
				sh = BitmapData(source).height;
			}
			else
			{
				Logger.error("unkown type");
				return null;
			}
			var a : Number = w / sw;
			var d : Number = h / sh;
			var mtx : Matrix = new Matrix(a, 0, 0, d, 0, 0);
			var target : BitmapData = new BitmapData(w, h, true, 0);
			target.draw(source, mtx, null, null, null, true);
			return target;
		}

		public static function getCutRect(source : BitmapData) : Rectangle
		{
			return source.getColorBoundsRect(0xFF000000, 0x00000000, false);
		}

		public static function getCutBD(source : BitmapData) : BitmapData
		{
			var rect : Rectangle = source.getColorBoundsRect(0xFF000000, 0x00000000, false);
			var bid : BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			bid.copyPixels(source, rect, MathUtil.ORIGIN);
			return bid;
		}

		public static function getResizeCutBD(source : BitmapData, scale : Number) : BDUnit
		{
			var w : int = Math.ceil(source.width * scale);
			var h : int = Math.ceil(source.height * scale);
			if (w < 1 || h < 1) return null;
			var resize : BitmapData = new BitmapData(w, h, true, 0);
			var mtx : Matrix = new Matrix();
			mtx.scale(scale, scale);
			resize.draw(source, mtx, null, null, null, true);
			var rect : Rectangle = resize.getColorBoundsRect(0xFF000000, 0x00000000, false);
			var cut : BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			cut.copyPixels(resize, rect, MathUtil.ORIGIN);
			resize.dispose();
			return new BDUnit(new Point(int(rect.x - w * 0.5), int(rect.y - h)), cut);
		}

		public static function getBD(asset : AssetData, frame : int = 0) : BitmapData
		{
			var skin : Sprite = UIManager.getUI(asset);
			if (skin is MovieClip)
			{
				var data : BDData = BDUtil.toBDS(MovieClip(skin));
				if (data == null)
				{
					Logger.error(asset.key, "has error!");
					return null;
				}
			}
			else
			{
				var bu : BDUnit = BDUtil.toBD(skin);
				if (bu != null)
				{
					return bu.bds;
				}
				else
				{
					Logger.error(asset.key, "not found!");
					return null;
				}
			}
			return data.getBDUnit(frame).bds;
		}

		public static function getBDData(asset : AssetData) : BDData
		{
			var key : String = asset.key;
			if (_cache[key] != null)
			{
				return _cache[key];
			}
			var data : BDData = BDUtil.toBDS(RESManager.getMC(asset));
			if (data == null)
			{
				Logger.error(asset.key, "has error!");
				return null;
			}
			_cache[key] = data;
			return data;
		}

		public static function cutBDData(asset : AssetData, width : int, height : int) : BDData
		{
			var key : String = asset.key + "_cut";
			if (_cache[key] != null) return _cache[key];
			var data : BDData = BDUtil.getBDData(asset);
			var source : BitmapData = data.getBDUnit(0).bds;
			var max : int = Math.floor(source.width / width);
			var rect : Rectangle = new Rectangle(0, 0, width, height);
			var list : Vector.<BDUnit> = new Vector.<BDUnit> ;
			for (var i : int = 0;i < max;i++)
			{
				var unit : BDUnit = new BDUnit();
				unit.offset = new Point(0, 0);
				unit.bds = new BitmapData(width, height, true, 0);
				unit.bds.copyPixels(source, rect, MathUtil.ORIGIN);
				rect.x += width;
				list.push(unit);
			}
			_cache[key] = new BDData(list);
			return _cache[key];
		}

		public static function getCircle(radius : int) : BitmapData
		{
			var key : String = "circle_" + radius;
			if (_cache[key] != null) return _cache[key];
			var shape : Shape = new Shape();
			shape.graphics.beginFill(0xFF0000, 1);
			shape.graphics.drawCircle(radius, radius, radius);
			shape.graphics.endFill();
			var bid : BitmapData = new BitmapData(radius * 2, radius * 2, true, 0);
			bid.draw(shape);
			bid.lock();
			_cache[key] = bid;
			return bid;
		}

		public static function applySharpen(bid : BitmapData) : void
		{
			var amount : Number = 3;
			var a : Number = amount / -100;
			var b : Number = a * (-8) + 1;
			var mtx : Array = [a, a, a, a, b, a, a, a, a];
			var sharpen : ConvolutionFilter = new ConvolutionFilter(3, 3, mtx);
			bid.applyFilter(bid, bid.rect, bid.rect.topLeft, sharpen);
		}

		public static function getTextSize(tf : TextField) : Rectangle
		{
			var bds : BitmapData = new BitmapData(tf.textWidth, tf.textHeight, true, 0);
			bds.draw(tf);
			var rect : Rectangle = bds.getColorBoundsRect(0xFF000000, 0x00000000, false);
			bds.dispose();
			return rect;
		}

		private static var _bitMapDataCache : Dictionary = new Dictionary(true);

		public static function getScaleBitmapData(asset : AssetData) : Scale9GridBitMapData
		{
			var key : String = asset.key;
			if (_bitMapDataCache[key] )
				return _bitMapDataCache[key];
			var mc : MovieClip = RESManager.getMC(asset);
			if (!mc) return null;
			var rect : Rectangle = mc.getBounds(mc);
			var data : BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			data.draw(mc, new Matrix(), null, null, null, true);
			var vlaue:Scale9GridBitMapData=new Scale9GridBitMapData(data, mc.scale9Grid);
			_bitMapDataCache[key] = vlaue;
			return vlaue;
		}
	}
}

