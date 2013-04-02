package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="640", height="512", frameRate = "-1", backgroundColor="#000000")]
	
	/**
	 * Entry point into the program.
	 */
	public class Main extends Engine
	{
		
		private var _gameWorld:GameWorld;
		
		public function Main():void
		{
			super(160, 128, 60, true);
			FP.screen.scale = 4;
			_gameWorld = new GameWorld();
			
		}
		
		override public function init():void
		{
			//RoomContainer.init();
			FP.world = _gameWorld;
		}
	}
	
}