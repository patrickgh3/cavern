package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Particle used during the player's respawn animation.
	 */
	public class PlayerParticle extends Entity
	{
		private var init_velocity:Number = 1.5;
		private var init_acceleration:Number = 0.0425;
		
		private var count:Number = 0;
		private const totaltime:Number = BlackFade.fadeTime * 2 + BlackFade.waitTime;
		
		private var origin:Point = new Point();
		private var target:Point = new Point();
		private var center:Point = new Point();
		private var vel:Point = new Point();
		private var accel:Point = new Point();
		private var offset:Point = new Point();
		
		public function PlayerParticle() 
		{
			super(0, 0);
			graphic = Image.createRect(4, 4, 0xffffff);
		}
		
		public function activate(x:int, y:int, dx:int, dy:int):void
		{
			count = 0;
			offset.x = 0;
			offset.y = 0;
			this.x = x;
			this.y = y;
			origin.x = x;
			origin.y = y;
			target.x = origin.x + dx;
			target.y = origin.y + dy;
			var angle:Number = Math.random() * Math.PI * 2;
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			vel.x = init_velocity * sin;
			vel.y = init_velocity * cos;
			accel.x = init_acceleration * sin * -1;
			accel.y = init_acceleration * cos * -1;
		}
		
		override public function update():void
		{
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