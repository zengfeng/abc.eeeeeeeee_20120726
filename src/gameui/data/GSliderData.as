package  gameui.data {


	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	/**
	 * Game Slider Data
	 * 
	 */
	public class GSliderData extends GComponentData {

		public var trackAsset : AssetData;

		public var barAsset : AssetData;

		public var thumbAsset : AssetData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GSliderData = source as GSliderData;
			if(data == null)return;
			data.trackAsset = trackAsset;
			data.barAsset = barAsset;
			data.thumbAsset = thumbAsset;
		}

		public function GSliderData() {
			trackAsset = new AssetData(SkinStyle.slider_trackSkin);
			barAsset = new AssetData(SkinStyle.slider_barSkin);
			thumbAsset = new AssetData(SkinStyle.slider_thumbSkin);
			width = 100;
			height = 10;
			scaleMode = ScaleMode.SCALE_WIDTH;
		}

		override public function clone() : * {
			var data : GSliderData = new GSliderData();
			parse(data);
			return data;
		}
	}
}
