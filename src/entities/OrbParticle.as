package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Particle emitted by Orbs when collected that moves outward, then towards the player.
	 */
	public class OrbParticle extends Entity
	{	
		private var init_velocity:Number = 2;
		private var init_acceleration:Number = 0.0678;
		
		private var count:Number = 0;
		private const totaltime:Number = 60;
		
		private var origin:Point = new Point();
		private var target:Point = new Point();
		private var center:Point = new Point();
		private var vel:Point = new Point();
		private var accel:Point = new Point();
		private var offset:Point = new Point();
		
		private var player:Player;
		
		public function OrbParticle(x:int, y:int, angle:Number) 
		{
			super(x, y);
			graphic = Image.createRect(2, 2, 0xffffff);
			origin.x = x;
			origin.y = y;
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			vel.x = init_velocity * sin;
			vel.y = init_velocity * cos;
			accel.x = init_acceleration * sin * -1;
			accel.y = init_acceleration * cos * -1;
		}
		
		override public function update():void
		{
			if (player == null) player = (GameWorld)(FP.world)._player;
			target.x = player.x + player.width / 2;
			target.y = player.y + player.height / 2;
			
			count++;
			if (count == totaltime) FP.world.remove(this);
			var ratio:Number = count / totaltime;
			center.x = (origin.x + ratio * (target.x - origin.x));
			center.y = (origin.y + ratio * (target.y - origin.y));
			
			vel.x += accel.x;
			vel.y += accel.y;
			offset.x += vel.x;
			offset.y += vel.y;
			
			x = center.x + offset.x;
			y = center.y + offset.y;
		}
		
	}

}