package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="960", height="768", frameRate = "-1", backgroundColor="#000000")]
	//[SWF(width = "800", height = "640", frameRate = "-1", backgroundColor = "#000000")]
	//[SWF(width = "640", height = "512", frameRate = "-1", backgroundColor = "#000000")]
	
	/**
	 * Entry point into the program.
	 */
	public class Main extends Engine
	{
		
		private var _gameWorld:GameWorld;
		
		public function Main():void
		{
			super(160, 128, 60, true);
			FP.screen.scale = 6;
		}
		
		override public function init():void
		{
			_gameWorld = new GameWorld();
			FP.world = _gameWorld;
			RoomContainer.init();
			RoomContainerExtra.init();
			Ambiance.init();
			_gameWorld.init();
		}
	}
	
}