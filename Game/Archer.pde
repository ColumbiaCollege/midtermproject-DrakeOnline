class Archer extends Character {

  // Inherit and add type with color
  Archer( float _xPosition, float _yPosition, String _team ) {
    super( _xPosition, _yPosition, _team );
    characterColor = #e4c061;
    type = "archer";
  }

}