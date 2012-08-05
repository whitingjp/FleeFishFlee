package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Pufferfish extends Entity
  {
    public var physical:CPhysical;
    public var sprite:CSprite;
    public var up:Boolean;

    public function Pufferfish(pos:Point)
    {
      physical = new CPhysical(this, pos);
      sprite = new CSprite(this, "pufferfish");
      up = true;
    }

    public override function render():void
    {
      sprite.render(physical.pos)
    }

    public override function update():void
    {
      sprite.frame = game.anim*4;
      if(!up) sprite.frame += 4;
    }

    public override function updateStep():void
    {
      if(up && !testDir(physical.pos, 0))
        up = !up;
      if(!up && !testDir(physical.pos, 2))
        up = !up;
      if(up)
        physical.doMove(new Point(0,-1));
      else
        physical.doMove(new Point(0,1))
    }
  }
}