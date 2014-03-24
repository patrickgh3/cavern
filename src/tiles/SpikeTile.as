package tiles 
{
	import entities.CrystalSpike;
	import net.flashpunk.FP;
	import entities.Instakiller;
	
	/**
	 * Tile which just spawns a CrystalSpike entity.
	 */
	public class SpikeTile extends Tile
	{
		private var direction:int;
		
		public function SpikeTile(xpos:int, ypos:int, direction:int, r:Room) 
		{
			super(xpos, ypos, 0, 2, r, Tile.EMPTY);
			this.direction = direction;
		}
		
		public function addSpike():void
		{
			FP.world.add(new CrystalSpike(x, y, direction, "0", "0"));
		}
		
		override public function clone(r:Room):Tile
		{
			return new SpikeTile(x, y, direction, r);
		}
	}

}