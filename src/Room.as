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
					if (i == 0 || i == level.length - 1 || j == 0 || j == level[0].length - 1)
						level[i][j] = 1;
					else level[i][j] = 0;
					if (Math.random() < 0.1) level[i][j] = 1;
					if (i == 9 && j == 4) level[i][j] = 0;
					if (i == 0 && j == 4) level[i][j] = 0;
					if (i == 4 && j == 0) level[i][j] = 0;
					if (i == 4 && j == 7) level[i][j] = 0;
					if (i == 4 && j == 2) level[i][j] = 1;
				}
			}
		}
		
	}

}