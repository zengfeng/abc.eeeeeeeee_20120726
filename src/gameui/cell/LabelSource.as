package  gameui.cell {

	public class LabelSource {

		public var text : String;

		public var value : *;

		public function LabelSource(t : String,v : *= null) {
			text = t;
			value = v;
		}

		public function toString() : String {
			return text;
		}
	}
}
