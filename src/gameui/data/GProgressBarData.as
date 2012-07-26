package  gameui.data {


	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	/**
	 * Game Progress Bar Data
	 */
	public class GProgressBarData extends GComponentData {

		public static const MANUAL : int = 0;

		public static const POLLED : int = 1;

		public var trackAsset : AssetData;

		public var barAsset : AssetData;

		public var highLightAsset : AssetData;

		public var labelData : GLabelData;

		public var paddingX : int;
		
		public var paddingY : int;
		
		public var padding : int;
		
		public var barMask : Boolean;

		public var mode : int ;

		public var value : int;

		public var max : int = 100;
		
		public var modal:Boolean=false;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GProgressBarData = source as GProgressBarData;
			if(data == null)return;
			data.trackAsset = trackAsset;
			data.barAsset = barAsset;
			data.labelData = labelData.clone();
			data.paddingX = paddingX;
			data.paddingY = paddingY;
			data.barMask = barMask;
			data.mode = mode;
			data.value = value;
			data.max = max;
		}

		public function GProgressBarData() {
			trackAsset = new AssetData(SkinStyle.progressBar_trackSkin);
			barAsset = new AssetData(SkinStyle.progressBar_barSkin);
			labelData = new GLabelData();
			labelData.align = GAlign.CENTER;
			labelData.width=200;
			mode = MANUAL;
			max = 100;
			barMask = false;
			width = 100;
			height = 10;
		}

		override public function clone() : * {
			var data : GProgressBarData = new GProgressBarData();
			parse(data);
			return data;
		}
	}
}
