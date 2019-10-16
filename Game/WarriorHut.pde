class WarriorHut extends Building {

    // Inherit and add the type
    WarriorHut( float _xPosition, float _yPosition, color _buildingColor, String _team ) {
        super( _xPosition, _yPosition, _buildingColor, _team );
        type = "warriorHut";
    }

}