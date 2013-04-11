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
		private var _sprite:PlayerSprite;
		
		public function Player() 
		{
			super();
			_yspeed = 0;
			width = 10;
			height = 12;
		}
		
		override public function update():void
		{
			var right:Boolean = Input.check(Key.RIGHT);
			var left:Boolean = Input.check(Key.LEFT);
			var jump:Boolean = Input.check(Key.Z) || Input.check(Key.UP);
			var kill:Boolean = Input.check(Key.R) || Input.check(Key.Q);
			
			if (kill) {
				this.kill();
				return;
			}
			
			if (right && !left) _xspeed = runSpeed;
			else if (left && !right) _xspeed = -runSpeed;
			else _xspeed = 0;
			// TODO: tapping right and left make the player move slowly to allow precision positioning ?
			// TODO: pressing a direction overrides the previous one held down ?
			_yspeed += grav;
			if (jump && _jumpReleased && onGround()) {
				_yspeed = -jumpSpeed;
			}
			_jumpReleased = !jump;
			// TODO: variable jump height based on time jump held down.
			
			//if (collideLevel()) kill();
			
			var xstep:int = 0;
			var xmax:Number = Math.abs(_xspeed);
			var xdir:int = Math.abs(_xspeed) / _xspeed;
			var ystep:int = 0;
			var ymax:Number = Math.abs(_yspeed);
			var ydir:int = Math.abs(_yspeed) / _yspeed;
			var diff:Number;
			for (var n:int = 0; n < 10; n++) // TODO: change 10 to an appropriate cap (depends on x,yspeed)
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
							y -= diff;
							ystep--;
							_yspeed = 0;
						}
					}
				}
			}
			if (collideLevel(2)) this.kill();
		}
		
		public function setLevel(level:Array):void
		{
			_level = level;
		}
		
		private function collideLevel(tiletype:int = 1):Boolean
		{
			var x1:int = int(x / 16);
			var x2:int = int((x + width - 1) / 16);
			var y1:int = int(y / 16);
			var y2:int = int((y + height - 1) / 16);
			if (x < 0) x1 = -1;
			if (y < 0) y1 = -1;
				
			return getLevel(x1, y1) == tiletype ||
				   getLevel(x1, y2) == tiletype ||
				   getLevel(x2, y1) == tiletype ||
				   getLevel(x2, y2) == tiletype;
		}
		
		private function getLevel(x:int, y:int):int
		{
			return _level[x + 1][y + 1];
		}
		
		public function kill():void
		{
			GameWorld(FP.world).playerKilled();
		}
		
		public function getSprite():Entity
		{
			return _sprite;
		}
		
		public function setSprite(ps:PlayerSprite):void
		{
			_sprite = ps;
		}
		
		public function getXSpeed():Number
		{
			return _xspeed;
		}
		
		public function getYSpeed():Number
		{
			return _yspeed;
		}
		
		public function onGround():Boolean
		{
			var x1:int = int(x / 16);
			var x2:int = int((x + width - 1) / 16);
			var y2:int = int((y + height) / 16);
			if (x < 0) x1 = -1;
			
			return (getLevel(x1, y2) == 1 || getLevel(x2, y2) == 1) && _yspeed >= 0;
		}
		
	}

}