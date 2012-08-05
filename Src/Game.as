package Src
{
  import mx.core.*;
  import mx.collections.*;
  import mx.containers.*;
  import flash.display.*;
  import flash.geom.*;
  import flash.events.*;
  import flash.text.*;
  import flash.utils.*;
  import flash.ui.Keyboard;
  import Src.FE.*;
  import Src.Entity.*;
  import Src.Gfx.*;
  import Src.Sound.*;
  import Src.Tiles.*;

  public class Game
  {    
    private var IS_FINAL:Boolean = false;

    public static var STATE_GAME:int = 0;
    public static var STATE_EDITING:int = 1;
    public static var STATE_FE:int = 2;
    public static var STATE_PRE:int = 3;
    public static var STATE_POST:int = 4;
    
	public var stage:Stage;

    private var fps:Number=60;
    private var lastTime:int = 0;
    private var fpsText:TextField;

    private var updateTracker:Number = 0;
    private var physTime:Number;

    private var gameState:int = STATE_GAME;

    public var entityManager:EntityManager;
    public var input:Input;
    public var renderer:Renderer;
    public var soundManager:SoundManager;
    public var tileMap:TileMap;
    public var tileEditor:TileEditor;
    public var frontEnd:Frontend;
    public var camera:Camera;

    public var anim:Number=0;

    public var transition:Number=1;

    public var currentLevel:int = -1;

    [Embed(source="../level/Fish1.lev", mimeType="application/octet-stream")]
    public static const Level1Class: Class;
    [Embed(source="../level/Fish2.lev", mimeType="application/octet-stream")]
    public static const Level2Class: Class;
    [Embed(source="../level/Fish3.lev", mimeType="application/octet-stream")]
    public static const Level3Class: Class;
    [Embed(source="../level/Fish4.lev", mimeType="application/octet-stream")]
    public static const Level4Class: Class;
    [Embed(source="../level/Fish5.lev", mimeType="application/octet-stream")]
    public static const Level5Class: Class;
    [Embed(source="../level/Fish6.lev", mimeType="application/octet-stream")]
    public static const Level6Class: Class;
    [Embed(source="../level/Fish7.lev", mimeType="application/octet-stream")]
    public static const Level7Class: Class;
    [Embed(source="../level/Fish8.lev", mimeType="application/octet-stream")]
    public static const Level8Class: Class;


    public function Game()
    {	  
      entityManager = new EntityManager(this, 8);
	  input = new Input(this);
      renderer = new Renderer();	  
      soundManager = new SoundManager();
      tileMap = new TileMap(this);      
      nextLevel();
      frontEnd = new Frontend(this);
      camera = new Camera(this);
    }

    public function init(w:int, h:int, pixelSize:int, targetFps:int, stage:Stage):void
    {
	  this.stage = stage;	  
	  
	  physTime = 1000.0/targetFps;
      renderer.init(w, h, pixelSize);
      soundManager.init();
	  input.init();
      tileEditor = new TileEditor(tileMap);

      gameState = STATE_PRE;
      frontEnd.addScreen(new MainMenu());

      fpsText = new TextField();
      fpsText.textColor = 0xffffffff;
      fpsText.text = "352 fps";

      resetEntities();
	  
	  stage.addEventListener(Event.ENTER_FRAME, enterFrame);
    }

    private function update():void
    {

      anim += 0.03;
      while(anim > 1)
        anim--;

      transition += 0.075;
      if(transition > 1)
        transition = 1;

      camera.update();
      renderer.update();
      if(gameState != STATE_PRE && gameState != STATE_POST)
        entityManager.update();
      if(gameState == STATE_FE)
        frontEnd.update();
      if(gameState == STATE_EDITING)
        tileEditor.update();

      if(gameState == STATE_PRE && (input.anyKey() || input.mousePressed))
      {
        changeState(STATE_GAME);
        resetEntities();
      }
        
      if(!IS_FINAL && input.keyPressedDictionary[Input.KEY_E])
      {
        if(gameState == STATE_GAME)
          changeState(STATE_EDITING);
        else
          changeState(STATE_GAME);
        resetEntities();
      }

      if(!IS_FINAL && input.keyPressedDictionary[Input.KEY_U])
        nextLevel();

      var fish:Fish = entityManager.getFish();
      if(fish && fish.deadTimer > 2)
        resetEntities();
      if(gameState == STATE_GAME && input.keyPressedDictionary[Input.KEY_R])
        resetEntities();
        
      // Update input last, so mouse presses etc. will register first..
      // also note this mode of operation isn't perfect, sometimes input
      // will be lost!        
      input.update(); 
    }

    public function updateStep():void
    {
      transition = 0;
      entityManager.updateStep();  
    }
    
    private function resetEntities():void
    {
      entityManager.reset();      
      tileMap.unbound();
      if(gameState == STATE_GAME)
        tileMap.spawnEntities();

    }

    private function render():void
    {
      renderer.cls();

      renderer.setCamera(camera);
      tileMap.render();
      entityManager.render();
      renderer.setCamera();
      if(gameState == STATE_EDITING)
        tileEditor.render();      
      if(gameState == STATE_FE)
        frontEnd.render();
      if(gameState == STATE_PRE)
        renderer.drawTitle();
      if(gameState == STATE_POST)
        renderer.drawEnd();
		  /*
      renderer.drawFontText("Jonathan Whiting's Basecode",
                            renderer.width/2, 10, true);

      if(!IS_FINAL)
        renderer.backBuffer.draw(fpsText);
	   */
      renderer.flip();
    }

    public function nextLevel():void
    {
      currentLevel++;
      var embed:ByteArray;
      switch(currentLevel)
      {
        case 0: embed = new Level1Class as ByteArray; break;
        case 1: embed = new Level2Class as ByteArray; break;
        case 2: embed = new Level4Class as ByteArray; break;
        case 3: embed = new Level3Class as ByteArray; break;
        case 4: embed = new Level8Class as ByteArray; break;
        case 5: embed = new Level7Class as ByteArray; break;
        case 6: embed = new Level6Class as ByteArray; break;
        default: changeState(STATE_POST); return;
      }      
      tileMap.unpack(embed); 
      resetEntities();
    }

    public function enterFrame(event:Event):void
    {
      var thisTime:int = getTimer();
      fps = (fps*9 + 1000/(thisTime-lastTime))/10;
      updateTracker += thisTime-lastTime;
      lastTime = thisTime;
      if(fpsText)
        fpsText.text = "FPS: "+int(fps);

      while(updateTracker > 0)
      {
        update();
        updateTracker -= physTime;
      }

      if(renderer)
      {
        render();
      }
    }

    public function getState():int
    {
      return gameState;
    }

    public function changeState(state:int):void
    {
      gameState = state;
    }
  }
}