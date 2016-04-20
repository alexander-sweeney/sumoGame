// Physics implemented using the BoxWrap2D processing wrapper
// for jBox2d. Some information is out-of-date somewhere so
// the source code for the library and wrapper were both great
// help. Custom renderer was written using the processing wiki
// page on the library and the source code of the default renderer.

public class Wrestling {
	// Game variables
	int p1score, p2score, round, startX, startY, sumoRadius;
	float ringX, ringY, radius = 222;
	boolean running;
	PApplet sketch;
	Physics physics;
	org.jbox2d.dynamics.Body sumoOne, sumoTwo;
	
	// player1 and player2 are the PImages for each player
	// player 1 is coloured blue, player 2 is coloured red
	
	public Wrestling(PApplet sketch) {
		this.sketch = sketch;
		p1score = 0;
		p2score = 0;
		startX = 100;
		startY = 500;
		sumoRadius = 30;
		round = 0;
		
		ringX = width / 2;
		running = false;
	}
	
	/*
	 * Must be called before starting a new game
	 * Initialises the physics world and other reset things
	 */
	public void startUp() {
  		if (running) return;
		physics = new Physics(	sketch,		// current sketch
					width,		// screen width
					height,		// screen height
					0,		// gravity X
					0,		// gravity Y
					width + 50,	// width of physics world - should be significantly bigger than needed
					height + 50,	// height of physics world
					width + 20,	// bordered area width
					height + 20,	// bordered area height
					10);		// pixels per meter - 10 is the default
		
		// Create sumo physics objects
		physics.setDensity(1.0);
		sumoOne = physics.createCircle(startX, startY, sumoRadius);		// X position, Y position, radius
		sumoTwo = physics.createCircle(width-startX, startY, sumoRadius);
		sumoOne.setLinearDamping(2.0);					// Sets "air" resistance
		sumoTwo.setLinearDamping(2.0);
		sumoOne.setAngularDamping(2.0);					// Sets spin resistance
		sumoTwo.setAngularDamping(2.0);
		
		physics.setCustomRenderingMethod(this, "renderSumos");
		
		running = true;
	}
	
	
	 // Destroy the physics object, etc
	 
	public void shutDown() {
		if (!running) return;
		
		physics.destroy();
		
		running = false;
	}
	
	public void sumoDraw() {
		ringY = 1210 + yPos;

		updateMovement();
		checkPositions();
		
		
	}
	
	// Reset the sumos to their original state
	public void newRound() {
		sumoOne.setXForm(physics.screenToWorld(startX, startY), 0);
		sumoTwo.setXForm(physics.screenToWorld(width - startX, startY), PI);
		sumoOne.setLinearVelocity(new Vec2(0,0));
		sumoTwo.setLinearVelocity(new Vec2(0,0));
		sumoOne.setAngularVelocity(0);
		sumoTwo.setAngularVelocity(0);
	}
	
	public void endRound(int winner) {
		// display winner
		UI.setDisplayText("Player " + winner + " won the round!", 70);
		
		if(winner == 1) p1score++;
		else p2score++;
		
		// If game is won
		if(p1score == 4) {
			UI.setDisplayText("Player 1 won the game!", 120);
			this.resetGame();
		}
		
		else if(p2score == 4) {
			UI.setDisplayText("Player 2 won the game!", 120);
			this.resetGame();
		}
	
	
		else {
			this.newRound();
		}
	}
	
	public void resetGame() {
		p1score = 0;
		p2score = 0;
		delay(100);
		this.newRound();
	}
	
	// Update movement of sumos depending on current keystates
	void updateMovement() {
		if (keyUp) {
			moveSumo(sumoTwo, 1);
		}
		if (keyDown) {
			moveSumo(sumoTwo, -1);
		}
		if (keyLeft) {
			turnSumo(sumoTwo, 1);
		}
		if (keyRight) {
			turnSumo(sumoTwo, -1);
		}
		if (keyW) {
			moveSumo(sumoOne, 1);
		}
		if (keyS) {
			moveSumo(sumoOne, -1);
		}
		if (keyA) {
			turnSumo(sumoOne, 1);
		}
		if (keyD) {
			turnSumo(sumoOne, -1);
		}
	}
	
	// Check if either sumo is out of the ring, and if so, end the round
	void checkPositions() {
		Vec2 position = physics.worldToScreen(sumoOne.getWorldCenter());
		if (distanceFrom(position.x, position.y, ringX, ringY) > radius-sumoRadius/4) {		// -sumoRadius/4 is just to make the outline "more strict" - it can be changed or removed
			endRound(2);
		} else {
			position = physics.worldToScreen(sumoTwo.getWorldCenter());
			if (distanceFrom(position.x, position.y, ringX, ringY) > radius-sumoRadius/4) {
				endRound(1);
			}
		}
	}
	
	// Simple pythagoras to get teh distance between two points
	public float distanceFrom(float x1, float y1, float x2, float y2) {
		return sqrt(sq(x2 - x1) + sq(y2 - y1));
	}
	
	// Apply a linear force to the sumo physics object
	void moveSumo(Body sumo, int dir) {
		//int amplitude = (dir > 0 ? 800 : 600);	// Goes backwards slower than it does forwards
		int amplitude = 800;
		float angle = sumo.getAngle();
		Vec2 force = new Vec2(cos(angle) * amplitude * dir, sin(angle) * amplitude * dir);
		sumo.applyForce(force, sumo.getPosition());
	}
	
	// Apply spin to the sumo physics object
	void turnSumo(Body sumo, int dir) {
		if (sumo.getAngularVelocity() >= TWO_PI || sumo.getAngularVelocity() <= -TWO_PI ) return;
		int torque = dir * 600;
		sumo.applyTorque(torque);
	}
	
	/*
	 * Custom renderer for the sumos
	 * I'm not sure if it is possible to rotate a PImage, so
	 * I have shown coloured balls behind the sumo and an
	 * arrow pointing where it is facing.
	 */
	public void renderSumos(World w) {
		for (Body body = game.physics.getWorld().getBodyList(); body != null; body = body.getNext()) {
			org.jbox2d.collision.Shape shape;
			for (shape = body.getShapeList(); shape != null; shape = shape.getNext()) {
				beginShape();
				if (shape.getType() == ShapeType.CIRCLE_SHAPE) {
					//Cast shape to CircleShape
					CircleShape circle = (CircleShape) shape;
					//Get sumo data
					Vec2 position = physics.worldToScreen(body.getWorldPoint(circle.getLocalPosition()));
					float angle = body.getAngle();
					float diameter = physics.worldToScreen(circle.getRadius()) * 2;
					ellipseMode(CENTER);
					if (body == sumoOne) {
						noStroke();
						fill(#0000FF,75);	// Feek free to remove the opacity for an fps boost
						ellipse(position.x, position.y, diameter, diameter);
						stroke(0);
						strokeWeight(5);
						line(position.x, position.y, position.x+cos(angle)*sumoRadius, position.y-sin(angle)*sumoRadius);
						image(player1, position.x-sumoRadius, position.y-sumoRadius+10);
					} else {
						noStroke();
						fill(#FF0000,75);
						ellipse(position.x, position.y, diameter, diameter);
						stroke(0);
						strokeWeight(5);
						line(position.x, position.y, position.x+cos(angle)*sumoRadius, position.y-sin(angle)*sumoRadius);
						image(player2, position.x-sumoRadius, position.y-sumoRadius+10);
					}
				}
				endShape();
			}
		}
	}
}
