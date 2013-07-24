package overlays 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	
	/**
	 * Overlay activated with Esc key that shows game info and controls.
	 */
	public class OverlayEscape
	{
		private var background:Entity;
		private var texts:Array;
		private var i:int, j:int;
		
		public function OverlayEscape() 
		{
			background = new Entity(0, 0);
			background.graphic = Image.createRect(160, 128, 0x000000);
			(Image)(background.graphic).alpha = 0.6;
			
			texts = new Array();
			Text.size = 8;
			var x:int = 20;
			texts.push(new Entity(x, 10, new Text("Cavern")));
			texts.push(new Entity(x, 35, new Text("Right, Left")));
			texts.push(new Entity(x, 45, new Text("Z, Up")));
			texts.push(new Entity(x, 55, new Text("X")));
			texts.push(new Entity(x, 65, new Text("C")));
			texts.push(new Entity(x, 90, new Text("Game by Patrick Traynor")));
			texts.push(new Entity(x, 100, new Text("Powered by FlashPunk,")));
			texts.push(new Entity(x + 10, 110, new Text("Ogmo, and freesound.org")));

		}
		
		public function addSelf():void
		{
			var w:World = FP.world;
			w.add(background);
			for (i = 0; i < texts.length; i++) w.add(texts[i]);
		}
		
		public function removeSelf():void
		{
			var w:World = FP.world;
			w.remove(background);
			for (i = 0; i < texts.length; i++) w.remove(texts[i]);
		}
	}

}