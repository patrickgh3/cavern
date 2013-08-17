package  
{
	import entities.GreenBlock;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import tiles.*;
	
	/**
	 * A basic tile in the game's grid.
	 */
	public class Tile extends Entity
	{
		[Embed(source = "/../levels/tileset1.png")]
		private const TILES:Class;
		
		public static const EMPTY:int = 0;
		public static const SOLID:int = 1;
		public static const INSTAKILL:int = 2;
		public static const FACTORY_TEMP:int = 3;
		
		public var tileType:int;
		protected var _x:int;
		protected var _y:int
		protected var _room:Room;
		
		public function Tile(xpos:int, ypos:int, x:int, y:int, r:Room, type:int) 
		{
			super(xpos, ypos);
			_x = x;
			_y = y;
			_room = r;
			tileType = type;
			width = height = 16;
			
			if (x == 0 && y == 3) graphic = Image.createRect(16, 16, GreenBlock.greencolor);
			else graphic = new Image(TILES, new Rectangle(x * 16, y * 16, 16, 16));
		}
		
		public function roomStart():void { }
		
		public function touch():void { }
		
		public function clone(r:Room):Tile
		{
			return new Tile(x, y, _x, _y, r, tileType);
		}
		
		public function setLevel(tiletype:int):void
		{
			_room.level[(x / 16) + 1][(y / 16) + 1] = tiletype;
		}
		
		public static function getTile(xpos:int, ypos:int, x:int, y:int, r:Room):Tile
		{
			if (x == 0 && y == 0) return new LavaTile(xpos, ypos, r, LavaTile.CENTER);
			else if (x == 1 && y == 0) return new LavaTile(xpos, ypos, r, LavaTile.TOP);
			else if (x == 2 && y == 0) return new CrumbleTile(xpos, ypos, r);
			else if (x == 3 && y == 0) return new LavaDropTile(xpos, ypos, r);
			else if (x == 4 && y == 0) return new LavaDropTile(xpos, ypos, r, LavaDropTile.dropRate / 2);
			else if (x == 5 && y == 0) return new SwitchDoorTile(xpos, ypos, r);
			else if (x == 6 && y == 0) return new SwitchTile(xpos, ypos, r, false);
			else if (x == 7 && y == 0) return new SwitchTile(xpos, ypos, r, true);
			else if (x == 6 && y == 1) return new FactoryTile(xpos, ypos, r);
			else if (x == 7 && y == 1) return new LightningTile(xpos, ypos, r, LightningTile.VERTICAL);
			else if (x == 6 && y == 2) return new LightningTile(xpos, ypos, r, LightningTile.HORIZONTAL);
			else if (x == 1 && y == 3) return new ProbabilityTile(xpos, ypos, 2, 1, 2, 2, r, 0.6);
			else if (x == 2 && y == 3) return new ProbabilityTile(xpos, ypos, 3, 1, 2, 2, r, 0.4);
			else if (x == 7 && y == 3) return new IntroBridgeTile(xpos, ypos, r);
			else if (x == 5 && y == 3) return new ProbabilityTile(xpos, ypos, 4, 3, 3, 4, r, 0.9);
			else if (x == 6 && y == 3) return new ProbabilityTile(xpos, ypos, 4, 3, 3, 4, r, 0.2);
			
			var t:int = 0;
			if (y == 0) t = 2;
			else if (y == 1) t = SOLID;
			else if (y == 2) t = EMPTY;
			else if (y == 3) t = SOLID;
			else if (y == 4) t = EMPTY;
			
			return new Tile(xpos, ypos, x, y, r, t);
		}
		
	}

}