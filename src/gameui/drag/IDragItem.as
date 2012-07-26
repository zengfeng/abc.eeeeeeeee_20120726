package  gameui.drag {

	/**
	 * Inteface Drag Item
	 */
	public interface IDragItem {

		function get key() : String;

		function get name() : String;

		function set count(value : int) : void;

		function get count() : int;

		function get max() : int;

		function set place(value : int) : void;

		function get place() : int;

		function set gird(value : int) : void;

		function get gird() : int;

		function merge(target : IDragItem) : Boolean;

		function split(count : int) : IDragItem;

		function syncMove(s_place : int,s_gird : int,t_place : int,t_gird : int,splitKey : String = "",splitCount : int = 0) : void;

		function syncRemove(count : int = 0,isUse : Boolean = false) : void;
	}
}