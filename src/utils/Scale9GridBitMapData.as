package utils
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author yangyiqiang
	 */
	public class Scale9GridBitMapData
	{
		private var _data : BitmapData;

		private var _scale9Grid : Rectangle;

		public function Scale9GridBitMapData(data : BitmapData, scale9Grid : Rectangle)
		{
			_data = data;
			_scale9Grid = scale9Grid;
		}

		public function get data() : BitmapData
		{
			return _data;
		}

		public function get scale9Grid() : Rectangle
		{
			return _scale9Grid;
		}
	}
}
