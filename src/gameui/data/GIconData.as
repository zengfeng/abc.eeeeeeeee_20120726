package gameui.data
{
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;

	import net.AssetData;

	import flash.display.BitmapData;



	public class GIconData extends GComponentData {

		public var asset : AssetData;

		public var bitmapData : BitmapData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GIconData = source as GIconData;
			if(data == null)return;
			data.asset = asset;
			data.bitmapData = bitmapData;
		}

		public function GIconData() {
			scaleMode = ScaleMode.AUTO_SIZE;
		}

		override public function clone() : * {
			var data : GIconData = new GIconData();
			parse(data);
			return data;
		}
	}
}
