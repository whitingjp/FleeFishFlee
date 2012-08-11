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

    public function Starfish(pos:Point, dir:int)
    {
      physical = new CPhysical(this, pos);
      sprite = new CSprite(this, "starfish");
      this.dir = dir;
      clockwise = true;
    }

    public override function render():void
    {
      sprite.smoothRender(physical.oldPos, physical.pos);
    }

    public override function update():void
    {
      sprite.frame = game.anim*4;
      if(clockwise) sprite.frame += 4;
    }

    public function pickDir():int
    {
      if(testDir(physical.pos, dir))
      {
        return dir;
      }
      if(testDir(physical.pos, (dir+1)%4))
      {
        clockwise = true;
        return (dir+1)%4;
      }
      if(testDir(physical.pos, (dir+3)%4))
      {
        clockwise = false;
        return (dir+3)%4;
      }
      if(testDir(physical.pos, (dir+2)%4))
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