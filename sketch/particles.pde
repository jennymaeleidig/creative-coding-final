PImage bloomTexture;
PImage blurredBloom;
PImage particleTexture;

// Global variable for shader animation timing
float pulse = 0;

void initParticles() {
  bloomTexture = loadImage("bloom.png");
  particleTexture = loadImage("particles.png");

  // Pre-blur the bloom texture once for efficiency
  PGraphics tempBuffer = createGraphics(bloomTexture.width, bloomTexture.height);
  tempBuffer.beginDraw();
  tempBuffer.image(bloomTexture, 0, 0);
  tempBuffer.filter(BLUR, 9);
  tempBuffer.endDraw();
  blurredBloom = tempBuffer.get();
}

void drawParticles() {
  imageMode(CENTER);
  translate(264, 122);

  // Create slow pulsing effect using sine wave for both textures
  pulse = (sin(map(moonAngle, minMoonAngle, maxMoonAngle, minTrackPos, maxTrackPos) * 0.001) + 1) * 0.5; // oscillates between 0 and 1, offset by 30 degrees
  pulse = map(pulse, 0, 1, 0.3, 1.0); // remap to range 0.3 to 1.0 for visibility
  // Then draw the bloom texture with BLEND mode and opacity pulsing, 1.5x bigger
  blendMode(BLEND);
  tint(255, 255 * pulse);
  image(blurredBloom, -4, 12, blurredBloom.width * 1.5, blurredBloom.height * 1.5);


  // First draw the particle texture with ADD mode for the background glow ring
  blendMode(ADD);
  tint(255, 255 * pulse);
  image(particleTexture, 0, 0);

  imageMode(CORNER);

  // Reset blend mode and tint
  blendMode(BLEND);
  noTint();
  translate(-264, -122);
}
