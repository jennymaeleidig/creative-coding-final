PShader beamShader;

void initBeam() {
  beamShader = loadShader("data/beam.glsl");
}

void drawBeam() {
  // Draw beam shader effect
  noTint();
  translate(width/2, height/2);
  shader(beamShader);
  beamShader.set("u_width", (float)(width/4));
  beamShader.set("u_height", (float)(height/4));
  beamShader.set("u_time", (float)(millis() * 0.001));
  beamShader.set("u_pulse", pulse); // Pass the pulse value to control brightness
  rectMode(CENTER);
  fill(255); // white with full opacity
  noStroke();
  rect(4.5, -200, width/4, height/2.75);
  resetShader();
  rectMode(CORNER);
  translate(-width/2, -height/2);
}
