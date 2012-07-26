package  gameui.data {


	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	public class GChatTipData extends GComponentData {

		public var bodyAsset : AssetData;

		public var tailAsset : AssetData;

		public var labelData : GLabelData;

		public var gap : int;

		public var timeout : int;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GChatTipData = source as GChatTipData;
			if(data == null)return;
			data.bodyAsset = bodyAsset;
			data.tailAsset = tailAsset;
			data.labelData = (labelData == null ? null : labelData.clone());
		}

		public function GChatTipData() {
			scaleMode = ScaleMode.AUTO_SIZE;
			minWidth = 60;
			minHeight = 30;
			maxWidth = 240;
			maxHeight = 200;
			bodyAsset = new AssetData(SkinStyle.chatTip_bodySkin);
			tailAsset = new AssetData(SkinStyle.chatTip_tailSkin);
			labelData = new GLabelData();
			labelData.textColor = 0x000000;
			labelData.textFieldFilters = UIManager.getEdgeFilters(0xFFFFFF, 1);
			labelData.textFieldFilters = null;
			labelData.maxLength = 48;
			gap = 7;
			timeout = 10;
		}

		override public function clone() : * {
			var data : GChatTipData = new GChatTipData();
			parse(data);
			return data;
		}
	}
}
