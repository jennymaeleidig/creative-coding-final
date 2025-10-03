enum RowType {
  ODD,
    EVEN
};

class Row {
  int width;
  int height;
  RowType type;
  int offsetX;

  Row(int width, int height, RowType type, int offsetX) {
    this.width = width;
    this.height = height;
    this.type = type;
    this.offsetX = offsetX;
  }

  void drawBox(int x, int y, int rowOffsetX, PGraphics pg) {
    PVector TL = new PVector(x - rowOffsetX, y);
    PVector TR = new PVector(x + width - rowOffsetX, y);
    PVector BL = new PVector(x - this.offsetX - rowOffsetX, y + height);
    PVector BR = new PVector(x + width - this.offsetX - rowOffsetX, y + height);

    // Draw individual lines instead of quad to avoid fill/stroke conflicts
    pg.quad(TL.x, TL.y, TR.x, TR.y, BR.x, BR.y, BL.x, BL.y);
  }
}

PImage generatePyramidPattern(PGraphics pg) {
  Row oddRow = new Row(15, 17, RowType.ODD, -2);
  Row evenRow = new Row(15, 24, RowType.EVEN, 14);
  Row currentRow = oddRow;

  pg.beginDraw(); // Start drawing to the off-screen buffer
  pg.clear();
  pg.fill(black);
  pg.strokeWeight(1);
  pg.stroke(lightOrange); // Simple orange stroke

  int evenRowNum = 0;
  int oddRowNum = 1;
  for (int y = 0; y < height; y += (currentRow.type == RowType.ODD ? evenRow.height : oddRow.height)) {
    int evenRowOffsetX = (evenRowNum * evenRow.offsetX);
    int oddRowOffsetX = (oddRowNum * oddRow.offsetX);
    int rowOffsetX = evenRowOffsetX + oddRowOffsetX;
    for (int x = currentRow.width * 10; x < width + rowOffsetX; x += currentRow.width) {
      currentRow.drawBox(x, y, rowOffsetX, pg);
    }
    // alternate rows
    if (currentRow.type == RowType.ODD) {
      currentRow = evenRow;
      oddRowNum++; //since we start w/ odd rows and alternate, if we have drawn an odd row, we move to the next group
    } else {
      currentRow = oddRow;
      evenRowNum++; //since we start w/ odd rows and alternate, if we have drawn an even row, we move to the next group
    }
  }
  pg.endDraw(); // Finish drawing to the off-screen buffer

  // Get the image
  PImage result = pg.get();
  return result;
}
