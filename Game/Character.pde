class Character {
  // Positioning
  float xPosition;
  float yPosition;
  float desiredXPosition;
  float desiredYPosition;
  float angleToDestination;
  
  // Stats
  int   health = 100;
  color characterColor;
  String type;
  String team;

  // Spawning
  int frameCreated;
  int moveRate        = 180;
  float moveSpeed     = 0.75;

  // For interacting with enemies
  int attackDistance  = 200;
  boolean seesEnemy   = false;
  int shootRate       = 60;
  int frameFightStarted;

  // Constructor
  Character( float _xPosition, float _yPosition, String _team ) {
    xPosition = _xPosition;
    yPosition = _yPosition;
    frameCreated = frameCount;
    team = _team;
  }

  // Create a new random location
  void SetDesiredLocation() {
    if ( moveRate == 0 ) { return; }
    if ( ( frameCount - frameCreated) % moveRate == 0 ) {
      desiredXPosition = xPosition + int( random( -50, 50 ) );
      desiredYPosition = yPosition + int( random( -50, 50 ) );
      angleToDestination = atan2( desiredYPosition-yPosition, desiredXPosition-xPosition );
    }
  }

  // Wander toward desiredlocation
  void Wander() {
    if ( abs( xPosition - desiredXPosition ) > 5 ) { 
      xPosition += cos( angleToDestination ) * moveSpeed;
    }
    if ( abs( yPosition - desiredYPosition ) > 5 ) {
      yPosition += sin( angleToDestination ) * moveSpeed;
    }
  }

  // Check if enemies are in range
  void CheckForEnemies( ArrayList<Character> enemies, ArrayList<Building> enemyBuildings, ArrayList<Arrow> arrows  ) {
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

  // Shoot an arrow toward a given location
  void ShootArrow( ArrayList<Character> enemies, ArrayList<Arrow> arrows, float x1, float y1, float x2, float y2 ) {
    Arrow arrow = new Arrow( x1+10, y1-10, x2, y2 );
    arrows.add( arrow );
  }

  // Check if arrows are hitting chracters, if so, remove the arrow and hurt the character
  void CheckCollisionWith( ArrayList<Arrow> arrows, ArrayList<Character> characters ) {
    for( int i = 0; i < arrows.size(); i++ ) {
        if( dist(xPosition, yPosition, arrows.get(i).xPosition, arrows.get(i).yPosition ) < 5 ) {
            TakeDamage( arrows.get(i).damage );
            arrows.remove( i );
        }
    }
  }

  // Reduce health by a certain amount
  void TakeDamage( int damage ) {
    health -= damage;
  }

  // Cycles through character arraylist and removes ones with 0 or less hp
  void RemoveDeadCharacters( int characterIndex, ArrayList<Character> characters ) {
    if( health <= 0 ) {
      characters.remove( characterIndex );
    }
  }

}
