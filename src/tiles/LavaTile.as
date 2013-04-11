package tiles 
{
	import entities.Instakiller;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * Animated lava tile.
	 */
	public class LavaTile extends Tile
	{
		[Embed(source = "/../assets/lava.png")]
		private const src:Class;
		
		public static const CENTER:int = 1;
		public static const TOP:int = 2;
		private static const animRate:int = 40;
		
		private var lavatype:int;
		private var count:int;
		private var sprite:Spritemap;
		
		public function LavaTile(xpos:int, ypos:int, r:Room, lavatype:int) 
		{
			super(xpos, ypos, 0, 0, r, 0);
			this.lavatype = lavatype;
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			if (lavatype == CENTER)
			{
				tileType = Tile.INSTAKILL;
				sprite.setFrame(0, 0);
			}
			else if (lavatype == TOP)
			{
				tileType = Tile.EMPTY;
				sprite.setFrame(0, 1);
			}
		}
		
		override public function update():void
		{
			count++;
			if (count == animRate * 4) count = 0;
			if (lavatype == CENTER)
			{
				
			}
			else if (lavatype == TOP)
			{
				if (count % animRate == 0)
					sprite.setFrame(count / animRate, 1);
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new LavaTile(x, y, r, lavatype);
		}
		
		override public function roomStart():void
		{
			if (lavatype == TOP)
			{
				_room.instakillEntities.push(new Instakiller(x, y + 4, 16, 12));
			}
		}
		
	}

}