// Physics engine imports
import org.jbox2d.util.nonconvex.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.testbed.*;
import org.jbox2d.collision.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.*;
import org.jbox2d.dynamics.*;

// Key states
boolean keyUp, keyDown, keyLeft, keyRight, keyW, keyS, keyA, keyD;

// Graphics
PImage bgAlpha, bgPlain;
PImage playNormal, playHover, playActive;
PImage menuNormal, menuHover, menuActive;
PImage player1, player2;

PFont bello;

// Classes
Interface UI;
Wrestling game;

float yPos = 0; // Position on the screen

// Set if we're in the menu or the game
// and if we switch between them

boolean goToGame = false, goToMenu = false;
boolean gameScreen = false;

// Text display variables

boolean textDisplayed = false;
String textToDisplay;
int textTime = 0;
int displayTime = 0;

// Easing variables
int time = 0;
float beginning, change;
float duration = 140;	




void setup() {
	size(600, 800);
	smooth();
	background(255);

	frameRate(45);
	
	UI = new Interface();
	game = new Wrestling(this);
	
	bgAlpha = loadImage("sumoRingAlpha.png");
	bgPlain = loadImage("sumoRingPlain.jpg");
	
	// Load buttons
	playNormal = loadImage("buttonPlayNormal.png");
	playHover = loadImage("buttonPlayHover.png");
	playActive = loadImage("buttonPlayActive.png");	
	
	menuNormal = loadImage("buttonMenuNormal.png");
	menuHover = loadImage("buttonMenuHover.png");
	menuActive = loadImage("buttonMenuActive.png");
	
	player1 = loadImage("sumoRed.png");
	player2 = loadImage("sumoBlue.png");
	
	bello = loadFont("BelloPro.vlw");
	textFont(bello, 32);
	textAlign(CENTER);
}

void draw() {
	background(255);
	UI.drawImage(yPos);

	
	if(goToGame) {
		UI.goToGame();
	}
	if(goToMenu)
		UI.goToMenu();
		
	if(textDisplayed && textTime < displayTime) {
		UI.displayText(textToDisplay);
	}

	//if(gameScreen)

	UI.drawButton(playNormal, playHover, playActive, (width/2-(playNormal.width/2)), 400, "goToPlay");
	UI.drawButton(menuNormal, menuHover, menuActive, 80, 790, "goToMenu");
}


// This allows for multiple keypresses at once
// The relevant keys will be set to true if the key is pressed, false if not
void keyPressed() {
	if (key == CODED) {
		switch(keyCode) {
			case(UP):
				keyUp = true;
				break;
			case(DOWN):
				keyDown = true;
				break;
			case(LEFT):
				keyLeft = true;
				break;
			case(RIGHT):
				keyRight = true;
				break;
		}
	} else {
		switch(key) {
			case('w'):
			case('W'):
				keyW = true;
				break;
			case('s'):
			case('S'):
				keyS = true;
				break;
			case('a'):
			case('A'):
				keyA = true;
				break;
			case('d'):
			case('D'):
				keyD = true;
				break;
		}
	}
}

void keyReleased() {
	if (key == CODED) {
		switch(keyCode) {
			case(UP):
				keyUp = false;
				break;
			case(DOWN):
				keyDown = false;
				break;
			case(LEFT):
				keyLeft = false;
				break;
			case(RIGHT):
				keyRight = false;
				break;
		}
	} else {
		switch(key) {
			case('w'):
			case('W'):
				keyW = false;
				break;
			case('s'):
			case('S'):
				keyS = false;
				break;
			case('a'):
			case('A'):
				keyA = false;
				break;
			case('d'):
			case('D'):
				keyD = false;
				break;
		}
	}
}
