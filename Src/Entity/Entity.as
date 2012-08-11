package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*;
  import Src.*;
  import Src.Tiles.*;

  public class Entity
  {
    public var alive:Boolean;
    private var manager:EntityManager;
    public var i:int;
    public var precedence_mod:int;

    public function Entity()
    {
      alive = true;
      i = -1;
      precedence_mod = 0;
    }

    public function setManager(manager:EntityManager):void
    {
      this.manager = manager;
    }
    
    public function get game():Game
    {
      return manager.game;
    }    

    public function update():void {}
    public function updateStep():void {}
    public function render():void {}


    public function offsetFromDir(d:int):Point
    {
      var offset:Point = new Point(0,0);
      switch(d)
      {
        case 0: offset.y--; break;
        case 1: offset.x++; break;
        case 2: offset.y++; break;
        case 3: offset.x--; break;
      }
      return offset;
    }

    public function testDir(pos:Point, d:int):Boolean
    {
      var newPoint:Point = pos.clone();
      var offset:Point = offsetFromDir(d);
      newPoint.x += offset.x;
      newPoint.y += offset.y;
      var tile:Tile = game.tileMap.getTile(newPoint.x, newPoint.y);
      if(tile.t == Tile.T_WALL)
        return false;
      var entity:Entity = game.entityManager.getAtPos(newPoint, this);      
      if(entity && !(entity is Fish))
        return false;
      return true;
    }
  }
}