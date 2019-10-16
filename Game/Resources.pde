class Resources {
  int gold;
  int goldPerSecond = 1;
  
  // Constructor
  Resources ()  {
    gold = 10;
  }
  // Increase gold
  void increaseGoldBy( int amount ) {
    gold += amount;
  }
  // decrease gold
  void decreaseGoldBy( int amount ) {
    gold -= amount;
  }
  
  // Setup income for the player
  void trackIncome () {
    if( frameCount % 60 == 0 ){
      increaseGoldBy( goldPerSecond );
    }
  }
  
  // Display
  void displayResources() {
    textSize(20);
    fill(#CE9C6F);
    text("Gold: " + gold, 10, 30);
  }

  // display population
  void displayPopulation( ArrayList<Character> characters ) {
    textSize(20);
    fill(#CE9C6F);
    // text("Population: " + characters.size(), 10, 55);
  }

  // display building type (HELPER)
  void displayBuildingType( String buildingType ) {
    textSize(20);
    fill(#CE9C6F);
    // text("Building: " + buildingType, 10, 80);
  }

  
}
