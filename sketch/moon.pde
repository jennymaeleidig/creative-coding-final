PVector moonCanvasCenter;
PVector moonPos; // relative to center of canvas
float moonAngle; // relative to center of canvas
float moonPathRadius; // radius of the moon's elliptical path
boolean isDraggingMoon = false; // To track if the moon is being dragged
float moonRadius; //radius of the moon image for click detection
float minMoonAngle = -3.0295637; // The minimum angle for the moon's path (top-left quadrant)
float maxMoonAngle = -0.20374468; // The maximum angle for the moon's path (top-left quadrant)
float moonScale = 0.55; // Scale factor for the moon image
PImage moonTexture;

void initMoon() {
  //moon initial position and path setup
  moonTexture = loadImage("moon.png");
  pushMatrix();
  translate(width / 2, height / 2);
  moonCanvasCenter = new PVector(0, 0);
  moonPos = new PVector(-400, -45); // relative to center of canvas, places in top-left quadrant
  moonAngle = atan2(moonPos.y - moonCanvasCenter.y, moonPos.x - moonCanvasCenter.x); // angle from center to moon
  moonPathRadius = dist(moonCanvasCenter.x, moonCanvasCenter.y, moonPos.x, moonPos.y); // radius of the moon's elliptical path from center
  moonRadius = moonTexture.width / 2; // radius is half the width
  popMatrix();
}

void drawMoon() {
  // Draw moon
  pushMatrix();
  translate(width / 2, height / 2);
  scale(moonScale);
  imageMode(CENTER);
  //find the point based on the angle
  //adapted from https://stackoverflow.com/questions/34842502/processing-how-do-i-make-an-object-move-in-a-circular-path
  moonPos.x = moonCanvasCenter.x + cos(moonAngle) * moonPathRadius;
  moonPos.y = moonCanvasCenter.y + sin(moonAngle) * moonPathRadius;
  image(moonTexture, moonPos.x, moonPos.y);
  //increment the angle for next frame only if not dragging
  if (!isDraggingMoon) {
    // Sync moon angle with music position, this needs to be the global position across all tracks
    moonAngle = map(getCurrentGlobalPosition(), minTrackPos, maxTrackPos, minMoonAngle, maxMoonAngle);
  }
  imageMode(CORNER);
  popMatrix();
}

void mousePressed() {
  // Calculate moon's actual position on the canvas
  float moonCanvasX = width / 2 + moonPos.x * moonScale;
  float moonCanvasY = height / 2 + moonPos.y * moonScale;

  // Check if mouse is over the moon
  if (dist(mouseX, mouseY, moonCanvasX, moonCanvasY) < moonRadius * moonScale) { // Adjust moonRadius by scale factor
    isDraggingMoon = true;
  }
}

void mouseDragged() {
  if (isDraggingMoon) {
    // Calculate mouse position relative to the center of the canvas
    float mouseRelX = mouseX - width / 2;
    float mouseRelY = mouseY - height / 2;

    // Adjust for the moon's scale factor when calculating the angle
    float scaledMouseRelX = mouseRelX / moonScale;
    float scaledMouseRelY = mouseRelY / moonScale;

    // Only update moonAngle if mouse is above the center (top of circle)
    float proposedAngle = atan2(scaledMouseRelY, scaledMouseRelX);
    if (scaledMouseRelY < 0) {
      moonAngle = constrain(proposedAngle, minMoonAngle, maxMoonAngle);
    }

    // Otherwise, keep moonAngle at min or max if already at the edge
    // (no update needed, so moon stays at edge)
  }
}

void mouseReleased() {
  isDraggingMoon = false;
  // Sync music position to moon angle
  int seekPosition = int(map(moonAngle, minMoonAngle, maxMoonAngle, minTrackPos, maxTrackPos));
  seek(seekPosition);
}
