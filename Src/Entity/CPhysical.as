package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class CPhysical
  {
    private var e:Entity;

    public var pos:Point;
    public var facingLeft:Boolean=false;

    public function CPhysical(e:Entity, pos:Point)
    {
      this.e = e;
      this.pos = pos.clone();      
    }

    public function doMove(offset:Point):void
    {
      if(offset.x > 0) facingLeft = false;
      if(offset.x < 0) facingLeft = true;
      var newPoint:Point = new Point(pos.x+offset.x, pos.y+offset.y);
      var tile:Tile = e.game.tileMap.getTile(newPoint.x, newPoint.y);
      if(tile.t != Tile.T_WALL)
        pos = newPoint;

    }
  }
}