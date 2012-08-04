package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Starfish extends Entity
  {
    public var physical:CPhysical;
    public var sprite:CSprite;
    public var dir:int;
    public var clockwise:Boolean;

    public function Starfish(pos:Point)
    {
      physical = new CPhysical(this, pos);
      sprite = new CSprite(this, "starfish");
      dir = 0;
      clockwise = true;
    }

    public override function render():void
    {
      sprite.render(physical.pos)
    }

    public override function update():void
    {
      sprite.frame = game.anim*4;
      if(clockwise) sprite.frame += 4;
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
      return tile.t != Tile.T_WALL;
    }

    public function pickDir():int
    {
      if(testDir(dir))
      {
        return dir;
      }
      if(testDir((dir+1)%4))
      {
        clockwise = true;
        return (dir+1)%4;
      }
      if(testDir((dir+3)%4))
      {
        clockwise = false;
        return (dir+3)%4;
      }
      if(testDir((dir+2)%4))
      {
        clockwise = false;
        return (dir+2)%4;
      }
      return -1;
    }

    public override function updateStep():void
    {
      dir = pickDir();
      physical.doMove(offsetFromDir(dir));
    }
  }
}