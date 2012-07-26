package gameui.data
{
	import gameui.core.GAlign;
	import gameui.core.GComponentData;

	import net.LibData;

	/**
	 * @author yangyiqiang
	 */
	public class GImageData extends GComponentData
	{
		public var libData : LibData;
		
		public var iocData:GIconData;
		
		public var classsName:String="";
		
		public var isBDPlay:Boolean=true;
		
		public var autoLayout:Boolean=false;
		
		public var ringAlign:GAlign;
		
		public var showRing:Boolean=false;
		
		public var force:Boolean=false;
		
		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GImageData = source as GImageData;
			if (data == null) return;
		}

		public function GImageData()
		{
			super();
			width=40;
			height=40;
			iocData=new GIconData();
			iocData.align=new GAlign(-1,-1,-1,-1,0,0);
			ringAlign=new GAlign(0, 0);
		}
	}
}
