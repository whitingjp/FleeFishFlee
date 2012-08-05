package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.ui.Keyboard;
  import flash.utils.Dictionary;
  import Src.Tiles.*;

  public class Gem extends Entity
  {
    public var sprite:CSprite;
    public var pos:Point;
    public var deadTimer:Number=0;

    public function Gem(pos:Point)
    {
      sprite = new CSprite(this, "gem");
      this.pos = pos;
    }

    public override function render():void
    {
      sprite.render(pos);
    }

    public override function update():void
    {
      sprite.frame = game.anim*4;
      var fish:Fish = game.entityManager.getFish();
      if(fish)
      {
        if(fish.physical.pos.x == pos.x && fish.physical.pos.y == pos.y && deadTimer == 0)
        {
          deadTimer = 0.001;
          game.soundManager.playSound("diamond");
        }
      }

      if(deadTimer > 0)
      {
        deadTimer += 0.05;
        sprite.frame = 4+5*deadTimer;
      }

      if(deadTimer > 1)
      {
        alive = false;
        // am i the last?
        var count:int=0;
        var i:int
        for(i=0; i<game.entityManager.entities.length; i++)
        {
          if(game.entityManager.entities[i] is Gem)
            count++;
        }
        if(count==1) // just me
          game.nextLevel();
      }
    }

    public override function updateStep():void
    {

    }
  }
}
