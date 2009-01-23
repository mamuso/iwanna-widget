import flash.geom.*

class com.bomberstudios.draw.Gradient {
  static function draw(where:MovieClip,id:String,width:Number,height:Number,from_color:Number,to_color:Number){
    var s = where.createEmptyMovieClip(id,where.getNextHighestDepth());
    var colors = [from_color, to_color];
    var fillType = "linear";
    var alphas = [100,100];
    var ratios = [0, 0xFF];
    var matrix = new Matrix();
    matrix.createGradientBox(width, height, Math.PI * 2.5);
    s.beginGradientFill(fillType, colors, alphas, ratios, matrix);
    s.lineTo(width,0);
    s.lineTo(width,height);
    s.lineTo(0,height);
    s.lineTo(0,0);
    s.endFill();
    return s;
  }
}