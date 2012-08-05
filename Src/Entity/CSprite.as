package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class CSprite
  {
    private var e:Entity;
    public var sprite:String;
    public var frame:int;
    
    public function CSprite(e:Entity, sprite:String)
    {
      this.e = e;
      this.sprite = sprite;
      
      frame = 0;
    }
    
    public function render(pos:Point):void
    {
      var drawPos:Point = new Point(pos.x*16, pos.y*16);
      e.game.renderer.drawSprite(sprite, drawPos.x, drawPos.y, frame);
    }

    public function smoothRender(apos:Point, bpos:Point):void
    {
      var diff:Point = new Point(bpos.x-apos.x, bpos.y-apos.y);
      var ratioOffset:Number = (Number(e.i)/e.game.entityManager.entities.length);
      var ratio:Number = e.game.transition*2 - ratioOffset;
      if(ratio < 0) ratio = 0;
      if(ratio > 1) ratio = 1;
      var renderPos:Point = new Point(apos.x + diff.x*ratio, apos.y + diff.y*ratio);
      render(renderPos)
    }
  }
}