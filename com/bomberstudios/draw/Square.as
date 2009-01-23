class com.bomberstudios.draw.Square {
  static function draw(where:MovieClip,id:String,width:Number,height:Number,bg_color:Number){
    var s = where.createEmptyMovieClip(id,where.getNextHighestDepth());
    s.beginFill(bg_color,100);
    s.lineTo(width,0);
    s.lineTo(width,height);
    s.lineTo(0,height);
    s.lineTo(0,0);
    s.endFill();
    return s;
  }
}