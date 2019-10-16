import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Game extends PApplet {

/* 
 * Title:         Tribal Combat
 * Description:   A top-down unit management and combat game
 * Author:        Drake Cummings
 * Date Created:  September 24th, 2019
 * ---------------------------------------------------------
 * Last Updated:  October 7th, 2019
 * Notes:         Everything works! Time to Polish
 */
 
// _____Instantiate Objects_____
// Mechanic Objects
Resources playerResources           = new Resources();
GameManager manager                 = new GameManager();

// Building Objects
Building building                   = new Building( 0, 0, 0xffffffff, "ally" );
ArrayList<Building> buildings       = new ArrayList<Building>();
ArrayList<Building> enemyBuildings  = new ArrayList<Building>();

// Character Objects
ArrayList<Character> characters     = new ArrayList<Character>();
ArrayList<Character> enemies        = new ArrayList<Character>();
ArrayList<Arrow> arrows             = new ArrayList<Arrow>();

// UI
// Button warriorHutButton             = new Button( 60, 750-25, 120, 50, #346295, #779fcb );
// Button archerHutButton              = new Button( 60+120, 750-25, 120, 50, #a0751c, #e4ba61 );
String currentBuildingType          = "archerHut";

// Images
PImage bobi;
PImage gron;
PImage bobiHouse;
PImage gronHut;

// _____Engine Events_____
public void setup() {
  frameRate( 60 );
  
  noStroke( );
  rectMode( CENTER );
  imageMode( CENTER );

  bobi = loadImage( "bobi.png" );
  gron = loadImage( "gron.png" );
  bobiHouse = loadImage( "bobi-house.png" );
  gronHut = loadImage( "gron-hut.png" );

  for( int i = 0; i < 3; i++) {
    enemyBuildings.add( new ArcherHut( PApplet.parseInt( random( width/2, width) ), PApplet.parseInt( random( 25, height - 25 ) ), 0xffA01C1C, "enemy" ) );
  }

  buildings.add( new ArcherHut( width/2-400, height/2, 0xffe4ba61, "ally" ));
}
 
public void draw() {
  if( enemyBuildings.size() == 0 ) {
    background(0);
    textSize(40);
    textAlign( CENTER );
    fill(255);
    text("WINNER!", width/2, height/2);
    return;
  }
  if( buildings.size() == 0 ) {
    background(0);
    textSize(40);
    textAlign( CENTER );
    fill(255);
    text("GAME OVER", width/2, height/2);
    return;
  }
  background(0xff418e4a);
  // Resources
  playerResources.trackIncome();
  playerResources.displayResources();
  playerResources.displayPopulation( characters );
  playerResources.displayBuildingType( currentBuildingType );

  // Building
  building.createUnits( buildings, characters );
  building.createUnits( enemyBuildings, enemies );
  building.drawUnits( characters );
  building.drawUnits( enemies );
  building.drawBuildings( buildings );
  building.drawBuildings( enemyBuildings );

  // Chracters
  for( int i = 0; i < characters.size(); i++ ) {
    characters.get(i).SetDesiredLocation();
    characters.get(i).Wander();
  }

  for( int i = 0; i < enemies.size(); i++ ) {
    enemies.get(i).SetDesiredLocation();
    enemies.get(i).Wander();
  }

  // Enemy interaction
  for( int i = 0; i < characters.size(); i++ ) {
    characters.get(i).CheckForEnemies( enemies, enemyBuildings, arrows );
  }

  for( int i = 0; i < enemies.size(); i++ ) {
    enemies.get(i).CheckForEnemies( characters, buildings, arrows );
  }

  // Arrows
  for( int i = 0; i < arrows.size(); i++ ) {
    arrows.get(i).Fly();
    arrows.get(i).DrawArrow();
  }

  // Chracters
  for( int i = 0; i < characters.size(); i++ ) {
    characters.get(i).CheckCollisionWith( arrows, characters ); 
    characters.get(i).RemoveDeadCharacters( i, characters );
  }

  for( int i = 0; i < enemies.size(); i++ ) {
    enemies.get(i).CheckCollisionWith( arrows, enemies );
    enemies.get(i).RemoveDeadCharacters( i, enemies );
  }

  // Building destruction
  for( int i = 0; i < buildings.size(); i++ ) {
    buildings.get(i).CheckCollisionWith( arrows, buildings );
    buildings.get(i).RemoveBrokenBuildings( i, buildings );
  }
  for( int i = 0; i < enemyBuildings.size(); i++ ) {
    enemyBuildings.get(i).CheckCollisionWith( arrows, enemyBuildings );
    enemyBuildings.get(i).RemoveBrokenBuildings( i, enemyBuildings );
  }

  // archerHutButton.drawButton();
  // warriorHutButton.drawButton();
}
 
public void mouseClicked() {
  // if( archerHutButton.mouseOverButton() ) { currentBuildingType = "archerHut"; }
  // if( warriorHutButton.mouseOverButton() ) { currentBuildingType = "warriorHut"; }
  
  // if( !archerHutButton.mouseOverButton() && !warriorHutButton.mouseOverButton() ) {
    building.createBuildingWith( playerResources, buildings );
  // }
}
class Archer extends Character {

   Archer( float _xPosition, float _yPosition, String _team ) {
    super( _xPosition, _yPosition, _team );
    characterColor = 0xffe4c061;
    type = "archer";
  }

}
class ArcherHut extends Building {

    ArcherHut( float _xPosition, float _yPosition, int _buildingColor, String _team ) {
        super( _xPosition, _yPosition, _buildingColor, _team );
        type = "archerHut";
    }

}
class Arrow {
    // Location of bullet
    float xPosition;
    float yPosition;

    // Location of enemy
    float targetXPosition;
    float targetYPosition;

    // For optimal path to target
    float angle;
    int moveSpeed = 4;

    // Stats
    int damage = 20;

    Arrow( float _xPosition, float _yPosition, float _targetXPosition, float _targetYPosition ) {
        xPosition           = _xPosition;
        yPosition           = _yPosition;
        targetXPosition     = _targetXPosition;
        targetYPosition     = _targetYPosition;
        
        angle = atan2( targetYPosition-yPosition, targetXPosition-xPosition );

        // // Quadrant I
        // if( xPosition > targetXPosition && yPosition < targetYPosition ) { 
        //     rise = 0 - ( targetYPosition - yPosition );
        //     run = targetXPosition - xPosition;
        //     rise /= run;
        //     run = -1;
        // }
        // // Quadrant II
        // else if( xPosition < targetXPosition && yPosition < targetYPosition ) {
        //     rise = ( targetYPosition - yPosition); 
        //     run = targetXPosition - xPosition;
        //     rise /= run;
        //     run = 1;
        // }
        // // Quadrant III
        // else if( xPosition < targetXPosition && yPosition > targetYPosition ) { 
        //     rise = ( targetYPosition - yPosition); 
        //     run = targetXPosition - xPosition;
        //     rise /= run;
        //     run = 1; 
        // }
        // // Quadrant IV
        // else if( xPosition > targetXPosition && yPosition > targetYPosition ) { 
        //     rise = 0 - ( targetYPosition - yPosition); 
        //     run = targetXPosition - xPosition;
        //     rise /= run;
        //     run = -1; 
        // }
    }

    public void Fly() {
        xPosition += cos( angle ) * moveSpeed;
        yPosition += sin( angle ) * moveSpeed;
    }

    public void DrawArrow() {
        fill(255);
        ellipse( xPosition, yPosition, 8, 8);
    }
    

}
class Building {
  // Positioning
  float xPosition; 
  float yPosition;

  // Stats
  int health      = 200;
  int cost        = 10;
  int spawnRate   = 360;
  
  // Spawning
  int frameCreated;

  // Building type
  String type;
  String team;
  int buildingColor;


  Building( float _xPosition, float _yPosition, int _buildingColor, String _team ) {
    xPosition       = _xPosition;
    yPosition       = _yPosition;
    frameCreated    = frameCount;
    buildingColor   = _buildingColor;
    team            = _team;
  }

  public void createBuildingWith( Resources resources, ArrayList<Building> buildings ) {
    if ( enoughResources( resources ) ) {
      resources.decreaseGoldBy( cost );
      if( currentBuildingType == "archerHut" ) { buildings.add( new ArcherHut( mouseX, mouseY, 0xffe4ba61, "ally" ) ); }
    }
  }

  public boolean enoughResources( Resources resources ) {
    return resources.gold >= cost;
  }

  public void drawBuildings ( ArrayList<Building> buildings ) {
    for( int i = 0; i < buildings.size(); i++ ) {
      if( buildings.get(i).team == "ally" ) {
        image( bobiHouse, buildings.get(i).xPosition, buildings.get(i).yPosition );
      } else if( buildings.get(i).team == "enemy" ) {
        image( gronHut, buildings.get(i).xPosition, buildings.get(i).yPosition );
      }
    }
  }

  public void createUnits( ArrayList<Building> buildings, ArrayList<Character> characters ) {
    for( int i = 0; i < buildings.size(); i++ ) {
      if( ( frameCount - buildings.get(i).frameCreated ) % buildings.get(i).spawnRate == 0 
          || frameCount - buildings.get(i).frameCreated == 1 ) {
        if ( buildings.get(i).type == "archerHut" ) { 
          Archer archer = new Archer( buildings.get(i).xPosition, buildings.get(i).yPosition, buildings.get(i).team  );
          characters.add( archer );
        }
      }
    }
  }

  public void drawUnits( ArrayList<Character> characters ) {
    for( int i = 0; i < characters.size(); i++ ) {
      if( characters.get(i).team == "ally" ) {
        bobi.resize(32, 28);
        image( bobi, characters.get(i).xPosition, characters.get(i).yPosition );
      } else if( characters.get(i).team == "enemy" ) {
        image( gron, characters.get(i).xPosition, characters.get(i).yPosition );
      }
    }
  }

  // Redundancy
  public void CheckCollisionWith( ArrayList<Arrow> arrows, ArrayList<Building> buildings ) {
    for( int i = 0; i < arrows.size(); i++ ) {
        if( dist(xPosition, yPosition, arrows.get(i).xPosition, arrows.get(i).yPosition ) < 25 ) {
            TakeDamage( arrows.get(i).damage );
            arrows.remove( i );
        }
    }
  }

  public void TakeDamage( int damage ) {
    health -= damage;
  }

  public void RemoveBrokenBuildings( int buildingIndex, ArrayList<Building> buildings ) {
    if( health <= 0 ) {
      buildings.remove( buildingIndex );
    }
  }

}
class Button {
  // Button coordinates
  int bXPos;
  int bYPos;
  
  // Button Height and Width
  int bWidth;
  int bHeight;

  // Button colors
  int bMainColor;
  int bHoverColor;
  
  // Button icon
  String icon;
  int  iconColor;
  int    iconSize;
  
  // Button border coordinates
  int topBorderYPosition;
  int bottomBorderYPosition;
  int rightBorderXPosition;
  int leftBorderXPosition;
  
  // Field if button's been clicked
  boolean clicked = false;
  
  // Constructor
  Button( int _bXPos, int _bYPos, int _bWidth, int _bHeight, int _bMainColor, int _bHoverColor ) {
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
  public boolean mouseOverButton() {
    return ( mouseX >= leftBorderXPosition && mouseX <= rightBorderXPosition ) && ( mouseY <= bottomBorderYPosition && mouseY >= topBorderYPosition );
  }
  
  // For readability purposes
  public boolean isClicked() {
    return clicked; 
  }
  
  public void drawButton() {
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
  public void setButtonsToUnclicked ( Button[] buttons ) {
    for( int i = 0; i < buttons.length; i++ ) {
      buttons[i].clicked = false;
    }
  }
}
class Character {
  // Positioning
  float xPosition;
  float yPosition;
  float desiredXPosition;
  float desiredYPosition;
  float angleToDestination;
  
  // Stats
  int   health = 100;
  int characterColor;
  String type;
  String team;

  // Spawning
  int frameCreated;
  int moveRate        = 180;
  float moveSpeed     = 0.75f;

  // For interacting with enemies
  int attackDistance  = 200;
  boolean seesEnemy   = false;
  int shootRate       = 60;
  int frameFightStarted;

  Character( float _xPosition, float _yPosition, String _team ) {
    xPosition = _xPosition;
    yPosition = _yPosition;
    frameCreated = frameCount;
    team = _team;
  }

  public void SetDesiredLocation() {
    if ( moveRate == 0 ) { return; }
    if ( ( frameCount - frameCreated) % moveRate == 0 ) {
      desiredXPosition = xPosition + PApplet.parseInt( random( -50, 50 ) );
      desiredYPosition = yPosition + PApplet.parseInt( random( -50, 50 ) );
      angleToDestination = atan2( desiredYPosition-yPosition, desiredXPosition-xPosition );
    }
  }

  public void Wander() {
    if ( abs( xPosition - desiredXPosition ) > 5 ) { 
      xPosition += cos( angleToDestination ) * moveSpeed;
    }
    if ( abs( yPosition - desiredYPosition ) > 5 ) {
      yPosition += sin( angleToDestination ) * moveSpeed;
    }
  }

  public void CheckForEnemies( ArrayList<Character> enemies, ArrayList<Building> enemyBuildings, ArrayList<Arrow> arrows  ) {
    for( int i = 0; i < enemies.size(); i++ ) {
      if( dist( xPosition, yPosition, enemies.get(i).xPosition, enemies.get(i).yPosition ) <= attackDistance ) {
        seesEnemy = true;
        if( type == "archer" && frameCount % shootRate == 0 ) { 
          ShootArrow( enemies, arrows, xPosition, yPosition, enemies.get(i).xPosition, enemies.get(i).yPosition );
          return; 
        }
      }
    }
    for( int i = 0; i < enemyBuildings.size(); i++ ) {
      if( dist( xPosition, yPosition, enemyBuildings.get(i).xPosition, enemyBuildings.get(i).yPosition ) <= attackDistance ) {
        seesEnemy = true;
        if( type == "archer" && frameCount % shootRate == 0 ) { 
          ShootArrow( enemies, arrows, xPosition, yPosition, enemyBuildings.get(i).xPosition, enemyBuildings.get(i).yPosition );
          return; 
        }
      } else {
        seesEnemy = false;
      }
    }

  }

  public void ShootArrow( ArrayList<Character> enemies, ArrayList<Arrow> arrows, float x1, float y1, float x2, float y2 ) {
    Arrow arrow = new Arrow( x1+10, y1-10, x2, y2 );
    arrows.add( arrow );
  }

  public void CheckCollisionWith( ArrayList<Arrow> arrows, ArrayList<Character> characters ) {
    for( int i = 0; i < arrows.size(); i++ ) {
        if( dist(xPosition, yPosition, arrows.get(i).xPosition, arrows.get(i).yPosition ) < 5 ) {
            TakeDamage( arrows.get(i).damage );
            arrows.remove( i );
        }
    }
  }

  public void TakeDamage( int damage ) {
    health -= damage;
  }

  public void RemoveDeadCharacters( int characterIndex, ArrayList<Character> characters ) {
    if( health <= 0 ) {
      characters.remove( characterIndex );
    }
  }

}
class GameManager {

  

}
class Resources {
  int gold;
  int goldPerSecond = 1;
  
  Resources ()  {
    gold = 10;
  }
  
  public void increaseGoldBy( int amount ) {
    gold += amount;
  }
  
  public void decreaseGoldBy( int amount ) {
    gold -= amount;
  }
  
  // Setup income for the player
  public void trackIncome () {
    if( frameCount % 60 == 0 ){
      increaseGoldBy( goldPerSecond );
    }
  }
  
  // Display
  public void displayResources() {
    textSize(20);
    fill(0xffCE9C6F);
    text("Gold: " + gold, 10, 30);
  }

  public void displayPopulation( ArrayList<Character> characters ) {
    textSize(20);
    fill(0xffCE9C6F);
    // text("Population: " + characters.size(), 10, 55);
  }

  public void displayBuildingType( String buildingType ) {
    textSize(20);
    fill(0xffCE9C6F);
    // text("Building: " + buildingType, 10, 80);
  }

  
}
class Warrior extends Character {

   Warrior( float _xPosition, float _yPosition, String _team ) {
    super( _xPosition, _yPosition, _team );
    characterColor = 0xff99c7ce;
    type = "warrior";
  }

}
class WarriorHut extends Building {

    WarriorHut( float _xPosition, float _yPosition, int _buildingColor, String _team ) {
        super( _xPosition, _yPosition, _buildingColor, _team );
        type = "warriorHut";
    }

}
  public void settings() {  size( 1400, 750 ); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
