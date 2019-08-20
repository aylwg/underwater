class Button {
  Boolean isImage;
  Boolean hover = false;
  color buttonColor, buttonHighlight, textColor;
  float size = 30;
  int buttonX, buttonY, buttonWidth, buttonHeight;
  PImage img;
  String text;
  
  Button(String text, int buttonX, int buttonY, int buttonWidth, int buttonHeight) {
    buttonColor = color(#F172A1);
    buttonHighlight = color(#E64398);
    textColor = color(#F0EBF4);
    isImage = false;
    this.text = text;
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
  }
  
  Button(String text, int size, int buttonX, int buttonY, int buttonWidth, int buttonHeight) {
    buttonColor = color(#F172A1);
    buttonHighlight = color(#E64398);
    textColor = color(#F0EBF4);
    isImage = false;
    this.text = text;
    this.size = size;
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
  }
  
  Button(PImage img, Boolean isImage, int buttonX, int buttonY, int buttonWidth, int buttonHeight) {
    this.img = img;
    this.isImage = isImage;
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;    
  }
  
  boolean overButton(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
  void update(int x, int y) {
    if (overButton(buttonX, buttonY, buttonWidth, buttonHeight) ) {
      hover = true;
    } else {
      hover = false;
    }
  }
  
  void display() {
    update(mouseX, mouseY);
    if (hover) {
      fill(buttonHighlight);
    } else {
      fill(buttonColor);
    }
    if (isImage) {
      image(img, buttonX, buttonY);
      img.resize(buttonWidth, buttonHeight);
    } else {
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 8);
    noStroke();
    fill(textColor);
    float textWidth = textWidth(text);
    textSize(size);
    text(text, buttonX + buttonWidth/2 - textWidth/2, buttonY + buttonHeight/2 + size/2);
    }
  }
}
