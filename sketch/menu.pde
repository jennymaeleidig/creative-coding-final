PFont vcrFont;
PFont vcrFontJP;

void initMenu() {
  //https://fontstruct.com/fontstructions/show/2738536/vcr-osd-replayed
  vcrFont = createFont("vcr-osd-replayed.otf", 12);
  // Create the Japanese font at a larger base size so Processing includes its glyphs (no smoothing).
  vcrFontJP = createFont("vcr-jp.ttf", 24);
}
void drawMenu() {
  if (!currentTrack.player.isPlaying()) {
    pushStyle();
    pushMatrix();

    //pause indicator
    fill(black);
    stroke(orange);
    strokeWeight(2);
    rect(25, 25, 75, 25);
    fill(orange);
    textSize(12);
    textAlign(CENTER, CENTER);
    textFont(vcrFont, 12);
    text("Paused", 62.5, 37.5);

    //current track
    fill(black);
    stroke(orange);
    strokeWeight(2);
    String trackLabel = "Curr Track:";
    String trackTitle = currentTrack.number + ". " + currentTrack.name;
    int trackTitleWidth = (int)(trackTitle.length() * 10.5); // rough estimate
    int labelWidth = (int)(trackLabel.length() * 10.5); // rough estimate
    rect(25, 75, max(trackTitleWidth, labelWidth), 37.5);
    fill(orange);
    textSize(12);
    textAlign(LEFT, CENTER);
    textFont(vcrFontJP, 12);
    text( trackLabel + "\n" + trackTitle, 35.5, 92.5);

    //controls
    fill(black);
    stroke(orange);
    strokeWeight(2);
    rect(width - 200, 25, 175, 100);
    fill(orange);
    textSize(12);
    textAlign(LEFT, CENTER);
    textFont(vcrFont, 12);
    text("Space: Play/Pause\n\nUp/Down: Volume\n\nDrag Moon: Seek\n\nLeft/Right: Skip", width - 190, 75);

    popMatrix();
    popStyle();
  }
}
