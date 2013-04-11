package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Entity which kills the player upon contact.
	 */
	public class Instakiller extends Entity
	{
		private var _player:Player;
		
		public function Instakiller(x:int, y:int, w:int, h:int) 
		{
			super(x, y);
			width = w;
			height = h;
			//graphic = Image.createRect(width, height, 0xffffff);
		}
		
		override public function update():void
		{
			if (_player == null) _player = GameWorld(FP.world)._player;
			if (collidePlayer())
				_player.kill();
		}
		
		private function collidePlayer():Boolean
		{
			return x < _player.x + _player.width
				   && x + width > _player.x
				   && y < _player.y + _player.height
				   && y + height > _player.y;
		}
		
	}

}