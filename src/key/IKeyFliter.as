package key {

	
	public interface IKeyFliter {

		function convertKeyCode(keyCode : uint) : uint;

		function keyDownFliter(keyCode : uint) : Boolean;
	}
}
