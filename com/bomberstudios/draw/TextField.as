import net.iwannagothere.Colors;

class com.bomberstudios.draw.TextField {
  static function create(where,id,x,y,w,h){
    var tf = where.createTextField(id,where.getNextHighestDepth(), x, y, w, h);
    var text_format = new TextFormat();
    text_format.font = "Arial";
    text_format.size = 12;
    text_format.color = Colors.grey_light;
    tf.setNewTextFormat(text_format);
    tf.wordWrap = true;
    tf.multiline = true;
    tf.autoSize = true;
    tf.selectable = false;
    tf.html = true;
    return tf;
  }
}