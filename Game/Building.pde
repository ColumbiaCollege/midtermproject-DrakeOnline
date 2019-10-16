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
  color buildingColor;

  // Constructor
  Building( float _xPosition, float _yPosition, color _buildingColor, String _team ) {
    xPosition       = _xPosition;
    yPosition       = _yPosition;
    frameCreated    = frameCount;
    buildingColor   = _buildingColor;
    team            = _team;
  }

  // Create a building and reduce the resources
  void createBuildingWith( Resources resources, ArrayList<Building> buildings ) {
    if ( enoughResources( resources ) ) {
      resources.decreaseGoldBy( cost );
      if( currentBuildingType == "archerHut" ) { buildings.add( new ArcherHut( mouseX, mouseY, #e4ba61, "ally" ) ); }
    }
  }

  // Return if player has enough resources
  boolean enoughResources( Resources resources ) {
    return resources.gold >= cost;
  }

  // Draw the buildings to the screen
  void drawBuildings ( ArrayList<Building> buildings ) {
    for( int i = 0; i < buildings.size(); i++ ) {
      if( buildings.get(i).team == "ally" ) {
        image( bobiHouse, buildings.get(i).xPosition, buildings.get(i).yPosition );
      } else if( buildings.get(i).team == "enemy" ) {
        image( gronHut, buildings.get(i).xPosition, buildings.get(i).yPosition );
      }
    }
  }

  // Spawn units from the buildings
  void createUnits( ArrayList<Building> buildings, ArrayList<Character> characters ) {
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

  // Draw spawned units to the screen
  void drawUnits( ArrayList<Character> characters ) {
    for( int i = 0; i < characters.size(); i++ ) {
      if( characters.get(i).team == "ally" ) {
        bobi.resize(32, 28);
        image( bobi, characters.get(i).xPosition, characters.get(i).yPosition );
      } else if( characters.get(i).team == "enemy" ) {
        image( gron, characters.get(i).xPosition, characters.get(i).yPosition );
      }
    }
  }

  // Check if any arrows are hitting buildings
  // Redundancy: Loops twice
  void CheckCollisionWith( ArrayList<Arrow> arrows, ArrayList<Building> buildings ) {
    for( int i = 0; i < arrows.size(); i++ ) {
        if( dist(xPosition, yPosition, arrows.get(i).xPosition, arrows.get(i).yPosition ) < 25 ) {
            TakeDamage( arrows.get(i).damage );
            arrows.remove( i );
        }
    }
  }

  // Reduce health by a given amount
  void TakeDamage( int damage ) {
    health -= damage;
  }

  // Remove buildings from an array if their health is 0 or less
  void RemoveBrokenBuildings( int buildingIndex, ArrayList<Building> buildings ) {
    if( health <= 0 ) {
      buildings.remove( buildingIndex );
    }
  }

}
