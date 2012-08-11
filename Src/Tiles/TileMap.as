package Src.Tiles
{
  import mx.core.*;
  import mx.collections.*;
  import flash.geom.*
  import flash.net.*;
  import flash.events.*;
  import flash.utils.*;
  import Src.*;
  import Src.Entity.*;
  import Src.Gfx.*;

  public class TileMap
  {  
    private static const OBJ_FISH:int=0;
    private static const OBJ_OCTOPUS:int=1;
    private static const OBJ_STARFISH:int=2;
    private static const OBJ_PUFFERFISH:int=3;
    private static const OBJ_GEM:int=4;
    private static const OBJ_SPONGE:int=5;
    private static const OBJ_SEAWEED:int=6;
    private static const OBJ_CAMLIMITTOPLEFT:int=7;
    private static const OBJ_CAMLIMITBOTTOMRIGHT:int=8;
  
    public static var tileWidth:int=16;
    public static var tileHeight:int=16;
    
    private static var tileSpr:String="walls";
    private static var objSpr:String="objects";    
    
    public static const magic:int=0xface;
    public static const version:int=3;    
    
    public var width:int;
    public var height:int;
    public var cameraBound:Rectangle;
    public var tiles:Array;
    public var sprites:Array;
    
    public var game:Game;
    
    public function TileMap(game:Game)
    {
      reset(15*4,10*4);
      this.game = game;
    }
    
    public function reset(width:int, height:int):void
    {
      this.width = width;
      this.height = height;
      
      sprites = new Array();
      sprites[Tile.T_NONE] = "decoration";
      sprites[Tile.T_WALL] = "walls";
      sprites[Tile.T_ENTITY] = "objects";
      
      tiles = new Array();
      for(var i:int=0; i<width*height; i++)
          tiles.push(new Tile());
    }

    public function unbound():void
    {
      cameraBound = new Rectangle(0, 0, width*tileWidth, height*tileHeight);
    }
    
    public function spawnEntities():void
    {
      for(var i:int=0; i<tiles.length; i++)
      {
        var y:int = i/width;
        var x:int = i-(y*width);
        var p:Point = new Point(x, y);
        if(tiles[i].t != Tile.T_ENTITY)
          continue;
        var entity:Entity = null;
        switch(tiles[i].xFrame)
        {
          case OBJ_FISH:
            entity = new Fish(p);
            break;
          case OBJ_OCTOPUS:
            entity = new Octopus(p);
            break;
          case OBJ_STARFISH:
            entity = new Starfish(p, tiles[i].dir);
            break;
          case OBJ_PUFFERFISH:
            entity = new Pufferfish(p);
            break;
          case OBJ_GEM:
            entity = new Gem(p);
            break;
          case OBJ_SPONGE:
            entity = new Sponge(p);
            break;
          case OBJ_CAMLIMITTOPLEFT:
            cameraBound.left = p.x*tileWidth;
            cameraBound.top = p.y*tileHeight;
            break;
          case OBJ_CAMLIMITBOTTOMRIGHT:
            cameraBound.right = p.x*tileWidth;
            cameraBound.bottom = p.y*tileHeight;
            break;
          case OBJ_SEAWEED:
            entity = new Seaweed(p);
            break;
        }
        if(entity)
        {
          entity.precedence_mod = tiles[i].precedence;
          game.entityManager.push(entity);
        }
      }
    }

    public function render():void
    {
      for(var i:int=0; i<tiles.length; i++)
      {
        var y:int = i/width;
        var x:int = i-(y*width);
        var tile:Tile = getTile(x,y);
        var spr:String = sprites[tile.t];
        if(game.getState() == Game.STATE_EDITING || tiles[i].t != Tile.T_ENTITY)
        {
          game.renderer.drawSprite(spr, x*tileWidth, y*tileHeight, tile.xFrame, tile.yFrame);
          if(tiles[i].t == Tile.T_ENTITY && tiles[i].xFrame == OBJ_STARFISH)
            game.renderer.drawSprite("arrow", x*tileWidth, y*tileHeight, tiles[i].dir, 0);
          if(tiles[i].t == Tile.T_ENTITY)
          {
            for(var j:int=0; j<tiles[i].precedence; j++)
            {
              var rect:Rectangle = new Rectangle(x*tileWidth+j*2+1, y*tileHeight+1, 1, 2);
              game.renderer.drawRect(rect, 0x000000);
            }
          }
        }
      }
    }
    
    private function getIndex(x:int, y:int):int
    {
      while(x < 0) return -1;
      while(x >= width) return -1;
      while(y < 0) return -1;
      while(y >= height) return -1;
      return x+y*width;
    }
    
    public function getIndexFromPos(p:Point):int
    {
      var iTileX:int = p.x / tileWidth;
      var iTileY:int = p.y / tileHeight;
      return getIndex(iTileX, iTileY);
    }
    
    public function getTileFromIndex(i:int):Tile
    {
      if(i==-1)
      {
        var fillTile:Tile = new Tile();
        fillTile.t = Tile.T_WALL;
        return fillTile;
      }
      return tiles[i];
    }    
        
    public function getTile(x:int, y:int):Tile
    {
      return getTileFromIndex(getIndex(x,y));
    }
    
    public function getTileAtPos(p:Point):Tile
    {
      return getTileFromIndex(getIndexFromPos(p));
    }

    public function getXY(i:int):Point
    {
      var y:int = i/width;
      var x:int = i-(y*width);
      return new Point(x,y);
    }
    
    public function setTileByIndex(i:int, tile:Tile):void
    {
      if(i==-1) return;
      tiles[i] = tile.clone();
    }
    
    public function setTile(x:int, y:int, tile:Tile):void
    {
      setTileByIndex(getIndex(x,y), tile);
    }
    
    public function getColAtPos(p:Point):int
    {
      switch(getTileAtPos(p).t)
      {
        case Tile.T_WALL: return CCollider.COL_SOLID;
      }
      return CCollider.COL_NONE;
    }

    public function pack(byteArray:ByteArray):void
    {
      byteArray.writeInt(magic);
      byteArray.writeInt(version); 
      byteArray.writeInt(width);
      byteArray.writeInt(height);
      for(var i:int=0; i<tiles.length; i++)
        tiles[i].addToByteArray(byteArray, TileMap.version);
      byteArray.compress();
    }

    public function unpack(byteArray:ByteArray):void
    {
      byteArray.uncompress();
           
      if(magic != byteArray.readInt())
      {
        trace("Not a game level file!");
        return;
      }
      var version:int = byteArray.readInt();
      var tileVersion:int;
      switch(version)
      {
        case 1: tileVersion = Tile.V_INIT; break;
        case 2: tileVersion = Tile.V_DIRANDPRECEDENCE; break;
        case 3: tileVersion = Tile.V_TWOCAMDIRS; break;
        default: trace('invalid level version!'); return;
      }
      var w:int = byteArray.readInt();
      var h:int = byteArray.readInt();
      reset(w, h);
      for(var i:int=0; i<tiles.length; i++)
        tiles[i].readFromByteArray(byteArray, tileVersion);
    }
  }
}