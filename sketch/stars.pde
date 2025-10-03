PImage starsTexture;
float starRotationStart;

void initStars() {
  starsTexture = loadImage("stars.png");
  starRotationStart = random(0, TWO_PI);
}


void drawStars() {
  // Draw stars background
  pushMatrix();
  translate(width / 2, height / 2);
  scale(.7);
  imageMode(CENTER);
  //https://stackoverflow.com/questions/23194442/need-to-rotate-and-move-images-in-processing
  //TODO: could be fun to randomize the starting orientation of the stars each time the sketch is run
  rotate(starRotationStart + radians(moonAngle) * 32);
  image(starsTexture, 0, 0);
  imageMode(CORNER);
  popMatrix();
}
