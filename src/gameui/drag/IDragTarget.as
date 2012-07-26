package  gameui.drag {

	public interface IDragTarget {
		
		function dragEnter(dragData : DragData) : Boolean;
		
		function canSwap(source:IDragItem,target:IDragItem):Boolean;
	}
}
