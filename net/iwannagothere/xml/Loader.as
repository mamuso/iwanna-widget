import com.bomberstudios.utils.Delegate;

class net.iwannagothere.xml.Loader {
  var _path:String;
  var raw_data:XML;

  function Loader(path:String,callback:Function){
    trace("Created net.iwannagothere.xml.Loader()");
    _path = path;
    raw_data = new XML();
    raw_data.ignoreWhite = true;
    raw_data.onLoad = callback;
  }
  function give_me(node_name){
    if (raw_data.firstChild.nodeName == node_name) {
      return raw_data.firstChild;
    }
    for(var i=raw_data.firstChild.childNodes.length; i>=0; i--){
      if(raw_data.firstChild.childNodes[i].nodeName == node_name){
        return raw_data.firstChild.childNodes[i];
      }
    }
  }
  public function load(){
    raw_data.load(_path);
  }
}
