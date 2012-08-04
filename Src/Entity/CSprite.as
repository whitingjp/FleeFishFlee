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
  }
}