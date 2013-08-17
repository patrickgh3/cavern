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
		public static const dropRate:int = 70;
		
		private var count:int = dropRate / 2;
		private var offset:int = 0;
		
		public function LavaDropTile(xpos:int, ypos:int, r:Room, dropOffset:int = 0) 
		{
			super(xpos, ypos, 3, 0, r, Tile.SOLID);
			count += dropOffset;
			count %= dropRate;
			offset = dropOffset;
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
			return new LavaDropTile(x, y, r, offset);
		}
		
	}

}