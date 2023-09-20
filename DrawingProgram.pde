import g4p_controls.*;

GButton clearButton;
int brushSize = 4;
int r, g, b, a;
GButton increaseSizeButton;
GButton decreaseSizeButton;
GLabel brushsize;
GLabel clear;
GLabel increase;
GLabel decrease;
GButton saveButton;

boolean isDrawing = false;
PGraphics canvas;
PImage previousState = null;

void setup() {
  a = 255;
  size(1200, 800);
  surface.setTitle("Drawing Window");
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setDisplayFont("Arial", G4P.PLAIN, 20);
  canvas = createGraphics(width, height - 80); // Adjust the canvas height to exclude the GUI area
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  fill(0);
  textSize(20);

  brushsize = new GLabel(this, width - 200, 20, 200, 30);
  brushsize.setText("Brush Size: " + brushSize);
  brushsize.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  clearButton = new GButton(this, 10, 10, 100, 50, "Clear");
  clearButton.addEventHandler(this, "clearCanvas");

  increaseSizeButton = new GButton(this, 120, 10, 100, 50, "Brush +");
  increaseSizeButton.addEventHandler(this, "increaseBrushSize");

  decreaseSizeButton = new GButton(this, 230, 10, 100, 50, "Brush -");
  decreaseSizeButton.addEventHandler(this, "decreaseBrushSize");

  saveButton = new GButton(this, 340, 10, 100, 50, "Save PNG");
  saveButton.addEventHandler(this, "saveDrawing");
}

void draw() {
  // Display the drawing canvas
  image(canvas, 0, 80);
  if (previousState != null) {
    canvas.image(previousState, 0, 0);
  }

  // Update the label text to show the current brush size
  noStroke();
  fill(200);
  rect(0, 0, width, 80);
  fill(225);
  rect(width - 220, 15, 190, 40);
  fill(r, g, b, a);
  rect(width - 220, 50, 190, 10);
  brushsize.setText("Brush Size: " + brushSize);

  // Draw the brush outline only when not drawing
  if (!isDrawing && mouseX >= 0 && mouseX <= width && mouseY >= 80 && mouseY <= height) {
    noFill();
    stroke(200);
    strokeWeight(1);
    ellipse(mouseX, mouseY, brushSize, brushSize);
  }
}

void clearCanvas(GButton source, GEvent event) {
  if (event == GEvent.CLICKED) {
    previousState = canvas.get();
    canvas.beginDraw();
    canvas.background(255); // Clear the drawing canvas
    canvas.endDraw();
  }
}

void keyPressed() {
  if (keyCode == UP && brushSize < 2000) {
    brushSize += 2;
  } else if (keyCode == DOWN && brushSize > 2) {
    brushSize -= 2;
  } else if (keyCode == DELETE) {
    previousState = canvas.get();
    canvas.beginDraw();
    canvas.background(255); // Clear the drawing canvas
    canvas.endDraw();
  }

  // Handle undo with Ctrl+Z (or Command+Z on Mac)
  println("Key Pressed: " + key);
  if (key == 'z' || key == 'Z') {
    if (previousState != null) {
      canvas.image(previousState, 0, 0);
      println("Undo performed.");
    } else {
      println("Nothing to undo.");
    }
  }

  if (key == 'k') {
    r += 5;
    g += 5;
    b += 5;
  } else if (key == 'K') {
    r -= 5;
    g -= 5;
    b -= 5;
  }

  if (key == 'r') {
    r += 5;
  } else if (key == 'b') {
    b += 5;
  } else if (key == 'g') {
    g += 5;
  } else if (key == 'a') {
    a += 5;
  }

  if (key == 'e') {
    r += 5;
    g += 5;
  } else if (key == 'v') {
    b += 5;
    r += 5;
  } else if (key == 'f') {
    g += 5;
    b += 5;
  }

  if (key == 'R' && r >= -1) {
    r -= 5;
  } else if (key == 'B' && b >= -1) {
    b -= 5;
  } else if (key == 'G' && g >= -1) {
    g -= 5;
  } else if (key == 'A' && g >= -1) {
    a -= 5;
  }

  if (key == 'E' && r >= -1 && b >= -1) {
    r -= 5;
    g -= 5;
  } else if (key == 'V' && b >= -1 && g >= -1) {
    b -= 5;
    r -= 5;
  } else if (key == 'F' && g >= -1 && r >= -1) {
    g -= 5;
    b -= 5;
  }

  if (key == 't') {
    r = 0;
  } else if (key == 'n') {
    b = 0;
  } else if (key == 'h') {
    g = 0;
  } else if (key == 's') {
    a = 0;
  }
}

void increaseBrushSize(GButton source, GEvent event) {
  if (event == GEvent.CLICKED) {
    brushSize += 2; // Increase the brush size by 2 units
  }
}

void decreaseBrushSize(GButton source, GEvent event) {
  if (event == GEvent.CLICKED) {
    brushSize -= 2; // Decrease the brush size by 2 units
    // Ensure the brush size doesn't go below a minimum value
    if (brushSize < 2) {
      brushSize = 2;
    }
  }
}

void saveDrawing(GButton source, GEvent event) {
  if (event == GEvent.CLICKED) {
    canvas.save("drawing.png");
    println("Drawing saved as 'drawing.png'");
  }
}

void mousePressed() {
  // Save the current state of the canvas when the mouse is pressed
  previousState = canvas.get();
}

void mouseDragged() {
  if (mouseX >= 0 && mouseX <= width && mouseY >= 80 && mouseY <= height) {
    previousState = canvas.get();
    canvas.beginDraw();
    canvas.stroke(r, g, b, a);
    canvas.strokeWeight(brushSize);
    canvas.line(pmouseX, pmouseY - 80, mouseX, mouseY - 80);
    canvas.endDraw();
  }
}

public void handleButtonEvents(GButton button, GEvent event) {
  if (button == clearButton && event == GEvent.CLICKED) {
    clearCanvas(button, event);
  } else if (button == increaseSizeButton && event == GEvent.CLICKED) {
    increaseBrushSize(button, event);
  } else if (button == decreaseSizeButton && event == GEvent.CLICKED) {
    decreaseBrushSize(button, event);
  } else if (button == saveButton && event == GEvent.CLICKED) {
    saveDrawing(button, event);
  }
}
