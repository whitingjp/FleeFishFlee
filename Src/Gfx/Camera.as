package Src.Gfx
{
  import mx.core.*;
  import flash.geom.*
  import Src.*;
  import Src.Tiles.*;

  public class Camera
  {
    public var pos:Point;
    private var floatPos:Point;
    private var target:Point;
    private var flickBook:Boolean;
    private var game:Game;
    
    public function Camera(game:Game, flickBook:Boolean=false)
    {
      this.game = game;
      this.flickBook = flickBook;
      this.pos = new Point(0,0);
      this.floatPos = new Point(0,0);
      this.target = new Point(0,0);
    }
    
    public function setTarget(target:Point):void
    {
      if(flickBook)
      {
        var x:int = target.x/game.renderer.width;
        var y:int = target.y/game.renderer.height;
        this.target = new Point(x*game.renderer.width, y*game.renderer.height);
      } else
      {
        this.target = new Point(target.x - game.renderer.width/2,
                                target.y - game.renderer.height/2);
      }
    }

    public function boundTarget():void
    {
      var cameraBound:Rectangle = game.tileMap.cameraBound.clone();
      cameraBound.width -= game.renderer.width;
      cameraBound.height -= game.renderer.height;
      if(target.x > cameraBound.right) target.x = cameraBound.right;
      if(target.y > cameraBound.bottom) target.y = cameraBound.bottom;         
      if(target.x < cameraBound.left) target.x = cameraBound.left;
      if(target.y < cameraBound.top) target.y = cameraBound.top;
    }

    public function jumpToTarget():void
    {
      boundTarget();
      floatPos.x = target.x;
      floatPos.y = target.y;
      pos.x = int(floatPos.x+0.45);
      pos.y = int(floatPos.y+0.45);
    }
    
    public function update():void
    {
      if(game.getState() == Game.STATE_EDITING)
      {
        if(flickBook)
        {
          if(game.input.rightKey(false)) target.x += game.renderer.width;
          if(game.input.leftKey(false)) target.x -= game.renderer.width;
          if(game.input.downKey(false)) target.y += game.renderer.height;
          if(game.input.upKey(false)) target.y -= game.renderer.height;
        } else
        {
          if(game.input.rightKey(true)) target.x += 8;
          if(game.input.leftKey(true)) target.x -= 8;
          if(game.input.downKey(true)) target.y += 8;
          if(game.input.upKey(true)) target.y -= 8;
        }
      }
      boundTarget();
     
      floatPos.x = ((floatPos.x*9)+target.x)/10;
      floatPos.y = ((floatPos.y*9)+target.y)/10;
      pos.x = int(floatPos.x+0.45);
      pos.y = int(floatPos.y+0.45); 
    }
  }
}