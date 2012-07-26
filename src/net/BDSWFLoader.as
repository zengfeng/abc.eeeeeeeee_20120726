package net
{
	import flash.utils.Dictionary;

	import bd.BDData;
	import bd.BDUnit;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jian
	 */
	public class BDSWFLoader extends SWFLoader
	{
		private var _bdsDict : Dictionary;

		public function getBDData(name :String) : BDData
		{
			return _bdsDict[name];
		}

		public function BDSWFLoader(data : LibData, fun : Function = null, onCompleteParams : Array = null)
		{
			super(data, fun, onCompleteParams);
		}

		override protected function onByteArrayLoadComplete() : void
		{
			super.onByteArrayLoadComplete();
			parseBD();
			getLoader().unloadAndStop();
		}

		private function parseBD() : void
		{
			_bdsDict = new Dictionary();

			var _source : BitmapData = new(getClass("source")) as BitmapData;
			if (!_source) return;
			var text : String = (getMovieClip("text")).getChildAt(0)["text"];
			var _xml : XML = new XML(text);

			var bottomX : Number = Number(_xml.attribute("bottomX"));
			var bottomY : Number = Number(_xml.attribute("bottomY"));
			for each (var xml:XML in _xml["frame"])
			{
				var frames : Vector.<BDUnit > = new Vector.<BDUnit >;
				for each (var frame:XML in xml["item"])
				{
					var unit : BDUnit = new BDUnit();
					var rect : Rectangle = new Rectangle(frame. @ x, frame. @ y, frame. @ w, frame. @ h);
					var bds : BitmapData = new BitmapData(rect.width, rect.height, true, 0);
					bds.copyPixels(_source, rect, new Point());
					unit.offset = new Point(int(frame.@offsetX) + bottomX, int(frame.@offsetY) + bottomY);
					unit.bds = bds;
					frames.push(unit);
				}
				var name :String = String(int(String(xml.@name).split("_")[1]));
				_bdsDict[name] = new BDData(frames);
				_source.dispose();
				// TODO: 增加解析播放速率
			}
		}

		override public function clear() : void
		{
			super.clear();
			_bdsDict = null;
		}
	}
}
