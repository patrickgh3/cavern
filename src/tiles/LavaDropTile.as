package tiles 
{
	import entities.LavaDrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * Tile which drops LavaDrops periodically.
	 */
	public class LavaDropTile extends Tile
	{
		private var count:int = dropRate / 2;
		private const dropRate:int = 70;
		
		public function LavaDropTile(xpos:int, ypos:int, r:Room) 
		{
			super(xpos, ypos, 3, 0, r, Tile.SOLID);
		}
		
		override public function update():void
		{
			count++;
			if (count == dropRate)
			{
				count = 0;
				FP.world.add(new LavaDrop(x + 4, y + 11));
			}
		}
		
		override public function clone(r:Room):Tile
		{
			return new LavaDropTile(x, y, r);
		}
		
	}

}