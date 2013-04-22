package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import tiles.MemoryTile;
	
	/**
	 * Main game world.
	 */
	public class GameWorld extends World
	{
		public var _player:Player;
		private var _blackfade:BlackFade;
		public var _room:Room;
		private var roomX:int = 7;
		private var roomY:int = 2;
		private var spawnX:int = 48;
		private var spawnY:int = 32;
		private var spawnRoomX:int = roomX;
		private var spawnRoomY:int = roomY;
		private var lookingforspawn:Boolean = false;
		
		public function GameWorld() 
		{
			_player = new Player();
			_player.x = spawnX;
			_player.y = spawnY;
			var ps:PlayerSprite = new PlayerSprite(_player);
		}
		
		public function init():void
		{
			switchRoom(roomX, roomY);
		}
		
		override public function update():void
		{
			MemoryTile.update();
			super.update();
			
			if (_player.x < -_player.width / 2) {
				_player.x += 160;
				switchRoom(--roomX, roomY);
				setSpawn();
			}
			if (_player.x >= 160 - _player.width / 2) {
				_player.x -= 160;
				switchRoom(++roomX, roomY);
				setSpawn();
			}
			if (_player.y < -_player.height / 2) {
				_player.y += 128;
				switchRoom(roomX, --roomY);
				lookingforspawn = true;
			}
			if (_player.y >= 128 - _player.height / 2) {
				_player.y -= 128;
				switchRoom(roomX, ++roomY);
				lookingforspawn = true;
			}
			
			Ambiance.update();
			
			if (lookingforspawn && _player.onGround())
			{
				lookingforspawn = false;
				setSpawn();
			}
		}
		
		private function switchRoom(x:int, y:int):void
		{
			_room = RoomContainer.getRoom(roomX, roomY);
			this.removeAll();
			for (var i:int = 0; i < 12; i++)
				for (var j:int = 0; j < 10; j++)
					if (_room.tiles[i][j] != null) add(_room.tiles[i][j]);
			_player.setLevel(_room.level);
			add(_player);
			add(_player.getSprite());
			if (_blackfade != null) add(_blackfade);
			Ambiance.switchTo(_room.sound);
		}
		
		private function setSpawn():void
		{
			spawnX = 16 * int((_player.x + _player.width / 2) / 16) + 1
					 + (8 - _player.width / 2);
			spawnY = _player.y;
			spawnRoomX = roomX;
			spawnRoomY = roomY;
		}
		
		public function playerKilled():void
		{
			remove(_player);
			remove(_player.getSprite());
			_blackfade = new BlackFade();
			add(_blackfade);
			lookingforspawn = false;
		}
		
		public function fadeIn():void
		{
			_player.x = spawnX;
			_player.y = spawnY;
			roomX = spawnRoomX;
			roomY = spawnRoomY;
			switchRoom(roomX, roomY);
		}
		
	}

}