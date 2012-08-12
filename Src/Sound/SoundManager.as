package Src.Sound
{
  import mx.core.*;
  import mx.collections.*;
  import flash.media.*;
  import flash.events.*;

  public class SoundManager
  {
    public static var SOUND_ENABLED:Boolean = false;
    public static var MUSIC_ENABLED:Boolean = false;

    [Embed(source="../../sound/FleeFishFlee.mp3")]
    [Bindable]
    private var mp3Music:Class;
    private var musicSounds:Object;
    private var channel:SoundChannel;
    private var currentTrack:String;

    private var sounds:Object;

    public function SoundManager()
    {
      sounds = new Object()
      musicSounds = new Object();
    }
    
    private function addSynth(name:String, settings:String):void
    {
      var synth:SfxrSynth = new SfxrSynth();
      synth.setSettingsString(settings);
      synth.cacheSound();
      sounds[name] = synth;
    }

    public function init():void
    {
      addSynth("diamond", "0,,0.0774,0.3422,0.4991,0.7188,,,,,,0.556,0.6632,,,,,,1,,,,,0.5");
      addSynth("move", "2,,0.0268,,0.1531,0.27,,,,,,,,0.1743,,,,,0.2,,,0.09,,0.5 ");
      addSynth("death", "3,,0.3916,0.6714,,0.6395,,-0.3224,,,,,,,,,,,1,,,,,0.5");

      // Do music
      musicSounds['test'] = new mp3Music() as SoundAsset;
      playMusic('test');
    }

    public function playSound(sound:String):void
    {
      if(!SOUND_ENABLED)
        return;
        
      if(!sounds.hasOwnProperty(sound))
      {
        trace("Sound '"+sound+"' not found!");
        return;
      }      

      sounds[sound].playCached();
    }

    public function playMusic(track:String):void
    {
      currentTrack = track;
      if(!MUSIC_ENABLED)
        return;
        
      if(!musicSounds.hasOwnProperty(track))
      {
        trace("Music '"+track+"' not found!");
        return;      
      }

      stopMusic();
      channel = musicSounds[currentTrack].play();
      setVol(0.6);
      channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
    }

    public function stopMusic():void
    {
      if(channel)
        channel.stop();
    }

    public function setVol(vol:Number):void
    {
      if(channel)
      {
        var transform:SoundTransform = channel.soundTransform;
        transform.volume = vol;
        channel.soundTransform = transform;
      }
    }

    private function soundCompleteHandler(event:Event):void
    {
      playMusic(currentTrack);
    }
  }
}