package  
{
	import net.flashpunk.Entity;
	
	/**
	 * Holds the data for a room in the game (8 by 10 tiles).
	 */
	public class Room 
	{
		
		public var level:Array;
		public var entities:Array;
		
		public function Room() 
		{
			level = new Array(10);
			for (var i:int = 0; i < 10; i++)
			{
				level[i] = new Array();
				for (var j:int = 0; j < 8; j++)
				{
					level[i][j] = 0;
				}
			}
		}
		
	}

}