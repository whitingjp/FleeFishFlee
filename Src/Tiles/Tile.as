package Src.Tiles
{
  import flash.utils.*;
  public class Tile
  {
    public static const T_NONE:int=0;
    public static const T_WALL:int=1;
    public static const T_ENTITY:int=2;
    public static const T_MAX:int=3;

    public static const V_INIT:int=0;
    public static const V_DIRANDPRECEDENCE:int=1;
    public static const V_TWOCAMDIRS:int=2;
    
    public var t:int;
    public var xFrame:int;
    public var yFrame:int;
    public var dir:int;
    public var precedence:int;
    
    public function Tile()
    {
      t = T_WALL;
      xFrame = 1;
      yFrame = 1;
      dir = 0;
      precedence = -1;
    }
    
    public function clone():Tile
    {
      var ret:Tile = new Tile();
      ret.t = t;
      ret.xFrame = xFrame;
      ret.yFrame = yFrame;
      ret.dir = dir;
      ret.precedence = precedence;
      return ret;
    }
    
    public function addToByteArray(byteArray:ByteArray, version:int):void
    {
      byteArray.writeInt(t);
      byteArray.writeInt(xFrame);
      byteArray.writeInt(yFrame);
      if(version >= V_DIRANDPRECEDENCE)
      {
        byteArray.writeInt(dir);
        byteArray.writeInt(precedence);
      }
    }
    
    public function readFromByteArray(byteArray:ByteArray, version:int):void
    {
      t = byteArray.readInt();
      xFrame = byteArray.readInt();
      yFrame = byteArray.readInt();
      if(version >= V_DIRANDPRECEDENCE)
      {
        dir = byteArray.readInt();
        precedence = byteArray.readInt();
      }
      if(version < V_TWOCAMDIRS && t == T_ENTITY)
      {
        switch(xFrame)
        {
          case 6: xFrame = 8; break; // OBJ_CAMLIMITBOTTOMRIGHT moved from 6-8
          case 7: xFrame = 6; break; // OBJ_SEAWEED moved from 7-6
        }
      }
    }
  }
}