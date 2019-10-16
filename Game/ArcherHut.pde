class ArcherHut extends Building {

    // Inherit and add the type
    ArcherHut( float _xPosition, float _yPosition, color _buildingColor, String _team ) {
        super( _xPosition, _yPosition, _buildingColor, _team );
        type = "archerHut";
    }

}