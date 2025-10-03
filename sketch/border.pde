void drawBorder() {
  stroke(orange);
  strokeWeight(3);
  line(-1, 1, width+1, 1); // top
  line(1, height-1, width+1, height-1); // bottom
  line(1, -1, 1, height+1); // left
  line(width-1, -1, width-1, height+1); // right
  line(-1, 454, width+1, 454); // top of title bar
}
