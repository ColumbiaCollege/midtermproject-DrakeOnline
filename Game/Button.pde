class Button {
  // Button coordinates
  int bXPos;
  int bYPos;
  
  // Button Height and Width
  int bWidth;
  int bHeight;

  // Button colors
  color bMainColor;
  color bHoverColor;
  
  // Button icon
  String icon;
  color  iconColor;
  int    iconSize;
  
  // Button border coordinates
  int topBorderYPosition;
  int bottomBorderYPosition;
  int rightBorderXPosition;
  int leftBorderXPosition;
  
  // Field if button's been clicked
  boolean clicked = false;
  
  // Constructor
  Button( int _bXPos, int _bYPos, int _bWidth, int _bHeight, color _bMainColor, color _bHoverColor ) {
    // Save the coordinates for the button
    bXPos = _bXPos;
    bYPos = _bYPos;
    
    // Save the width and height
    bWidth  = _bWidth;
    bHeight = _bHeight;
    
    // Save color
    bMainColor  = _bMainColor;
    bHoverColor = _bHoverColor;
    
    // Get the coordinate limits for each button
    topBorderYPosition      = bYPos - bHeight/2;
    bottomBorderYPosition   = bYPos + bHeight/2;
    rightBorderXPosition    = bXPos + bWidth/2;
    leftBorderXPosition     = bXPos - bWidth/2;  
  }

  /*___________________________________________________END OF CONTSTRUCTOR AND CONSTRCUTOR OVERLOADING___________________________________________________ */
  
  // Return if the mouse is over the button based on perimeter coordinates
  boolean mouseOverButton() {
    return ( mouseX >= leftBorderXPosition && mouseX <= rightBorderXPosition ) && ( mouseY <= bottomBorderYPosition && mouseY >= topBorderYPosition );
  }
  
  // For readability purposes
  boolean isClicked() {
    return clicked; 
  }
  
  void drawButton() {
    // Check if mouse if over button, if so, set to hover color
    if( mouseOverButton() || isClicked() ) {
      fill( bHoverColor );
    } else {
      fill( bMainColor );
    }
    
    // Set general shap of button
    rect( bXPos, bYPos, bWidth, bHeight );
  }
  
  // Sets every button in an array's "clicked" variable to false
  void setButtonsToUnclicked ( Button[] buttons ) {
    for( int i = 0; i < buttons.length; i++ ) {
      buttons[i].clicked = false;
    }
  }
}
