# GoingHome
A short 2D game written in 2020 for class.

# Vision:
## Game concept:

The world is falling apart. The oceans are poisoned, the moon has disappeared, and the
sun is lost. Everything is everywhere it shouldn't be. The player must get all the game
characters to their homes safely in time before they die. If the player succeeds, the
world is transformed and the characters survive, but if the player fails, they must “undo”
their mistakes and try to save the character/s again.
## Game play:

Main menu: Player may choose new game or one of the saved games
Goal tab: The controls and goal of the game event are explained to the user as well as
a short backstory to the character.
## Game event:

1) Character
2) Scene objects: so that every event has a new randomised scene
3) Health points: helps achieve the goal of the game event
4) Timer: lets the player know how long they have to win the event.
5) Health: goes down as time goes by, but increases when a health point is earned.
## Visual design:

A 2D side-scroller with flat clean shapes and colours (unpixelated). Full-screen game
window, with a set size of the window used for game events. The colour scheme is cyan
and purple-focused. Black and white are used for interactive screens other than
game-event. Yellow is used for health points to contrast the cyan and purple.
Characters may have up to two main colours that are harmonious with their
backgrounds but contrast enough to be seen as the focal point on screen

## Updates: 

I will not be updating this game. The concept and code will need to be completely redone in order to fix the mistakes made.

Things I identified need to be changed/fixed in my reflection after the end of the project:
- The visual design and story concept in the vision were not followed properly
- Loading and drawing images on GUI
- Constant scene regeneration (drawing every image on screen again as per frame rate)
- Saving game data files
- User ability to save game data
- Gameplay is laggy; feedback is slow making it frustrating to move the game character
- UI is subpar
