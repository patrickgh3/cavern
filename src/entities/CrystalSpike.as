package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * 
	 */
	public class CrystalSpike extends Entity
	{
		[Embed(source = "/../assets/crystal.png")]
		private static const src:Class;
		
		public static const UP:int = 0;
		public static const DOWN:int = 1;
		public static const LEFT:int = 2;
		public static const RIGHT:int = 3;
		public static const stdlayer:int = -4;
		
		private var hitboxes:Array;
		private var lastState:int;
		private var xpattern:Array;
		private var ypattern:Array;
		private var patternindex:int = -1;
		private var movementcount:int = -1;
		private static const movementtime:int = 5;
		private var firsttick:Boolean = false;
		
		private var xpatstring:String;
		private var ypatstring:String;
		private var direction:int;
		
		public function CrystalSpike(xpos:int, ypos:int, direction:int, xpat:String, ypat:String) 
		{
			super(xpos, ypos);
			layer = stdlayer;
			
			xpatstring = xpat;
			ypatstring = ypat;
			var i:int = 0;
			xpattern = xpat.split(" ");
			for (i = 0; i < xpattern.length; i++)
			{
				xpattern[i] = parseInt(xpattern[i]);
			}
			ypattern = ypat.split(" ");
			for (i = 0; i < ypattern.length; i++)
			{
				ypattern[i] = parseInt(ypattern[i]);
			}
			
			// todo: precise hitboxes (instakillers) and other directions / shapes(?)
			hitboxes = new Array();
			var sprite:Spritemap;
			graphic = sprite = new Spritemap(src, 16, 16);
			
			this.direction = direction;
			if (direction == UP)
			{
				sprite.setFrame(0);
				hitboxes.push(new Instakiller(x + 6, y + 2, 4, 14));
				hitboxes.push(new Instakiller(x + 4, y + 7, 8, 9));
				hitboxes.push(new Instakiller(x + 2, y + 10, 12, 6));
			}
			else if (direction == DOWN)
			{
				sprite.setFrame(1);
				hitboxes.push(new Instakiller(x + 2, y + 2, 12, 12));
			}
			else if (direction == LEFT)
			{
				sprite.setFrame(2);
				hitboxes.push(new Instakiller(x + 2, y + 2, 12, 12));
			}
			else if (direction == RIGHT)
			{
				sprite.setFrame(3);
				hitboxes.push(new Instakiller(x + 2, y + 2, 12, 12));
			}
			for (i = 0; i < hitboxes.length; i++)
			{
				FP.world.add(hitboxes[i]);
			}
			lastState = state;
		}
		
		override public function update():void
		{
			if (firsttick)
			{
				firsttick = false;
			}
			
			if (state != lastState)
			{
				lastState = state;
				
				// first, finish up current movement if we have to
				while (movementcount >= 0)
				{
					moveInPattern();
				}
				
				patternindex++;
				if (patternindex >= xpattern.length) patternindex = 0;
				if (xpattern[patternindex] != 0 || ypattern[patternindex] != 0) sfxMove.play(1);
				movementcount = 0;
			}
			if (movementcount >= 0)
			{
				moveInPattern();
			}
		}
		
		// todo: sparkle / shine effect?
		
		private function moveInPattern():void
		{
			var dx:Number = (Number)(xpattern[patternindex]) / (Number)(movementtime);
			var dy:Number = (Number)(ypattern[patternindex]) / (Number)(movementtime);
			x += dx;
			y += dy;
			for (var i:int = 0; i < hitboxes.length; i++)
			{
				hitboxes[i].x += dx;
				hitboxes[i].y += dy;
			}
			movementcount++;
			if (movementcount == movementtime)
			{
				movementcount = -1;
				// snap to nearest position on 8x8 grid
				x += 4;
				y += 4;
				x = (int)(x / 8) * 8;
				y = (int)(y / 8) * 8;
			}
		}
		
		public function clone():CrystalSpike
		{
			return new CrystalSpike(x, y, direction, xpatstring, ypatstring);
		}
		
		[Embed(source = "/../assets/sound/crystal.mp3")]
		private static const move:Class;
		
		private static var sfxMove:Sfx = new Sfx(move);
		
		private static var state:int = 0;
		
		public static function triggerNext():void
		{
			state = 1 - state;
		}
	}

}