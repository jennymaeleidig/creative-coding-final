PImage sandTexture;
PImage sandBGTexture;
PShader gradientShader;

void initSand() {
  sandTexture = loadImage("sand.png");
  sandBGTexture = loadImage("sand_bg.png");
  //shaders
  gradientShader = loadShader("data/animated_gradient.glsl");
}

void drawSand() {
  image(sandBGTexture, 0, 0);
  shader(gradientShader);
  gradientShader.set("u_base", sandTexture);
  gradientShader.set("u_time", map(moonAngle, minMoonAngle, maxMoonAngle, minTrackPos, maxTrackPos) / 500); // use moonAngle as a time variable for continuous animation
  gradientShader.set("color_1", red(lightestOrange)/255.0, green(lightestOrange)/255.0, blue(lightestOrange)/255.0);
  gradientShader.set("color_2", red(darkestOrange)/255.0, green(darkestOrange)/255.0, blue(darkestOrange)/255.0);
  ((PGraphicsOpenGL) g).textureSampling(1); // Disable smoothing for sandTexture (1 = POINT)
  image(sandTexture, 3, 203);
  ((PGraphicsOpenGL) g).textureSampling(2); // Re-enable smoothing for other textures (2 = LINEAR)
  resetShader();
}
