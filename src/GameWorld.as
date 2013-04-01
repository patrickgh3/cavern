package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Main game world.
	 */
	public class GameWorld extends World
	{
		[Embed(source = "/../assets/solidtile.png")]
		private const WHITE:Class
		[Embed(source = "/../assets/bgtile.png")]
		private const GREY:Class
		
		private var _player:Player;
		private var _level:Array;
		
		public function GameWorld() 
		{
			_level = new Array(10);
			for (var i:int = 0; i < 10; i++)
			{
				_level[i] = new Array();
				for (var j:int = 0; j < 8; j++)
				{
					if (i == 0 || i == _level.length - 1 || j == 0 || j == _level[0].length - 1)
						_level[i][j] = 1;
					else _level[i][j] = 0;
					if (Math.random() < 0.1) _level[i][j] = 1;
				}
			}
			
			var g1:Graphic = new Image(WHITE);
			var g2:Graphic = new Image(GREY);
			for (i = 0; i < 10; i++)
			{
				for (j = 0; j < 8; j++)
				{
					if (_level[i][j] == 1)
						add(new Entity(i * 16, j * 16, g1));
					else if ((i + j) / 2 == int((i + j) / 2))
						add(new Entity(i * 16, j * 16, g2));
				}
			}
			
			_player = new Player(_level);
			_player.x = 32;
			_player.y = 32;
			add(_player);
			
			
		}
		
	}

}