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
Building building                   = new Building( 0, 0, #ffffff, "ally" );
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
void setup() {
  frameRate( 60 );
  size( 1400, 750 );
  noStroke( );
  rectMode( CENTER );
  imageMode( CENTER );

  bobi        = loadImage( "bobi.png" );
  gron        = loadImage( "gron.png" );
  bobiHouse   = loadImage( "bobi-house.png" );
  gronHut     = loadImage( "gron-hut.png" );

  for( int i = 0; i < 3; i++) {
    enemyBuildings.add( new ArcherHut( int( random( width/2, width) ), int( random( 25, height - 25 ) ), #A01C1C, "enemy" ) );
  }

  buildings.add( new ArcherHut( width/2-400, height/2, #e4ba61, "ally" ));
}
 
void draw() {
  // Check if enemy has any buildings left
  if( enemyBuildings.size() == 0 ) {
    background(0);
    textSize(40);
    textAlign( CENTER );
    fill(255);
    text("WINNER!", width/2, height/2);
    return;
  }
  // Check if player has any buildings left
  if( buildings.size() == 0 ) {
    background(0);
    textSize(40);
    textAlign( CENTER );
    fill(255);
    text("GAME OVER", width/2, height/2);
    return;
  }
  background(#418e4a);
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
  // Loop through characters and set a new desired location to wander to
  for( int i = 0; i < characters.size(); i++ ) {
    characters.get(i).SetDesiredLocation();
    characters.get(i).Wander();
  }

  // Loop through enemyies and set a new desired location to wander to
  for( int i = 0; i < enemies.size(); i++ ) {
    enemies.get(i).SetDesiredLocation();
    enemies.get(i).Wander();
  }

  // Enemy interaction
  // Loops through characters and buildings and checks if any are in range
  for( int i = 0; i < characters.size(); i++ ) {
    characters.get(i).CheckForEnemies( enemies, enemyBuildings, arrows );
  }
  // Loops through enemies and buildings and checks if any are in range
  for( int i = 0; i < enemies.size(); i++ ) {
    enemies.get(i).CheckForEnemies( characters, buildings, arrows );
  }

  // Arrows
  // Move arrows
  for( int i = 0; i < arrows.size(); i++ ) {
    arrows.get(i).Fly();
    arrows.get(i).DrawArrow();
  }

  // Chracters
  // Check if any bullets are hitting the character and remove all characters with 0 or less HP
  for( int i = 0; i < characters.size(); i++ ) {
    characters.get(i).CheckCollisionWith( arrows, characters ); 
    characters.get(i).RemoveDeadCharacters( i, characters );
  }
  // Check if any bullets are hitting the enemies and remove all enemies with 0 or less HP
  for( int i = 0; i < enemies.size(); i++ ) {
    enemies.get(i).CheckCollisionWith( arrows, enemies );
    enemies.get(i).RemoveDeadCharacters( i, enemies );
  }

  // Building destruction
  // Check if bullets are hitting ally buildings and remove ones with 0 or less HP
  for( int i = 0; i < buildings.size(); i++ ) {
    buildings.get(i).CheckCollisionWith( arrows, buildings );
    buildings.get(i).RemoveBrokenBuildings( i, buildings );
  }
  // Check if bullets are hitting enemy buildings and remove ones with 0 or less HP
  for( int i = 0; i < enemyBuildings.size(); i++ ) {
    enemyBuildings.get(i).CheckCollisionWith( arrows, enemyBuildings );
    enemyBuildings.get(i).RemoveBrokenBuildings( i, enemyBuildings );
  }

  // archerHutButton.drawButton();
  // warriorHutButton.drawButton();
}
 
void mouseClicked() {
  // if( archerHutButton.mouseOverButton() ) { currentBuildingType = "archerHut"; }
  // if( warriorHutButton.mouseOverButton() ) { currentBuildingType = "warriorHut"; }
  
  // if( !archerHutButton.mouseOverButton() && !warriorHutButton.mouseOverButton() ) {
    building.createBuildingWith( playerResources, buildings );
  // }
}
