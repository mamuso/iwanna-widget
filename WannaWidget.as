import com.bomberstudios.utils.Delegate;
import com.bomberstudios.draw.Square;
import com.bomberstudios.draw.Gradient;
import com.bomberstudios.draw.TextField;
import net.iwannagothere.xml.Loader;
import net.iwannagothere.Colors;

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
    Gradient.draw(_timeline,"top_bar",Stage.width,40,Colors.grey_light,Colors.grey_dark);
    var logo = _timeline.attachMovie("logo_full","logo",100);
    // show preloader
    Stage.addListener(this);
  }
  function setup_xml() {
    // Get the XML path from the SWF path
    var swf_path = _timeline._url;
    if(swf_path.indexOf("swf") != 1){
      var xml_path = swf_path.split("swf")[0] + "xml" + swf_path.split("swf")[1];
      xml_loader = new Loader(xml_path,Delegate.create(this,on_data_ready));
      xml_loader.load();
    } else {
      _timeline.username.htmlText = "Error cargando!";
    }
  }
  function on_data_ready(success:Boolean){
    // Text styles
    var txt_title = new TextFormat();
    txt_title.size = 15;
    txt_title.color = Colors.green_dark;
    var txt_body = new TextFormat();
    txt_body.size = 12;
    txt_body.color = Colors.grey_dark;

    // Show user name
    var username_tf = TextField.create(_timeline,"username",10,50,Stage.width-20,20);
    username_tf.setNewTextFormat(txt_title);
    if (!success) {
      username_tf.htmlText = "<b>There was a problem loading data...</b>";
      return;
    } else {
      username_tf.htmlText = "<b>" + link_to(xml_loader.give_me("feed").attributes.username,xml_loader.give_me("feed").attributes.url) + "</b> activity:";
    }

    // Last added
    var last_added = xml_loader.give_me("last_added").childNodes;
    var last_added_links = new Array();
    for(var i=0; i < last_added.length; i++){
      last_added_links.push(link_to(last_added[i].attributes.name,last_added[i].attributes.url)); // TODO: truncate name
    }
    var last_added_tf = TextField.create(_timeline,"last_added",10, username_tf._y + username_tf._height + 10, Stage.width - 20, 50);
    last_added_tf.setNewTextFormat(txt_title);
    last_added_tf.htmlText = "<b>Last added:</b><br>";
    last_added_tf.setNewTextFormat(txt_body);
    last_added_tf.htmlText += last_added_links.join(", ");

    // Visited
    var visited = xml_loader.give_me("visited").childNodes;
    var visited_links = new Array();
    for(var v=0; v < visited.length; v++){
      visited_links.push(link_to(visited[v].attributes.name,visited[v].attributes.url));
    }
    var visited_tf = TextField.create(_timeline,"visited",10,last_added_tf._y + last_added_tf._height + 10,Stage.width - 20,50);
    visited_tf.setNewTextFormat(txt_title);
    visited_tf.htmlText = "<b>Visited:</b><br>";
    visited_tf.setNewTextFormat(txt_body);
    visited_tf.htmlText += visited_links.join(", ");

    // Wannago
    var wannago = xml_loader.give_me("wannago").childNodes;
    var wannago_links = new Array();
    for(var w=0; w < wannago.length; w++){
      wannago_links.push(link_to(wannago[w].attributes.name,wannago[w].attributes.url));
    }
    var wannago_tf = TextField.create(_timeline,"wannago", 10, visited_tf._y + visited_tf._height + 10, Stage.width - 20, 50);
    wannago_tf.setNewTextFormat(txt_title);
    wannago_tf.htmlText = "<b>Wants to go to...</b><br>";
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
    var app:WannaWidget = new WannaWidget(tl);
  }
}