package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * Tile which flickers like the "static" TV screen.
	 */
	public class StaticTile extends Tile
	{
		[Embed(source = "/../assets/static.png")]
		private static const src:Class;
		
		public static const BLOCK:int = 1;
		private static const animSpeed:int = 2;
		
		private var statictype:int;
		private var count:int = 0;
		
		private var sprite:Spritemap;
		
		public function StaticTile(xpos:int, ypos:int, r:Room, statictype:int)
		{
			super(xpos, ypos, 0, 0, r, Tile.SOLID);
			this.statictype = statictype;
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
		}
		
		override public function update():void
		{
			count++;
			if (count == animSpeed)
			{
				count = 0;
				sprite.setFrame(Math.random() * 6, 0);
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new StaticTile(x, y, r, statictype);
		}
		
	}

}