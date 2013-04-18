package entities 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Falling lava drop created by LavaDropTile
	 */
	public class LavaDrop extends Instakiller
	{
		[Embed(source = "/../assets/lavadrop.png")]
		private const src:Class;
		
		private const yaccel:Number = 0.1;
		private const animSpeed:int = 4;
		
		private var yspeed:Number = 0.5;
		private var splashed:Boolean = false;
		private var count:int = 0;
		private var sprite:Spritemap;
		
		public function LavaDrop(x:int, y:int) 
		{
			super(x, y, 8, 8);
			sprite = new Spritemap(src, 8, 8);
			graphic = sprite;
		}
		
		override public function update():void
		{
			if (!splashed)
			{
				super.update();
				yspeed += yaccel;
				y += yspeed;
			}
			else
			{
				if (count % animSpeed == 0)
				{
					if (count == animSpeed * 3)
					{
						FP.world.remove(this);
					}
					else
					{
						sprite.setFrame(count / animSpeed + 1, 0);
					}
				}
				count++;
			}
			
			if (GameWorld(FP.world)._room.level[int(x / 16 + 1)][int((y + 7) / 16 + 1)] == Tile.INSTAKILL)
			{
				FP.world.remove(this);
			}
			
			while (GameWorld(FP.world)._room.level[int(x / 16 + 1)][int((y + 7) / 16 + 1)] == Tile.SOLID)
			{
				splashed = true;
				y--;
			}
			
			
		}
		
	}

}