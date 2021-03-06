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
    public var oldPos:Point;
    public var facingLeft:Boolean=false;

    public function CPhysical(e:Entity, pos:Point)
    {
      this.e = e;
      this.pos = pos.clone(); 
      this.oldPos = pos.clone();     
    }

    public function doMove(offset:Point):void
    {
      oldPos = pos.clone();
      if(offset.x > 0) facingLeft = false;
      if(offset.x < 0) facingLeft = true;
      var newPoint:Point = new Point(pos.x+offset.x, pos.y+offset.y);
      var tile:Tile = e.game.tileMap.getTile(newPoint.x, newPoint.y);
      if(tile.t == Tile.T_WALL)
        return;

      var entity:Entity = e.game.entityManager.getAtPos(newPoint, e);
      if(!entity || entity is Fish)
        pos = newPoint;

    }
  }
}