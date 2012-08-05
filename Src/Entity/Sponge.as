package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Sponge extends Entity
  {
    public var physical:CPhysical;
    public var sprite:CSprite;

    public function Sponge(pos:Point)
    {
      physical = new CPhysical(this, pos);
      sprite = new CSprite(this, "sponge");
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
      if(!fish)
        return;
      var dir:int = -1;
      for(var i:int=0; i<4; i++)
      {
        var offset:Point = offsetFromDir(i);
        var checkPoint:Point = new Point(offset.x+physical.pos.x, offset.y+physical.pos.y);
        if(fish.physical.pos.x == checkPoint.x && fish.physical.pos.y == checkPoint.y)
          dir = (i+2)%4;
      }
      physical.doMove(offsetFromDir(dir));
    }
  }
}