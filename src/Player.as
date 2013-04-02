package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	
	/**
	 * Entity that the player controls.
	 */
	public class Player extends Entity
	{
		[Embed(source = "/../assets/player.png")]
		private const IMAGE:Class;
		
		private const runSpeed:Number = 1.5;
		private const grav:Number = 0.13;
		private const jumpSpeed:Number = 2.89;
		
		private var _xspeed:Number;
		private var _yspeed:Number;
		private var _level:Array;
		private var _jumpReleased:Boolean;
		
		public function Player() 
		{
			super();
			graphic = new Image(IMAGE);
			_yspeed = 0;
			width = 10;
			height = 12;
		}
		
		override public function update():void
		{
			var right:Boolean = Input.check(Key.RIGHT);
			var left:Boolean = Input.check(Key.LEFT);
			var jump:Boolean = Input.check(Key.Z) || Input.check(Key.UP);
			
			if (right && !left) _xspeed = runSpeed;
			else if (left && !right) _xspeed = -runSpeed;
			else _xspeed = 0;
			// TODO: tapping right and left make the player move slowly to allow precision positioning ?
			// TODO: pressing a direction overrides the previous one held down ?
			
			_yspeed += grav;
			var x1:int = int(x / 16);
			var x2:int = int((x + width - 1) / 16);
			var y2:int = int((y + height) / 16);
			if (x1 < 0) x1 = x2;
			if (x2 >= _level.length) x2 = x1;
			if (y2 < 0) y2 = 0;
			if (y2 >= _level[0].length) y2 = _level[0].length - 1;
			var onGround:Boolean = _yspeed > 0 && _yspeed < 1 && (_level[x1][y2] == 1 || _level[x2][y2] == 1);
			if (jump && _jumpReleased && onGround)
				_yspeed = -jumpSpeed;
			_jumpReleased = !jump;
			// TODO: variable jump height based on time jump held down.
			
			var xstep:int = 0;
			var xmax:Number = Math.abs(_xspeed);
			var xdir:int = Math.abs(_xspeed) / _xspeed;
			var ystep:int = 0;
			var ymax:Number = Math.abs(_yspeed);
			var ydir:int = Math.abs(_yspeed) / _yspeed;
			var diff:Number;
			for (var n:int = 0; n < 10; n++)
			{
				if (xstep < xmax)
				{
					diff = xdir * Math.min(1, (xmax - xstep));
					x += diff;
					xstep++;
					if (collideLevel())
					{
						x -= diff;
						xstep--;
					}
				}
				if (ystep < ymax)
				{
					if (ystep < ymax)
					{
						diff = ydir * Math.min(1, (ymax - ystep));
						y += diff;
						ystep++;
						if (collideLevel())
						{
							y = int(y - ydir) + 0.5;
							ystep--;
							_yspeed = 0;
						}
					}
				}
			}
		}
		
		public function setLevel(level:Array):void
		{
			_level = level;
		}
		
		private function collideLevel():Boolean
		{
			var x1:int = int(x / 16);
			var x2:int = int((x + width - 1) / 16);
			var y1:int = int(y / 16);
			var y2:int = int((y + height - 1) / 16);
			
			if (x1 < 0) x1 = x2;
			if (x2 >= _level.length) x2 = x1;
			if (y1 < 0) y1 = y2;
			if (y2 >= _level[0].length) y2 = y1;
			
			if (x1 < 0 || x2 < 0 || y1 < 0 || y2 < 0 ||
				x1 >= _level.length || x2 >= _level.length || y1 >= _level[0].length || y2 >= _level[0].length)
				trace("Player's collideLevel: out of bounds.\nx1: " + x1 + "    x2: " + x2 + "    y1: " + y1 + "    y2: " + y2);
				
			return _level[x1][y1] == 1 ||
				   _level[x1][y2] == 1 ||
				   _level[x2][y1] == 1 ||
				   _level[x2][y2] == 1;
		}
		
	}

}