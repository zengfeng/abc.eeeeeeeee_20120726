package  gameui.data {


	import gameui.skin.SkinStyle;
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;

	import net.AssetData;
	/**
	 * Game Tool Tip Data
	 */
	public class GToolTipData extends GComponentData {

		public var backgroundAsset : AssetData;

		public var labelData : GLabelData = new GLabelData();

		public var padding : int;

		public var alginMode : int;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GToolTipData = source as GToolTipData;
			if(data == null)return;
			data.backgroundAsset = backgroundAsset;
			data.labelData = labelData;
			data.labelData.filters = [];
			data.padding = padding;
			data.alginMode = alginMode;
		}

		public function GToolTipData() {
			backgroundAsset = new AssetData(SkinStyle.emptySkin);
			padding = 5;
			alginMode = 0;
			scaleMode = ScaleMode.AUTO_SIZE;
		}

		override public function clone() : * {
			var data : GToolTipData = new GToolTipData();
			parse(data);
			return data;
		}
	}
}