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

    public function doMove(dir:int):void
    {
      var offset:Point = new Point(0,0);
      switch(dir)
      {
        case 0: offset.y--; break;
        case 1: offset.x++; break;
        case 2: offset.y++; break;
        case 3: offset.x--; break;
      }
      if(dir==1) facingLeft = false;
      if(dir==3) facingLeft = true;
      var newPoint:Point = new Point(pos.x+offset.x, pos.y+offset.y);
      var tile:Tile = e.game.tileMap.getTile(newPoint.x, newPoint.y);
      if(tile.t != Tile.T_WALL)
        pos = newPoint;

    }
  }
}