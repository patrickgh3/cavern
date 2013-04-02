package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Main game world.
	 */
	public class GameWorld extends World
	{
		[Embed(source = "/../assets/solidtile.png")]
		private const WHITE:Class
		[Embed(source = "/../assets/bgtile.png")]
		private const GREY:Class
		
		private var _player:Player;
		private var _room:Room;
		private var roomX:int = 0;
		private var roomY:int = 0;
		
		public function GameWorld() 
		{
			_player = new Player();
			_player.x = 32;
			_player.y = 32;
			
			switchRoom(0, 0);
		}
		
		override public function update():void
		{
			super.update();
			if (_player.x < -_player.width / 2) {
				_player.x += 160;
				switchRoom(--roomX, roomY);
			}
			if (_player.x >= 160 - _player.width / 2) {
				_player.x -= 160;
				switchRoom(++roomX, roomY);
			}
			if (_player.y < -_player.height / 2) {
				_player.y += 128;
				switchRoom(roomX, --roomY);
			}
			if (_player.y >= 128 - _player.height / 2) {
				_player.y -= 128;
				switchRoom(roomX, ++roomY);
			}
		}
		
		private function switchRoom(x:int, y:int):void
		{
			_room = RoomContainer.getRoom(roomX, roomY);
			
			this.removeAll();
			var g1:Graphic = new Image(WHITE);
			var g2:Graphic = new Image(GREY);
			for (var i:int = 0; i < 10; i++)
			{
				for (var j:int = 0; j < 8; j++)
				{
					if (_room.level[i][j] == 1)
						add(new Entity(i * 16, j * 16, g1));
					else if ((i + j) / 2 == int((i + j) / 2))
						add(new Entity(i * 16, j * 16, g2));
				}
			}
			_player.setLevel(_room.level);
			add(_player);
		}
		
	}

}