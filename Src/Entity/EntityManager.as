package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import Src.*;
  import flash.geom.*;

  public class EntityManager
  {
    private var entities:Array;
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
        entities[i].update();
      entities = entities.filter(isAlive);
    }

    public function updateStep():void
    {
      for(var i:int=0; i<entities.length; i++)
        entities[i].updateStep();
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
      return 0;
    }

    public function getPriority(e:Entity):int
    {
      if(e is Fish)
        return 0;
      if(e is Pufferfish)
        return 1;
      if(e is Starfish)
        return 2;
      if(e is Octopus)
        return 3;
      return 999;
    }
  }
}