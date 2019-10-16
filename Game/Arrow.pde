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

    // Cosntructor for Arrow
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

    // Move toward set location
    void Fly() {
        xPosition += cos( angle ) * moveSpeed;
        yPosition += sin( angle ) * moveSpeed;
    }

    // Draw arrow to the screen
    void DrawArrow() {
        fill(255);
        ellipse( xPosition, yPosition, 8, 8);
    }
    

}