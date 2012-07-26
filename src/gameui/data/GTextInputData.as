package gameui.data
{
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import flash.text.TextFormat;



	public class GTextInputData extends GComponentData {
		
		public static const  NUM_RESTRICT:String="0-9";

		public var borderAsset : AssetData = new AssetData("GTextInput_borderSkin");

		public var disabledAsset : AssetData = new AssetData("GTextInput_disabledSkin");

		public var textFormat : TextFormat;

		public var textColor : uint = 0x2f1f00;

		public var textFieldFilters : Array =[];

		public var disabledColor : uint = 0x898989;

		public var maxChars : int = 0;

		public var displayAsPassword : Boolean = false;

		public var restrict : String = "";

		public var allowIME : Boolean = true;
		
		public var hintText : String;

		public var text : String = "";
		
		public var selectAll:Boolean=true;
		
		public var indent:Number = 3;
		
		public var wordWrap:Boolean = false;
		
		public var maxNum:int=999;
		
		public var minNum:int=1;
		
		public var numFun:Function=null;
		
		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GTextInputData = source as GTextInputData;
			if(data == null)return;
			data.borderAsset = borderAsset;
			data.textFormat = textFormat;
			data.textColor = textColor;
			data.textFieldFilters = textFieldFilters.concat();
			data.maxChars = maxChars;
			data.displayAsPassword = displayAsPassword;
			data.restrict = restrict;
			data.allowIME = allowIME;
			data.text = text;
			data.hintText = hintText;
			data.indent = indent;
			data.maxNum = maxNum;
			data.minNum = minNum;
			data.numFun = numFun;
		}

		public function GTextInputData() {
			width = 103;
			height = 24;
			textFormat = UIManager.getTextFormat();
			textFormat.kerning = true;
		}

		override public function clone() : * {
			var data : GTextInputData = new GTextInputData();
			parse(data);
			return data;
		}
	}
}
