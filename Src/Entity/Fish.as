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
    public var anim:Number=0;

    public function Fish(pos:Point)
    {
      physical = new CPhysical(this, pos);
      sprite = new CSprite(this, "fish");      
    }

    public override function render():void
    {
      sprite.render(physical.pos)
    }

    public override function update():void
    {
      if(game.input.anyKey())
        game.updateStep();
      anim += 0.03;
      while(anim > 1)
        anim--;
      sprite.frame = anim*4;
      if(physical.facingLeft)
        sprite.frame += 4;
    }

    public override function updateStep():void
    {
        var dir:int = -1;
        if(game.input.upKey()) dir = 0;
        if(game.input.rightKey()) dir = 1;
        if(game.input.downKey()) dir = 2;
        if(game.input.leftKey()) dir = 3;
        if(dir!=-1)
          physical.doMove(dir);
    }
  }
}