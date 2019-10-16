class Warrior extends Character {

  // Inherit and add color and type
  Warrior( float _xPosition, float _yPosition, String _team ) {
    super( _xPosition, _yPosition, _team );
    characterColor = #99c7ce;
    type = "warrior";
  }

}