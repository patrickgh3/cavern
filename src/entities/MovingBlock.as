package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Solid moving block that the player collides with.
	 */
	public class MovingBlock extends Entity
	{
		private const UP:int = 1;
		private const DOWN:int = 2;
		private const LEFT:int = 3;
		private const RIGHT:int = 4;
		private const INVALID:int = 5;
		private var direction:int;
		
		public var xspeed:Number = 0;
		public var yspeed:Number = 0;
		private var path:Array;
		private var player:Player;
		
		private var count:int;
		private var pathindex:int;
		private var moveSpeed:Number;
		private var moveTime:int;
		
		public function MovingBlock(x:int, y:int, movespeed:Number, pathString:String, path:Array = null)
		{
			super(x, y);
			this.xspeed = xspeed;
			this.yspeed = yspeed;
			width = height = 16;
			graphic = Image.createRect(width, height, GreenBlock.greencolor);
			
			moveSpeed = movespeed;
			moveTime = int(16 / moveSpeed) + 1
			
			if (pathString != null)
			{
				var spaces:RegExp = / /gi;
				pathString = pathString.replace(spaces, "");
				
				path = new Array();
				for (var i:int = 0; i < pathString.length; i++)
				{
					switch (pathString.charAt(i)) {
						case 'u': path.push(UP); break;
						case 'd': path.push(DOWN); break;
						case 'l': path.push(LEFT); break;
						case 'r': path.push(RIGHT); break;
						default: path.push(INVALID); trace("Invalid path character in MovingBlock.");
					}
				}
			}
			if (path != null)
			{
				this.path = path;
			}
			count = moveTime - 1;
			pathindex = path.length - 1;
		}
		
		override public function update():void
		{
			if (player == null) player = GameWorld(FP.world)._player;
			
			var movePlayerDown:Boolean = false;
			if (collidePlayer(-1))
			{
				player._extraxspeed = xspeed;
				movePlayerDown = true;
			}
			
			x += xspeed;
			y += yspeed;
			
			while (collidePlayer() && !(xspeed == 0 && yspeed == 0) && !player.noclip)
			{
				player.x += 0.2 * Util.sign(xspeed);
				player.y += 0.2 * Util.sign(yspeed);
			}
			
			count++;
			if (count == moveTime)
			{
				count = 0;
				pathindex++;
				if (pathindex == path.length) pathindex = 0;
				
				direction = path[pathindex];
				xspeed = yspeed = 0;
				switch (direction) {
					case UP: yspeed = -moveSpeed; break;
					case DOWN: yspeed = moveSpeed; break;
					case LEFT: xspeed = -moveSpeed; break;
					case RIGHT: xspeed = moveSpeed; break;
				}
				
				x += 8;
				y += 8;
				x = int(x / 16) * 16;
				y = int(y / 16) * 16;
			}
			
			if (movePlayerDown && !player.noclip)
			{
				player.y = y - player.height;
				//player.yspeed = 0;
			}
		}
		
		private function collidePlayer(yoffset:Number = 0):Boolean
		{
			return x < player.x + player.width - 0.5
				   && x + width > player.x
				   && y + 1 + yoffset < player.y + player.height
				   && y + height + yoffset > player.y;
		}
		
		public function clone():MovingBlock
		{
			return new MovingBlock(x, y, moveSpeed, null, path); // TODO: add xspeed, width, path, etc
		}
		
	}

}