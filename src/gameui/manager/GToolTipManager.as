package gameui.manager
{
	import gameui.core.GComponent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GToolTipManager
	{
		public static function toolTip_rollOverHandler(event : MouseEvent) : void
		{
			var target : GComponent = GComponent(event.currentTarget);
			if (!target || !target.toolTip) return;
			if (!target.toolTip.parent)
				UIManager.root.addChild(target.toolTip);
			if (!target.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				target.addEventListener(MouseEvent.MOUSE_MOVE,toolTip_rollOverHandler);
			}
			var offset : Point = new Point(event.stageX,event.stageY);
			offset.x += 10;
			offset.y += 10;
			if (target.toolTip.data.alginMode == 0)
			{
				if (offset.x + target.toolTip.width + 10 > UIManager.stage.stageWidth)
				{
					offset.x = offset.x - (target.width + target.toolTip.width + 10);
				}
				else
				{
					offset.x += 10;
				}

				if (offset.y + target.toolTip.height > UIManager.stage.stageHeight && target.toolTip.height < offset.y)
				{
					offset.y -= target.toolTip.height;
				}

				if (offset.y + target.toolTip.height > UIManager.stage.stageHeight && target.toolTip.height > offset.y)
				{
					offset.y = UIManager.root.height / 2 - target.toolTip.height / 2;
				}
			}
			else if (target.toolTip.data.alginMode == 1)
			{
				if (offset.x + target.toolTip.width > UIManager.stage.stageWidth)
				{
					offset.x -= target.width + target.toolTip.width;
				}
				if (offset.y + target.toolTip.height > UIManager.stage.stageHeight)
				{
					offset.y -= target.toolTip.height + target.height ;
				}
				offset.y -= target.height + target.toolTip.height;
			}
			target.toolTip.moveTo(offset.x,offset.y);
		}

		public static function showTips(offset : Point, tips : GComponent) : void
		{
		}

		private static function toolTip_rollOutHandler(event : MouseEvent) : void
		{
			var target : GComponent = GComponent(event.currentTarget);
			if (!target || !target.toolTip) return;
			target.toolTip.hide();
		}

		public static function registerToolTip(target : GComponent) : void
		{
			if (!target) return;
			target.addEventListener(MouseEvent.ROLL_OVER,toolTip_rollOverHandler);
			target.addEventListener(MouseEvent.ROLL_OUT,toolTip_rollOutHandler);
		}

		public static function destroyToolTip(target : GComponent) : void
		{
			if (!target || !target.toolTip) return;
			target.toolTip.hide();
			target.removeEventListener(MouseEvent.ROLL_OVER,toolTip_rollOverHandler);
			target.removeEventListener(MouseEvent.MOUSE_MOVE,toolTip_rollOverHandler);
			target.removeEventListener(MouseEvent.ROLL_OUT,toolTip_rollOutHandler);
		}
	}
}