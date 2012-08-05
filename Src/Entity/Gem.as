package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Gem extends Entity
  {
    public var sprite:CSprite;
    public var pos:Point;

    public function Gem(pos:Point)
    {
      sprite = new CSprite(this, "gem");
      this.pos = pos;
    }

    public override function render():void
    {
      sprite.render(pos);
    }

    public override function update():void
    {
      sprite.frame = game.anim*4;
    }

    public override function updateStep():void
    {
      var fish:Fish = game.entityManager.getFish();
      if(fish)
      {
        if(fish.physical.pos.x == pos.x && fish.physical.pos.y == pos.y)
          alive = false;
      }
    }
  }
}
