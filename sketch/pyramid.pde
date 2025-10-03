PGraphics patternGraphics; // Declare a PGraphics object
PImage pyramidTexture;

void initPyramid() {
  // Initialize PGraphics with the desired dimensions and sub renderer for the pyramid pattern
  patternGraphics = createGraphics(width, height, P2D);
  ((PGraphicsOpenGL) patternGraphics).textureSampling(2); //SHAAAAARP!

  // Generate the pattern into the PGraphics object
  pyramidTexture = generatePyramidPattern(patternGraphics);
}

void drawPyramid() {
  //points found by measuring original image and scaling down to 512x512

  // front wall points
  //starting at bottom right then clockwise
  float[][] front = {
    {335, 400},
    {55, 319},
    {245, 155},
    {263, 160}
  };
  // right wall points
  // starting at top right, clockwise
  float[][] right = {
    {272, 156},
    {452, 312},
    {335, 400},
    {263, 160.5}
  };

  stroke(lightOrange);
  strokeWeight(.5);

  fill(black, 150); // semi-transparent for layering effect
  beginShape();
  // draw right wall
  for (int i = 0; i < 4; i++) {
    float x = (right[i][0]);
    float y = (right[i][1]);
    vertex(x, y);
  }
  endShape(CLOSE);

  // apply texture to front facing wall
  noStroke();
  noFill();
  beginShape();
  textureMode(NORMAL);
  texture(pyramidTexture);

  //this is just the shape to apply the texture to
  //starting at bottom right then clockwise
  vertex(front[0][0], front[0][1], 1, .995);
  vertex(front[1][0], front[1][1], 0, .995);
  vertex(front[2][0], front[2][1], .29, -0.0025); //these values x values found by trial and error to ensure proper texture mapping
  vertex(front[3][0], front[3][1], .365, -0.0025);
  endShape(CLOSE);

  //tip()
  fill(lightestOrange);
  noStroke();
  beginShape();
  vertex(262.5, 156.5);
  vertex(250, 153);
  vertex(260.5, 143);
  vertex(270.5, 152.5);
  endShape(CLOSE);

  // draw the smaller inner pyramid with transparency to create depth illusion

  // inner smaller pyramid
  fill(black, 150);

  pushMatrix();
  // draw smaller inner shape
  float scale = 0.65;
  // center of the inner pyramid
  float cx = 276;
  float cy = 280;

  // the effect is to achieve such that give a point (x, y) in the original system,
  // it will be transformed to (x - cx) * scale + cx, (y - cy) * scale + cy in the new system
  translate(cx, cy);
  scale(scale);
  translate(-cx, -cy);

  beginShape();

  // draw front facing wall
  for (int i = 0; i < 4; i++) {
    float x = (front[i][0]);
    float y = (front[i][1]);
    vertex(x, y);
  }

  // draw right wall
  for (int i = 0; i < 2; i++) {
    float x = (right[i][0]);
    float y = (right[i][1]);
    vertex(x, y);
  }
  endShape(CLOSE);

  //tip()
  fill(lightestOrange, 255 * 0.8);
  // fill(lightestOrange);
  noStroke();
  beginShape();
  vertex(262.5, 156.5);
  vertex(250, 153);
  vertex(260.5, 143);
  vertex(270.5, 152.5);
  endShape(CLOSE);


  popMatrix();

  //want to place a solid black shape over the inner pyramid to create the illusion of depth
  fill(black);
  noStroke();
  //inner pyramid right for layering
  //measurements derived from the scaled inner pyramid
  float [][] innerPyramidBorder = {
    {320, 352}, //bottom right
    {388, 300}, //bottom left
    {274, 200} //top
  };
  beginShape();
  for (int i = 0; i < innerPyramidBorder.length; i++) {
    vertex(innerPyramidBorder[i][0], innerPyramidBorder[i][1]);
  }
  endShape(CLOSE);

  //border of inner most right wall
  noFill();
  stroke(lightOrange);
  line(innerPyramidBorder[0][0], innerPyramidBorder[0][1], innerPyramidBorder[1][0], innerPyramidBorder[1][1]);
  line(innerPyramidBorder[1][0], innerPyramidBorder[1][1], innerPyramidBorder[2][0], innerPyramidBorder[2][1]);
}
