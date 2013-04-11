package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * A basic tile in the game's grid.
	 */
	public class Tile extends Entity
	{
		public var tileType:int;
		/* 0 - empty
		 * 1 - solid
		 * 2 - instakill
		 */
		private var _x:int;
		private var _y:int
		
		[Embed(source = "/../levels/tileset1.png")]
		private const TILES:Class;
		
		public function Tile(xpos:int, ypos:int, x:int, y:int, type:int) 
		{
			super(xpos, ypos);
			graphic = new Image(TILES, new Rectangle(x * 16, y * 16, 16, 16));
			this.tileType = type;
			_x = x;
			_y = y;
		}
		
		public static function getTile(xpos:int, ypos:int, x:int, y:int):Tile
		{
			var t:int = 0;
			
			if (y == 0) t = 2;
			else if (y == 1) t = 1;
			else if (y == 2) t = 0;
			
			return new Tile(xpos, ypos, x, y, t);
		}
		
		public function clone():Tile
		{
			return new Tile(x, y, _x, _y, tileType);
		}
		
	}

}