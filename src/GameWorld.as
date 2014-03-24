package  
{
	import entities.*;
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
	import extraentities.FallFade;
	import tiles.SpikeTile;
	
	/**
	 * Main game world.
	 */
	public class GameWorld extends World
	{
		public var player:Player;
		public var teleportBar:TeleportBar;
		private var blackFade:BlackFade;
		private var playerParticles:Array;
		private var fallFade:FallFade;
		public var fadeText:FadeText;
		
		public var room:Room;
		public var roomX:int;
		public var roomY:int;
		private var spawnX:int = shrineRoomPlayerX;
		private var spawnY:int = shrineRoomPlayerY;
		private var spawnRoomX:int =shrineRoomX;
		private var spawnRoomY:int = shrineRoomY;
		private var lookingforspawn:Boolean = false;
		private var killplayernext:Boolean = false;
		private var killedplayerlast:Boolean = false;
		
		public var world:int = world_normal;
		public static const world_normal:int = 1;
		public static const world_intro:int = 2;
		public static const world_end:int = 3;
		
		public static const text_jump:String = "Z, up";
		private static const text_map:String = "Hold X";
		public static const text_warp:String = "Hold C";
		
		private static var shrineRoomX:int = 7;
		private static var shrineRoomY:int = 4;
		private static var shrineRoomPlayerX:int = 75;
		private static var shrineRoomPlayerY:int = 84;
		
		private var fallroomscount:int = 0;
		private static const fallrooms:int = 70;
		
		private var roomsexplored:int = 0;
		private var donefadetextintro:Boolean = false;
		public var donefadetextjump:Boolean = false;
		private var donefadetextmap:Boolean = false;
		public var donefadetextwarp:Boolean = false;
		private static var fadetextlayer:int = -10;
		
		public var overlay_esc:Boolean = false;
		public var overlayEsc:OverlayEscape;
		public var overlay_map:Boolean = false;
		public var overlayMap:OverlayMap;
		
		public function GameWorld() 
		{
			player = new Player();
			player.x = spawnX;
			player.y = spawnY;
			
			var ps:PlayerSprite = new PlayerSprite(player);
			roomX = shrineRoomX;
			roomY = shrineRoomY;
			
			teleportBar = new TeleportBar(player);
			
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
			if (Input.check(Key.DIGIT_1))
			{
				roomX = shrineRoomX;
				roomY = shrineRoomY;
				spawnX = shrineRoomPlayerX;
				spawnY = shrineRoomPlayerY;
				spawnRoomX = roomX;
				spawnRoomY = roomY;
				world = world_normal;
				switchRoom(roomX, roomY);
			}
			if (Input.check(Key.DIGIT_2))
			{
				roomX = 0;
				roomY = 0;
				world = world_intro;
				spawnRoomX = 0;
				spawnRoomY = 0;
				spawnX = 36;
				spawnY = 84;
				player.x = spawnX;
				player.y = spawnY;
				switchRoom(roomX, roomY);
			}
			if (Input.check(Key.DIGIT_3))
			{
				roomX = 0;
				roomY = 0;
				world = world_end;
				spawnRoomX = 0;
				spawnRoomY = 0;
				spawnX = 32;
				spawnY = 32;
				switchRoom(0, 0);
			}
			
			if (killedplayerlast) killedplayerlast = false;
			if (killplayernext)
			{
				killplayernext = false;
				killedplayerlast = true;
				playerKilled();
			}
			
			if (roomsexplored == 5 && donefadetextmap == false)
			{
				fadeText = new FadeText(text_map, -1);
				add(fadeText);
				fadeText.layer = fadetextlayer;
				donefadetextmap = true;
			}
			
			Ambiance.update();
			MemoryTile.update();
			super.update();
			
			// special case: if noclipping and switched rooms diagonally (used to cause a crash)
			var offleft:Boolean = player.x < -player.width / 2;
			var offright:Boolean = player.x >= 160 - player.width / 2;
			var offtop:Boolean = player.y < -player.height / 2;
			var offbottom:Boolean = player.y >= 128 - player.height / 2
			if (player.noclip && (offleft || offright) && (offtop || offbottom))
			{
				if (offleft) player.x = 0;
				if (offright) player.x = 160 - player.width;
				if (offtop) player.y = 0;
				if (offbottom) player.y = 128 - player.height;
			}
			
			if (player.x < -player.width / 2) {
				player.x += 160;
				if (RoomContainer.specialtypes[roomX][roomY] == "lostwoods" && !player.noclip) switchToLostWoods();
				else if (RoomContainer.specialtypes[roomX][roomY] == "longjump" && !player.noclip)
				{
					if (overlayMap.isOrbCollected(roomX, roomY)) fadeText = new FadeText(text_warp, 120);
					donefadetextwarp = true;
					switchRoom(roomX, roomY);
				}
				else
				{
					switchRoom(--roomX, roomY);
					if (world == world_normal) overlayMap.linkRight(roomX, roomY);
					if (!player.noclip) setSpawn();
				}
			}
			if (player.x >= 160 - player.width / 2) {
				player.x -= 160;
				if (RoomContainer.specialtypes[roomX][roomY] == "lostwoods" && !player.noclip) switchToLostWoods();
				else if (RoomContainer.specialtypes[roomX][roomY] == "longjump" && !player.noclip)
				{
					if (overlayMap.isOrbCollected(roomX, roomY)) fadeText = new FadeText(text_warp, 120);
					donefadetextwarp = true;
					switchRoom(roomX, roomY);
				}
				else
				{
					switchRoom(++roomX, roomY);
					if (world == world_normal) overlayMap.linkLeft(roomX, roomY);
					if (!player.noclip) setSpawn();
				}
			}
			if (player.y < -player.height / 2) {
				player.y += 128;
				if (RoomContainer.specialtypes[roomX][roomY] == "lostwoods" && !player.noclip) switchToLostWoods();
				else
				{
					switchRoom(roomX, --roomY);
					overlayMap.linkBottom(roomX, roomY);
					if (!player.noclip) lookingforspawn = true;
				}
			}
			if (player.y >= 128 - player.height / 2) {
				player.y -= 128;
				if (RoomContainer.specialtypes[roomX][roomY] == "lostwoods" && !player.noclip) switchToLostWoods();
				else if (world == world_intro && roomY == 0)
				{
					room = RoomContainerExtra.getIntroRoom(roomX, ++roomY).clone();
					switchRoom( -1, -1, true);
					fallFade = new FallFade();
					add(fallFade);
				}
				else if (world == world_intro && fallroomscount < fallrooms)
				{
					room = RoomContainerExtra.getIntroRoom(roomX, roomY).clone();
					switchRoom(-1, -1, true);
					add(fallFade);
					fallroomscount++;
				}
				else if (world == world_intro && fallroomscount == fallrooms)
				{
					roomX = shrineRoomX;
					roomY = shrineRoomY;
					spawnX = shrineRoomPlayerX;
					spawnY = shrineRoomPlayerY;
					spawnRoomX = roomX;
					spawnRoomY = roomY;
					world = world_normal;
					player.stopXMovement(false);
					player.x = spawnX;
					player.y = spawnY;
					switchRoom(roomX, roomY);
					fallFade.fadeIn();
					add(fallFade);
				}
				else
				{
					switchRoom(roomX, ++roomY);
					overlayMap.linkTop(roomX, roomY);
					if (!player.noclip) lookingforspawn = true;
				}
			}
			
			if (lookingforspawn && player.onGround())
			{
				lookingforspawn = false;
				setSpawn();
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
			
			if (Input.check(Key.X) && world == world_normal && !overlay_map)
			{
				overlay_map = true;
				overlayMap.addSelf();
				if (fadeText != null && fadeText.getText() == text_map) fadeText.fadeOut();
			}
			else if (!Input.check(Key.X))
			{
				overlay_map = false;
				overlayMap.removeSelf();
			}
		}
		
		private function switchRoom(x:int, y:int, ignoreCoords:Boolean = false):void
		{
			if (room != null) room.cleanup();
			if (ignoreCoords) { }
			else if (world == world_normal)
			{
				room = RoomContainer.cloneRoom(roomX, roomY);
			}
			else if (world == world_intro)
			{
				room = RoomContainerExtra.getIntroRoom(roomX, roomY);
			}
			else if (world == world_end)
			{
				room = RoomContainerExtra.getEndRoom(roomX, roomY);
			}
			
			if (world == world_normal) roomsexplored++;
			
			if (roomX == 0 && roomY == 0 && world == world_intro && !donefadetextintro)
			{
				fadeText = new FadeText("asdf", -1, true);
				donefadetextintro = true;
			}
			else if (roomX == 1 && roomY == 0 && world == world_intro && !donefadetextjump)
			{
				fadeText = new FadeText(text_jump, -1);
				donefadetextjump = true;
			}
			else if (roomX == 1 && roomY == 1 && world == world_normal)
			{
				fadeText = new FadeText(text_warp, 120);
				donefadetextwarp = true;
			}
			
			this.removeAll();
			for (var i:int = 0; i < 12; i++)
				for (var j:int = 0; j < 10; j++)
					if (room.tiles[i][j] != null) add(room.tiles[i][j]);
			for (i = 0; i < room.actors.length; i++)
				add(room.actors[i]);
			
			if (RoomContainer.mapcolors[roomX][roomY] == RoomContainer.mapcolorvalues.green)
				for (i = 0; i < 3; i++)
				{
					add(new GreenBlock(GreenBlock.horizontal));
					add(new GreenBlock(GreenBlock.vertical));
				}
			
			if (roomX == shrineRoomX && roomY == shrineRoomY)
			{
				(Shrine)(room.actors[0]).addOrbs(this);
			}
			
			player.setRoom(room.level, room.actors);
			add(player);
			add(player.getSprite());
			add(teleportBar);
			teleportBar.resetCount();
			if (blackFade != null)
			{
				add(blackFade);
				for (i = 0; i < playerParticles.length; i++) add(playerParticles[i]);
			}
			if (fadeText != null)
			{
				add(fadeText);
				fadeText.layer = fadetextlayer;
			}
			
			if (overlay_esc) overlayEsc.addSelf();
			if (overlay_map) overlayMap.addSelf();
			overlayMap.setHighlight(roomX, roomY);
			
			if (world == world_normal)
			{
				Ambiance.switchTo(RoomContainer.sounds[roomX][roomY]);
			}
			else if (world == world_intro)
			{
				if (roomY == 0) Ambiance.switchTo("wind");
				else Ambiance.switchTo("silent");
			}
		}
		
		private function setSpawn():void
		{
			spawnX = 16 * int((player.x + player.width / 2) / 16) + 1
					 + (8 - player.width / 2);
			spawnY = player.y;
			spawnRoomX = roomX;
			spawnRoomY = roomY;
		}
		
		public function killPlayer():void
		{
			if (!killedplayerlast && !player.isDead()) killplayernext = true;
		}
		
		public function playerKilled():void
		{
			var oldplayerx:int = player.x;
			var oldplayery:int = player.y;
			
			player.x = spawnX; // player is moved here to avoid being in old place for 1 frame when he is visible again.
			player.y = spawnY;
			remove(player);
			remove(player.getSprite());
			remove(teleportBar);
			teleportBar.resetCount();
			
			player.kill();
			blackFade = new BlackFade();
			add(blackFade);
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
			//player.setdead = false;
			roomX = spawnRoomX;
			roomY = spawnRoomY;
			switchRoom(roomX, roomY);
			remove(player);
			remove(player.getSprite());
			remove(teleportBar);
		}
		
		public function fadeComplete():void
		{
			player.setDead(false);
			add(player);
			add(player.getSprite());
			add(teleportBar);
			for (var i:int = 0; i < playerParticles.length; i++) remove(playerParticles[i]);
			blackFade = null;
		}
		
		public function teleportBarFull():void
		{
			spawnRoomX = shrineRoomX;
			spawnRoomY = shrineRoomY;
			spawnX = shrineRoomPlayerX;
			spawnY = shrineRoomPlayerY;
			killPlayer();
		}
		
		private function switchToLostWoods():void
		{
			switchRoom(roomX, roomY);
			Room.lostwoodscount++;
			if (Room.lostwoodscount >= Room.lostwoodsneeded && !overlayMap.isOrbCollected(roomX, roomY))
			{
				add(new Orb(85, 36, roomX, roomY));
			}
			else if (Room.lostwoodscount >= Room.lostwoodsneeded && overlayMap.isOrbCollected(roomX, roomY))
			{
				fadeText = new FadeText(text_warp, 120);
				add(fadeText);
				donefadetextwarp = true;
			}
		}
	}

}