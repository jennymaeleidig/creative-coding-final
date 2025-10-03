PImage titleImage;

void initTitle() {
  titleImage = loadImage("title.png");
}

void drawTitle() {
  imageMode(CENTER);
  image(titleImage, 256, 482);
  imageMode(CORNER);
}
