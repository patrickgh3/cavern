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
		
		private const noclipSpeed:Number = 3;
		private const runSpeed:Number = 1.5;
		private const grav:Number = 0.13;
		private const jumpSpeed:Number = 2.89;
		
		private const gravcutoff:Number = -1;
		private const extragrav:Number = 0.4;
		
		private var _xspeed:Number;
		private var _yspeed:Number;
		private var _level:Array;
		private var _jumpReleased:Boolean;
		private var _sprite:PlayerSprite;
		public var noclip:Boolean = false;
		public var dead:Boolean = false;
		
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
			var suicide:Boolean = Input.check(Key.R) || Input.check(Key.Q);
			
			dead = false;
			
			if (suicide) {
				GameWorld(FP.world).killPlayer();
				return;
			}
			
			if (Input.pressed(Key.N))
				noclip = !noclip;
			if (noclip)
			{
				var up:Boolean = Input.check(Key.UP);
				var down:Boolean = Input.check(Key.DOWN);
				if (right && !left)
					x += noclipSpeed;
				else if (left && !right)
					x -= noclipSpeed;
				if (down && !up)
					y += noclipSpeed;
				else if (up && !down)
					y -= noclipSpeed;
				return;
			}
			
			if (right && !left) _xspeed = runSpeed;
			else if (left && !right) _xspeed = -runSpeed;
			else _xspeed = 0;
			// TODO: tapping right and left make the player move slowly to allow precision positioning ?
			_yspeed += grav;
			if (_yspeed < gravcutoff && !jump) _yspeed += extragrav;
			if (jump && _jumpReleased && onGround()) {
				_yspeed = -jumpSpeed;
			}
			_jumpReleased = !jump;
			
			//if (collideLevel()) kill();
			
			var xstep:int = 0;
			var xmax:Number = Math.abs(_xspeed);
			var xdir:int = Math.abs(_xspeed) / _xspeed;
			var ystep:int = 0;
			var ymax:Number = Math.abs(_yspeed);
			var ydir:int = Math.abs(_yspeed) / _yspeed;
			var diff:Number;
			for (var n:int = 0; n < Math.abs(_xspeed) + Math.abs(_yspeed); n++)
			{
				if (xstep < xmax)
				{
					diff = xdir * Math.min(1, (xmax - xstep));
					x += diff;
					xstep++;
					if (collideLevel()) // || collideMovingBlock()
					{
						touchTiles(); // TODO: don't touch tiles multiple times?
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
						if (collideLevel()) // || collideMovingBlock()
						{
							touchTiles(); // multi touch?
							y -= diff;
							ystep--;
							_yspeed = 0;
						}
					}
				}
			}
			if (collideLevel(2)) GameWorld(FP.world).killPlayer();
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
		
		private function touchTiles():void
		{
			var x1:int = int(x / 16);
			var x2:int = int((x + width - 1) / 16);
			var y1:int = int(y / 16);
			var y2:int = int((y + height - 1) / 16);
			if (x < 0) x1 = -1;
			if (y < 0) y1 = -1;
			x1 += 1;
			y1 += 1;
			x2 += 1;
			y2 += 1;
			touchTile(x1, y1);
			touchTile(x1, y2);
			touchTile(x2, y1);
			touchTile(x2, y2);
		}
		
		private function touchTile(x:int, y:int):void
		{
			if (GameWorld(FP.world)._room.tiles[x][y] != null)
				GameWorld(FP.world)._room.tiles[x][y].touch();
		}
		
		private function getLevel(x:int, y:int):int
		{
			return _level[x + 1][y + 1];
		}
		
		public function kill():void
		{
			_xspeed = 0;
			_yspeed = 0;
			dead = true;
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