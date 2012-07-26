package bd
{
	import core.IDispose;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class BDUnit implements IDispose
	{
		private var _offset : Point;

		private var _bds : BitmapData;

		public function BDUnit(o : Point = null, b : BitmapData = null)
		{
			offset = o;
			bds = b;
		}

		public function get offset() : Point
		{
			return _offset;
		}

		public function set offset(p : Point) : void
		{
			_offset = p;
		}
		
		public function set bds(bit:BitmapData):void
		{
			_bds=bit;
		}
		
		public function get bds():BitmapData
		{
			return _bds;
		}

		public function dispose() : void
		{
			if (bds != null) bds.dispose();
			_bds=null;
		}
	}
}