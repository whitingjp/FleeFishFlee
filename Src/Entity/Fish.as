package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Fish extends Entity
  {
    public var physical:CPhysical;
    public var sprite:CSprite;


    public function Fish(pos:Point)
    {
      physical = new CPhysical(this, pos);
      sprite = new CSprite(this, "fish");      
    }

    public override function render():void
    {
      sprite.render(physical.pos)
    }

    public function getDir():int
    {
      if(game.input.upKey()) return 0;
      if(game.input.rightKey()) return 1;
      if(game.input.downKey()) return 2;
      if(game.input.leftKey()) return 3;
      return -1;
    }

    public override function update():void
    {
      if(game.input.anyKey())
      {
        var dir:int = getDir();
        if(dir != -1 && testDir(physical.pos, dir))
          game.updateStep();
      }
      sprite.frame = game.anim*4;
      if(physical.facingLeft)
        sprite.frame += 4;
      var camTarget:Point = new Point(physical.pos.x*16+8, physical.pos.y*16+8);
      game.camera.setTarget(camTarget);
    }

    public override function updateStep():void
    {
      var dir:int = getDir();
      if(dir != -1)
        physical.doMove(offsetFromDir(dir));
    }
  }
}