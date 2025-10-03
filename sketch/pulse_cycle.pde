PImage pulseTexture;
PShader cycleShader;
PImage pulsePaletteTexture;

void initPulseCycle() {
  pulseTexture = loadImage("pulse.png");
  pulsePaletteTexture = loadImage("pulse_palette.png");
  cycleShader = loadShader("data/palette_cycle.glsl");
}

void drawPulseCycle() {

  // Apply shader directly with opacity uniform

  // Create a continuously advancing time that's synced with particles but offset
  // Control the animation speed with a multiplier
  float speedMultiplier = PI/3; // 1.0 is default, >1 is faster, <1 is slower
  float phaseOffset = PI/3; // 30 degrees ahead of particles animation
  float basePhase = map(moonAngle, minMoonAngle, maxMoonAngle, minTrackPos, maxTrackPos) * 0.002 * speedMultiplier;

  // Convert the phase to a continuously increasing sawtooth wave (0 to 10)
  // This ensures the animation always moves forward and cycles properly
  float continuousPhase = (basePhase + phaseOffset) / TWO_PI; // normalize to cycles
  float shaderTime = (continuousPhase * 10.0) % 10.0; // scale to palette width and wrap

  translate(width/2, height/2);
  imageMode(CENTER);
  shader(cycleShader);
  cycleShader.set("u_base", pulseTexture);
  cycleShader.set("u_palette", pulsePaletteTexture);
  cycleShader.set("u_time", (float)(shaderTime)); // Simple linear time
  // u_cycle_speed is no longer used to control speed, as it's handled by speedMultiplier
  cycleShader.set("u_palette_width", (float)(10.0));
  cycleShader.set("u_opacity", (float)(0.35)); // 35% opacity uniform
  image(pulseTexture, 4.5, -79.5);
  resetShader();
  translate(-width/2, -height/2);
}
