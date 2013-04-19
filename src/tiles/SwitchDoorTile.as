package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Door tile which opens and closes based on SwitchTiles present.
	 */
	public class SwitchDoorTile extends Tile
	{
		[Embed(source = "/../assets/switchdoor.png")]
		private const src:Class;
		
		private static const numframes:int = 8;
		private static const animspeed:int = 5;
		private var count:int;
		private var sprite:Spritemap;
		
		public function SwitchDoorTile(xpos:int, ypos:int, r:Room) 
		{
			super(xpos, ypos, 0, 0, r, Tile.SOLID);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
		}
		
		override public function update():void
		{
			// opening
			if (SwitchTile.numActivated >= SwitchTile.numTiles && count < numframes * animspeed)
			{
				sprite.setFrame(count / animspeed, 0);
				count++;
			}
			// closing
			else if (SwitchTile.numActivated < SwitchTile.numTiles && count > 0)
			{
				count--;
				sprite.setFrame(count / animspeed, 0);
			}
			
			// fully open
			if (count == numframes * animspeed && tileType == Tile.SOLID)
			{
				tileType = Tile.EMPTY;
				setLevel(tileType);
			}
			// closed
			else if (count < numframes * animspeed && tileType == Tile.EMPTY)
			{
				tileType = Tile.SOLID;
				setLevel(tileType);
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new SwitchDoorTile(x, y, r);
		}
		
	}

}