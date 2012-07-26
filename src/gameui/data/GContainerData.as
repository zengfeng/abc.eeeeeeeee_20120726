package gameui.data {
	import gameui.core.GComponentData;

	/**
	 * @author yangyiqiang
	 */
	public class GContainerData extends GComponentData {
		public var  depth : int = 0;
		public function GContainerData() {
			super();
		}

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GContainerData = source as GContainerData;
			if(data == null)return;
			data.depth = depth;
		}

		override public function clone() : * {
			var data : GContainerData = new GContainerData();
			parse(data);
			return data;
		}
	}
}
