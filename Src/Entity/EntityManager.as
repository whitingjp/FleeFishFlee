package Src.Entity
{
  import mx.core.*;
  import mx.collections.*;
  import Src.*;

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
  }
}