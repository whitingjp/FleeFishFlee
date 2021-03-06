package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import Src.*;
  import flash.geom.*;

  public class EntityManager
  {
    public var entities:Array;
    private var subMoves:int;
    public var game:Game;

    public function EntityManager(game:Game, subMoves:int)
    {      
      this.game = game;
      this.subMoves = subMoves;
      reset();
    }
    
    public function reset():void
    {
      entities = new Array();
    }

    public function push(entity:Entity):void
    {
      entity.setManager(this);
      entities.push(entity);
    }

    public function update():void
    {
      var i:int;
      var j:int;
      entities.sort(orderPriority);
      for(i=0; i<entities.length; i++)
        entities[i].i = i;
      for(i=0; i<entities.length; i++)
        entities[i].update();
      entities = entities.filter(isAlive);
    }

    public function updateStep():void
    {
      game.soundManager.playSound("move");

      var i:int;
      var fish:Fish = getFish();

      var justPlayer:Boolean = false;
      // look for seaweed
      for(i=0; i<entities.length; i++)
        if(entities[i] is Seaweed)
          if(entities[i].pos.x == fish.physical.pos.x && entities[i].pos.y == fish.physical.pos.y)
            justPlayer = true;

      if(justPlayer)
      {
        fish.updateStep();
        for(i=0; i<entities.length; i++)
        {
          if(entities[i] == fish)
            continue
          if(entities[i].hasOwnProperty("physical"))
            entities[i].physical.oldPos = entities[i].physical.pos;
        }
      }
      else
      {
        for(i=0; i<entities.length; i++)
         entities[i].updateStep();
      }

      for(i=0; i<entities.length; i++)
      {
        if(entities[i]==fish)
          continue;
        if(entities[i].hasOwnProperty("physical"))
        {
          if(entities[i].physical.pos.x == fish.physical.pos.x && entities[i].physical.pos.y == fish.physical.pos.y && fish.deadTimer == 0)
          {
            fish.deadTimer = 0.01;
            game.soundManager.playSound("death");
          }
        }
      }

    }

    public function render():void
    {
      for(var i:int=0; i<entities.length; i++)
        entities[i].render();
    }

    private function isAlive(element:*, index:int, arr:Array):Boolean
    {
      return element.alive;
    }

    public function getFish():Fish
    {
      for(var i:int=0; i<entities.length; i++)
      {
        if(entities[i] is Fish)
          return entities[i];
      }
      return null;
    }

    public function getAtPos(pos:Point, me:Entity):Entity
    {
      for(var i:int=0; i<entities.length; i++)
      {
        if(entities[i] == me)
          continue;
        if(entities[i].hasOwnProperty("physical"))
        {
          var physical:CPhysical = entities[i].physical;
          if((physical.pos.x == pos.x) && (physical.pos.y == pos.y))
            return entities[i];
        }
      }
      return null;
    }

    public function orderPriority(a:Entity, b:Entity):int
    {
      var aP:int = getPriority(a);
      var bP:int = getPriority(b);
      if(aP > bP)
        return 1;
      if(aP < bP)
        return -1;
      if(a.precedence_mod > b.precedence_mod)
        return 1;
      if(a.precedence_mod < b.precedence_mod)
        return -1;
      return 0;
    }

    public function getPriority(e:Entity):int
    {
      if(e is Fish)
        return 0;
      if(e is Sponge)
        return 1;
      if(e is Pufferfish)
        return 2;
      if(e is Starfish)
        return 3;
      if(e is Octopus)
        return 4;
      return 999;
    }
  }
}