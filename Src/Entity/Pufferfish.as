package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Pufferfish extends Entity
  {
    public var physical:CPhysical;
    public var sprite:CSprite;
    public var up:Boolean;

    public function Pufferfish(pos:Point)
    {
      physical = new CPhysical(this, pos);
      sprite = new CSprite(this, "pufferfish");
      up = true;
    }

    public override function render():void
    {
      sprite.render(physical.pos)
    }

    public override function update():void
    {
      sprite.frame = game.anim*4;
      if(!up) sprite.frame += 4;
    }

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

    public function testDir(d:int):Boolean
    {
      var newPoint:Point = physical.pos.clone();
      var offset:Point = offsetFromDir(d);
      newPoint.x += offset.x;
      newPoint.y += offset.y;
      var tile:Tile = game.tileMap.getTile(newPoint.x, newPoint.y);
      if(tile.t == Tile.T_WALL)
        return false;
      var entity:Entity = game.entityManager.getAtPos(newPoint, this);
      if(entity)
        return false;
      return true;
    }

    public override function updateStep():void
    {
      if(up && !testDir(0))
        up = !up;
      if(!up && !testDir(2))
        up = !up;
      if(up)
        physical.doMove(new Point(0,-1));
      else
        physical.doMove(new Point(0,1))
    }
  }
}