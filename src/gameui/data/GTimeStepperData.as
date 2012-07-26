package  gameui.data {


	import gameui.core.GComponentData;

	import net.AssetData;
	public class GTimeStepperData extends GComponentData {

		public var bdAsset : AssetData;

		public var limit : int;

		public function GTimeStepperData() {
			bdAsset = new AssetData("time_number");
			limit = 60;
		}
	}
}
