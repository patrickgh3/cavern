package  
{
	import entities.GreenBlock;
	import entities.Orb;
	import entities.PlayerParticle;
	import entities.Shrine;
	import entities.ShrineOrb;
	import entities.TeleportBar;
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
		public var teleportBar:TeleportBar;
		private var _blackfade:BlackFade;
		private var playerParticles:Array;
		public var _room:Room;
		public var roomX:int;
		public var roomY:int;
		private var spawnX:int = shrineRoomPlayerX;
		private var spawnY:int = shrineRoomPlayerY;
		private var spawnRoomX:int =shrineRoomX;
		private var spawnRoomY:int = shrineRoomY;
		private var lookingforspawn:Boolean = false;
		private var killplayernext:Boolean = false;
		private var killedplayerlast:Boolean = false;
		
		private static var shrineRoomX:int = 7;
		private static var shrineRoomY:int = 4;
		private static var shrineRoomPlayerX:int = 75;
		private static var shrineRoomPlayerY:int = 84;
		
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
			roomX = shrineRoomX;
			roomY = shrineRoomY;
			
			teleportBar = new TeleportBar(_player);
			
			playerParticles = new Array();
			for (var i:int = 0; i < 6; i++)
			{
				playerParticles[i] = new PlayerParticle();
			}
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
			if (Input.check(Key.F)) overlayMap.discoverAll();
			
			if (killedplayerlast) killedplayerlast = false;
			if (killplayernext)
			{
				killplayernext = false;
				killedplayerlast = true;
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
				if (RoomContainer.specialtypes[roomX][roomY] == "lostwoods" && !_player.noclip) switchToLostWoods();
				else if (RoomContainer.specialtypes[roomX][roomY] == "longjump" && !_player.noclip) switchRoom(roomX, roomY);
				else
				{
					switchRoom(--roomX, roomY);
					overlayMap.linkRight(roomX, roomY);
					if (!_player.noclip) setSpawn();
				}
			}
			if (_player.x >= 160 - _player.width / 2) {
				_player.x -= 160;
				if (RoomContainer.specialtypes[roomX][roomY] == "lostwoods" && !_player.noclip) switchToLostWoods();
				else if (RoomContainer.specialtypes[roomX][roomY] == "longjump" && !_player.noclip) switchRoom(roomX, roomY);
				else
				{
					switchRoom(++roomX, roomY);
					overlayMap.linkLeft(roomX, roomY);
					if (!_player.noclip) setSpawn();
				}
			}
			if (_player.y < -_player.height / 2) {
				_player.y += 128;
				if (RoomContainer.specialtypes[roomX][roomY] == "lostwoods" && !_player.noclip) switchToLostWoods();
				else
				{
					switchRoom(roomX, --roomY);
					overlayMap.linkBottom(roomX, roomY);
					if (!_player.noclip) lookingforspawn = true;
				}
			}
			if (_player.y >= 128 - _player.height / 2) {
				_player.y -= 128;
				if (RoomContainer.specialtypes[roomX][roomY] == "lostwoods" && !_player.noclip) switchToLostWoods();
				else
				{
					switchRoom(roomX, ++roomY);
					overlayMap.linkTop(roomX, roomY);
					if (!_player.noclip) lookingforspawn = true;
				}
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
			
			if (RoomContainer.mapcolors[roomX][roomY] == RoomContainer.mapcolorvalues.green)
				for (i = 0; i < 3; i++)
				{
					add(new GreenBlock(GreenBlock.horizontal));
					add(new GreenBlock(GreenBlock.vertical));
				}
			
			if (roomX == shrineRoomX && roomY == shrineRoomY)
			{
				(Shrine)(_room.actors[0]).addOrbs(this);
			}
			
			_player.setRoom(_room.level, _room.actors);
			add(_player);
			add(_player.getSprite());
			add(teleportBar);
			teleportBar.resetCount();
			if (_blackfade != null)
			{
				add(_blackfade);
				for (i = 0; i < playerParticles.length; i++) add(playerParticles[i]);
			}
			
			if (overlay_esc) overlayEsc.addSelf();
			if (overlay_map) overlayMap.addSelf();
			overlayMap.setHighlight(roomX, roomY);
			
			//Ambiance.switchTo(RoomContainer.sounds[roomX][roomY]);
			//Ambiance.switchTo("cave1");
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
			if (!killedplayerlast) killplayernext = true;
		}
		
		public function playerKilled():void
		{
			var oldplayerx:int = _player.x;
			var oldplayery:int = _player.y;
			
			_player.x = spawnX; // player is moved here to avoid being in old place for 1 frame when he is visible again.
			_player.y = spawnY;
			remove(_player);
			remove(_player.getSprite());
			remove(teleportBar);
			teleportBar.resetCount();
			
			_player.kill();
			_blackfade = new BlackFade();
			add(_blackfade);
			lookingforspawn = false;
			
			var dx:int = spawnX - oldplayerx;
			var dy:int = spawnY - oldplayery;
			playerParticles[0].activate(oldplayerx + 1, oldplayery, dx, dy);
			playerParticles[1].activate(oldplayerx + 5, oldplayery, dx, dy);
			playerParticles[2].activate(oldplayerx + 1, oldplayery + 4, dx, dy);
			playerParticles[3].activate(oldplayerx + 5, oldplayery + 4, dx, dy);
			playerParticles[4].activate(oldplayerx + 1, oldplayery + 8, dx, dy);
			playerParticles[5].activate(oldplayerx + 5, oldplayery + 8, dx, dy);
			for (var i:int = 0; i < playerParticles.length; i++) add(playerParticles[i]);
		}
		
		public function fadeIn():void
		{
			_player.dead = false;
			roomX = spawnRoomX;
			roomY = spawnRoomY;
			switchRoom(roomX, roomY);
			remove(_player);
			remove(_player.getSprite());
			remove(teleportBar);
		}
		
		public function fadeComplete():void
		{
			add(_player);
			add(_player.getSprite());
			add(teleportBar);
			for (var i:int = 0; i < playerParticles.length; i++) remove(playerParticles[i]);
			_blackfade = null;
		}
		
		public function teleportBarFull():void
		{
			spawnRoomX = shrineRoomX;
			spawnRoomY = shrineRoomY;
			spawnX = shrineRoomPlayerX;
			spawnY = shrineRoomPlayerY;
			playerKilled();
		}
		
		private function switchToLostWoods():void
		{
			switchRoom(roomX, roomY);
			Room.lostwoodscount++;
			if (Room.lostwoodscount >= Room.lostwoodsneeded && !overlayMap.isOrbCollected(roomX, roomY))
			{
				add(new Orb(80, 32, roomX, roomY));
			} // TODO: reset lostwoodscount when leaving.
		}
		
	}

}