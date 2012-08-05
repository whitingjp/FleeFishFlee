package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Seaweed extends Entity
  {
    public var pos:Point;
    public var sprite:CSprite;

    public function Seaweed(pos:Point)
    {
      this.pos = pos;
      this.sprite = new CSprite(this, "seaweed")
    }

    public override function render():void
    {
      sprite.render(pos);
    }

    public override function update():void
    {
      //sprite.frame = game.anim*4;
    }

    public override function updateStep():void
    {
    }
  }
}