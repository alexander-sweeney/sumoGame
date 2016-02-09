# sumoGame
A sumo game created with Processing.

This is a simple sumo wrestling game. The aim of the game is to put the opponent outside of the dohyō (sumo ring). This is a 2-player game, using the arrows for player 2 and the WASD keys for player 1.

I created the whole UI and background graphics/character design with Photoshop, and integrated all of this with Processing in a dynamic way — with the menu, the elastic transition to go from menu to game, the 'japanese sun', the sky, the animated banner, the buttons, and all the functions designed to count points/rounds, show the current score and status and reset it when needed.

I greatly learned on logical structure and classes when working on this project; as you can see the final code is very structured and quite easy to read (in my opinion), and this was an important point given the complexity of the UI (not just different screens, but a single screen sliding with an animation). I managed to make the code very easily editable. I also worked on images implementing, optimisation, and animation.

When creating on the main gameplay mechanics, (namely the sumos, controlling them, etc.), I used a physics library that is featured on the processing website. This was a great learning experience as I have never tried anything physics related before now, and now I know a fair amount about quite a popular one.

One main feature of this sketch is multiple concurrent keypresses. I implemented this by making a boolean variable for each of the control keys (as there were only 8, there wasn't any real point in going with anything else) and for every keyPressed() event, set the corresponding variable to true, and for every keyReleased() event, set it to false.

Unfortunately, I have not yet found out how to make PImages rotate, or if it is even possible, but I have implemented a workaround using arrows - to point the user in the direction their sumo is facing.
