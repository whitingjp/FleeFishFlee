package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Octopus extends Entity
  {
    public var physical:CPhysical;
    public var sprite:CSprite;
    public var anim:Number=0;

    public function Octopus(pos:Point)
    {
      physical = new CPhysical(this, pos);
      sprite = new CSprite(this, "octopus");
    }

    public override function render():void
    {
      sprite.smoothRender(physical.oldPos, physical.pos);
    }

    public override function update():void
    {
      sprite.frame = game.anim*4;
    }

    public override function updateStep():void
    {
      var fish:Fish = game.entityManager.getFish();
      if(fish.physical.pos.y <= physical.pos.y)
        physical.doMove(new Point(0,-1));
      else
      {
        var offset:Point = new Point(0,1);
        if(fish.physical.pos.x < physical.pos.x)
          offset.x = -1;
        if(fish.physical.pos.x > physical.pos.x)
          offset.x = 1;
        physical.doMove(offset);
      }
    }
  }
}