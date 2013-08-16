package entities 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * Falling lava drop created by LavaDropTile
	 */
	public class LavaDrop extends Instakiller
	{
		[Embed(source = "/../assets/lavadrop.png")]
		private const src:Class;
		
		[Embed(source = "/../assets/sound/drip1.mp3")]
		private const drip1:Class;
		[Embed(source = "/../assets/sound/drip2.mp3")]
		private const drip2:Class;
		[Embed(source = "/../assets/sound/drip3.mp3")]
		private const drip3:Class;
		
		private const yaccel:Number = 0.1;
		private const animSpeed:int = 4;
		
		private var yspeed:Number = 0.5;
		private var splashed:Boolean = false;
		private var count:int = 0;
		private var sfxDrip:Sfx;
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
			
			var justsplashed:Boolean = false;
			if (GameWorld(FP.world).room.level[int(x / 16 + 1)][int((y + 7) / 16 + 1)] == Tile.INSTAKILL)
			{
				FP.world.remove(this);
				justsplashed = true;
			}
			
			while (GameWorld(FP.world).room.level[int(x / 16 + 1)][int((y + 7) / 16 + 1)] == Tile.SOLID)
			{
				splashed = true;
				y--;
				justsplashed = true;
			}
			
			if (justsplashed)
			{
				var r:Number = Math.random();
				if (r < 0.33) sfxDrip = new Sfx(drip1);
				else if (r < 0.66) sfxDrip = new Sfx(drip2);
				else sfxDrip = new Sfx(drip3);
				sfxDrip.playCustom(1, this);
			}
			
			
		}
		
	}

}