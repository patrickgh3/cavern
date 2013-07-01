package  
{
	import entities.GreenBlock;
	import entities.Orb;
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import overlays.OverlayEscape;
	import overlays.OverlayMap;
	import tiles.MemoryTile;
	import entities.BlackFade;
	
	/**
	 * Main game world.
	 */
	public class GameWorld extends World
	{
		public var _player:Player;
		private var _blackfade:BlackFade;
		public var _room:Room;
		public var roomX:int = 8;
		public var roomY:int = 4;
		private var spawnX:int = 48;
		private var spawnY:int = 32;
		private var spawnRoomX:int = roomX;
		private var spawnRoomY:int = roomY;
		private var lookingforspawn:Boolean = false;
		private var killplayernext:Boolean = false;
		
		public var overlay_esc:Boolean = false;
		public var overlayEsc:OverlayEscape;
		public var overlay_map:Boolean = false;
		public var overlayMap:OverlayMap;
		
		public function GameWorld() 
		{
			_player = new Player();
			_player.x = spawnX;
			_player.y = spawnY;
			var ps:PlayerSprite = new PlayerSprite(_player);
		}
		
		public function init():void
		{
			overlayEsc = new OverlayEscape();
			overlayMap = new OverlayMap(roomX, roomY);
			switchRoom(roomX, roomY);
			overlayMap.discover(roomX, roomY);
		}
		
		override public function update():void
		{
			if (Input.check(Key.F)) overlayMap.traceData();
			if (killplayernext)
			{
				killplayernext = false;
				playerKilled();
			}
			
			if (Input.check(Key.ESCAPE) && !overlay_esc)
			{
				overlay_esc = true;
				overlayEsc.addSelf();
			}
			else if (!Input.check(Key.ESCAPE))
			{
				overlay_esc = false;
				overlayEsc.removeSelf();
			}
			
			if (Input.check(Key.X) && !overlay_map)
			{
				overlay_map = true;
				overlayMap.addSelf();
			}
			else if (!Input.check(Key.X))
			{
				overlay_map = false;
				overlayMap.removeSelf();
			}
			
			Ambiance.update();
			MemoryTile.update();
			super.update();
			
			if (_player.x < -_player.width / 2) {
				_player.x += 160;
				switchRoom(--roomX, roomY);
				overlayMap.linkRight(roomX, roomY);
				overlayMap
				if (!_player.noclip) setSpawn();
			}
			if (_player.x >= 160 - _player.width / 2) {
				_player.x -= 160;
				switchRoom(++roomX, roomY);
				overlayMap.linkLeft(roomX, roomY);
				if (!_player.noclip) setSpawn();
			}
			if (_player.y < -_player.height / 2) {
				_player.y += 128;
				switchRoom(roomX, --roomY);
				overlayMap.linkBottom(roomX, roomY);
				if (!_player.noclip) lookingforspawn = true;
			}
			if (_player.y >= 128 - _player.height / 2) {
				_player.y -= 128;
				switchRoom(roomX, ++roomY);
				overlayMap.linkTop(roomX, roomY);
				if (!_player.noclip) lookingforspawn = true;
			}
			
			if (lookingforspawn && _player.onGround())
			{
				lookingforspawn = false;
				setSpawn();
			}
		}
		
		private function switchRoom(x:int, y:int):void
		{
			_room = RoomContainer.cloneRoom(roomX, roomY);
			
			this.removeAll();
			for (var i:int = 0; i < 12; i++)
				for (var j:int = 0; j < 10; j++)
					if (_room.tiles[i][j] != null) add(_room.tiles[i][j]);
			for (i = 0; i < _room.actors.length; i++)
				add(_room.actors[i]);
			
			_player.setRoom(_room.level, _room.actors);
			add(_player);
			add(_player.getSprite());
			if (_blackfade != null) add(_blackfade);
			
			if (overlay_esc) overlayEsc.addSelf();
			if (overlay_map) overlayMap.addSelf();
			overlayMap.setHighlight(roomX, roomY);
			
			//Ambiance.switchTo(RoomContainer.sounds[roomX][roomY]);
			Ambiance.switchTo("cave1");
			
			add(new GreenBlock(GreenBlock.horizontal));
			add(new GreenBlock(GreenBlock.vertical));
			add(new GreenBlock(GreenBlock.horizontal));
			add(new GreenBlock(GreenBlock.vertical));
			add(new GreenBlock(GreenBlock.horizontal));
			add(new GreenBlock(GreenBlock.vertical));
		}
		
		private function setSpawn():void
		{
			spawnX = 16 * int((_player.x + _player.width / 2) / 16) + 1
					 + (8 - _player.width / 2);
			spawnY = _player.y;
			spawnRoomX = roomX;
			spawnRoomY = roomY;
		}
		
		public function killPlayer():void
		{
			killplayernext = true;
		}
		
		public function playerKilled():void
		{
			remove(_player);
			remove(_player.getSprite());
			_player.kill();
			_blackfade = new BlackFade();
			add(_blackfade);
			lookingforspawn = false;
		}
		
		public function fadeIn():void
		{
			_player.x = spawnX;
			_player.y = spawnY;
			_player.dead = false;
			roomX = spawnRoomX;
			roomY = spawnRoomY;
			switchRoom(roomX, roomY);
		}
		
	}

}