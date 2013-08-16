package tiles 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * Door tile which opens and closes based on SwitchTiles present.
	 */
	public class SwitchDoorTile extends Tile
	{
		[Embed(source = "/../assets/switchdoor.png")]
		private const src:Class;
		[Embed(source = "/../assets/sound/switchdoor.mp3")]
		private const doorsound:Class;
		
		private static const numframes:int = 8;
		private static const animspeed:int = 5;
		private var count:int;
		private var sprite:Spritemap;
		private var sfxDoor:Sfx;
		
		public function SwitchDoorTile(xpos:int, ypos:int, r:Room) 
		{
			super(xpos, ypos, 0, 0, r, Tile.SOLID);
			sprite = new Spritemap(src, 16, 16);
			graphic = sprite;
			sfxDoor = new Sfx(doorsound);
		}
		
		override public function update():void
		{
			// opening
			if (SwitchTile.numActivated >= SwitchTile.numTiles && count < numframes * animspeed)
			{
				if (count == 0)
				{
					sfxDoor.stop();
					sfxDoor.playCustom(1, this);
				}
				sprite.setFrame(count / animspeed, 0);
				count++;
			}
			// closing
			else if (SwitchTile.numActivated < SwitchTile.numTiles && count > 0)
			{
				if (count == numframes * animspeed)
				{
					sfxDoor.stop();
					sfxDoor.playCustom(1, this);
				}
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