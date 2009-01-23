import com.bomberstudios.utils.Delegate;
import com.bomberstudios.draw.Square;
import com.bomberstudios.draw.Gradient;
import com.bomberstudios.draw.TextField;
import net.iwannagothere.xml.Loader;
import net.iwannagothere.Colors;
import com.mab.util.debug;


class WannaWidget {
  var _timeline:MovieClip;
  var xml_loader:Loader;

  function WannaWidget(timeline){
    _timeline = timeline;
    draw_ui();
    setup_xml();
  }
  function draw_ui() {
    Stage.scaleMode = "noScale";
    Stage.align = "TL";
    _timeline.onEnterFrame = function() {
        if(Stage.width!=0){
            delete this.onEnterFrame;
            var degback = this.attachMovie("degback","degback", this.getNextHighestDepth());
            degback._width = Stage.width;
            degback._y = Stage.height - degback._height
            var deg = this.attachMovie("deg","deg", this.getNextHighestDepth());
            deg._width = Stage.width;
            var logo = this.attachMovie("logo_mini","logo",100);
            logo._x = Stage.width - logo._width
            logo._y = Stage.height - logo._height
            // show preloader
            Stage.addListener(this);
        }
    }
  }
  function setup_xml() {
    // Get the XML path from the SWF path
    var swf_path = _timeline._url;
    if(swf_path.indexOf("swf") != 1){
      var xml_path = swf_path.split("swf")[0] + "xml" + swf_path.split("swf")[1];
      xml_loader = new Loader(xml_path,Delegate.create(this,on_data_ready));
/*      xml_loader = new Loader("http://iwannagothere.net/xml/limalimon",Delegate.create(this,on_data_ready));*/
      xml_loader.load();
    } else {
      _timeline.username.htmlText = "Error cargando!";
    }
  }
  function on_data_ready(success:Boolean){
    // Text styles
    var txt_title = new TextFormat();
    txt_title.size = 16;
    txt_title.color = Colors.grey_dark;
    var txt_title_w = new TextFormat();
    txt_title_w.size = 16;
    txt_title_w.color = Colors.white;
    var txt_body = new TextFormat();
    txt_body.size = 12;
    txt_body.color = Colors.grey_dark;

    // Show user name
    var username_tf = TextField.create(_timeline,"username",46,10,Stage.width-20,20);
    username_tf.setNewTextFormat(txt_title_w);
    if (!success) {
      username_tf.htmlText = "<b>There was a problem loading data...</b>";
      return;
    } else {
        
      _timeline.createEmptyMovieClip("avatar", _timeline.getNextHighestDepth()+1000);
      var mclListener:Object = new Object();
      mclListener.onLoadInit = function(target_mc:MovieClip) {
          target_mc._x = 13
          target_mc._y = 8
          target_mc._width = 25
          target_mc._height = 25
      };
      var image_mcl:MovieClipLoader = new MovieClipLoader();
      image_mcl.addListener(mclListener);
      image_mcl.loadClip(xml_loader.give_me("feed").attributes.avatar, _timeline.avatar);
      
      
      username_tf.htmlText = link_to(xml_loader.give_me("feed").attributes.username,xml_loader.give_me("feed").attributes.url) + " activity:";
    }

    // Last added
    var last_added = xml_loader.give_me("last_added").childNodes;
    var last_added_links = new Array();
    for(var i=0; i < last_added.length; i++){
      last_added_links.push("<u><font color=\"#317B9E\">" + link_to(last_added[i].attributes.name,last_added[i].attributes.url) + "</font></u>"); // TODO: truncate name
    }
    var last_added_tf = TextField.create(_timeline,"last_added",10, username_tf._y + username_tf._height + 20, Stage.width - 20, 50);
    last_added_tf.setNewTextFormat(txt_title);
    last_added_tf.htmlText = "Last added:<br>";
    last_added_tf.setNewTextFormat(txt_body);
    last_added_tf.htmlText += last_added_links.join(", ");

    // Visited
    var visited = xml_loader.give_me("visited").childNodes;
    var visited_links = new Array();
    for(var v=0; v < visited.length; v++){
      visited_links.push("<u><font color=\"#317B9E\">" + link_to(visited[v].attributes.name,visited[v].attributes.url) + "</font></u>");
    }
    var visited_tf = TextField.create(_timeline,"visited",10,last_added_tf._y + last_added_tf._height + 10,Stage.width - 20,50);
    visited_tf.setNewTextFormat(txt_title);
    visited_tf.htmlText = "Visited:<br>";
    visited_tf.setNewTextFormat(txt_body);
    visited_tf.htmlText += visited_links.join(", ");

    // Wannago
    var wannago = xml_loader.give_me("wannago").childNodes;
    var wannago_links = new Array();
    for(var w=0; w < wannago.length; w++){
      wannago_links.push("<u><font color=\"#317B9E\">" + link_to(wannago[w].attributes.name,wannago[w].attributes.url) + "</font></u>");
    }
    var wannago_tf = TextField.create(_timeline,"wannago", 10, visited_tf._y + visited_tf._height + 10, Stage.width - 20, 50);
    wannago_tf.setNewTextFormat(txt_title);
    wannago_tf.htmlText = "Wants to go to...<br>";
    wannago_tf.setNewTextFormat(txt_body);
    wannago_tf.htmlText += wannago_links.join(", ");

    resize_background();
  }
  function resize_background(){
    _timeline.top_bar._width = Stage.width;
  }
  function resize_textfields(){
    _timeline.last_added._width = Stage.width - 20;
    _timeline.visited._width = Stage.width - 20;
    _timeline.wannago._width = Stage.width - 20;
  }
  function onResize(){
    resize_textfields();
    resize_background();
    // reposition things on stage when/if it is resized
  }
  private function link_to(txt,url){
    return "<a href='"+url+"'>" + txt + "</a>";
  }
  // Init the whole widget
  static function main(tl:MovieClip){
      /*  DEBUGGER - comentar antes de cualquier versión definitiva :) */
/*      debug.waitForSocketConnection = true;
      debug.initSocket("0.0.0.0");*/
    
    var app:WannaWidget = new WannaWidget(tl);
  }
}