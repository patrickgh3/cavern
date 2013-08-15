package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Bridge tile used in the intro and end levels.
	 */
	public class IntroBridgeTile extends Tile
	{
		[Embed(source = "/../assets/introbridge.png")]
		private const src:Class;
		
		public static var bridgetiles:Array = new Array();
		
		private var sprite:Spritemap;
		
		public function IntroBridgeTile(x:int, y:int, r:Room) 
		{
			super(x, y, 0, 0, r, Tile.SOLID);
			bridgetiles.push(this);
			
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
		}
		
		public function drop():void
		{
			sprite.setFrame(1, 0);
			setLevel(Tile.EMPTY);
		}
		
		public function raise():void
		{
			sprite.setFrame(0, 0);
			setLevel(Tile.SOLID);
		}
		
		public static function drop():void
		{
			for (var i:int = 0; i < bridgetiles.length; i++)
			{
				(IntroBridgeTile)(bridgetiles[i]).drop();
			}
		}
		
		public static function raise():void
		{
			for (var i:int = 0; i < bridgetiles.length; i++)
			{
				(IntroBridgeTile)(bridgetiles[i]).raise();
			}
		}
		
	}

}