// asfarijoud 300448284

// Global variables are below
public final ArrayList <Button>importantButtons = new ArrayList<Button>();
public ArrayList <Button>boxesOnScreen = new ArrayList<Button>();
public ArrayList <Picture>imagesOnScreen = new ArrayList<Picture>();

public PImage bg; // background image
public int frameRate;
public boolean saved, notFinished;

public Button exitButton, backButton, pauseButton; 
public GoingHome project; // the game including menus
public GameEvent mainEvent; // stores what event is currently being played
public Status globalStatus; 

void setup() {
  fullScreen();
  noStroke();
  textAlign(CENTER, CENTER);
  frameRate = 40;
  bg = loadImage("going-home-bg-green.png");
  bg.resize(width, height);
  background(bg);
  project = new GoingHome();

  saved = true;
  notFinished = true;

  PFont myFont = createFont("Georgia Italic", 32);
  textFont(myFont); // font for nicer aesthetic, if uncompatible, comment this out

  exitButton = new Button(width/2 - 60, 920, 120, 80, 7, "Quit", color(255), false);
  exitButton.setColour(250, 90, 80, 255);
  exitButton.assignStatus(Status.QUIT);

  backButton = new Button(50, height - 300, 150, 100, 7, "Back", color(255), false);
  backButton.setColour(255, 150, 200, 255);
  backButton.setDraw(false);

  pauseButton = new Button(50, height - 300, 150, 100, 7, "Pause", color(255), false);
  pauseButton.setColour(255, 150, 200, 255);
  pauseButton.assignStatus(Status.PAUSE);
  pauseButton.setDraw(false);

  importantButtons.add(exitButton); 
  importantButtons.add(backButton);
  importantButtons.add(pauseButton);
}

void draw() {
  background(bg);
  // calling status methods below, for methods that need to be called every frame
  if (globalStatus== Status.PLAYING) { 
    mainEvent.playGame();
  } else if (globalStatus == Status.PAUSE) {
    project.paused();
  } else if (globalStatus == Status.SAVING) {
    project.saveGame();
  } else if (globalStatus == Status.TYPING) {
    project.typeName();
  }

  // drawing boxes and images below
  for (Picture i : imagesOnScreen) {
    i.drawPicture();
  }
  for (Button perm : importantButtons) { // boxes that are nearly always on display because they're important
    perm.drawButton();
    if (perm.isTouching(mouseX, mouseY)) {
      perm.changeAlpha(1);
    } else {
      perm.changeAlpha(0);
    }

    if (perm.isTouching(clickedX, clickedY)) {
      if (!(saved && notFinished) && globalStatus == Status.PLAYING) {
        project.saveButton(perm.getStatus(), perm.getEvent());
        globalStatus = Status.SAVING;
        break;
      } else {
        perm.callButton(perm.getStatus());
        break;
      }
    }
  }
  for (Button b : boxesOnScreen) {
    if (b.isTouching(mouseX, mouseY)) {
      b.changeAlpha(1);
    } else {
      b.changeAlpha(0);
    }

    b.drawButton();

    if (b.isTouching(clickedX, clickedY)) {
      if (!(saved && notFinished) && globalStatus == Status.PLAYING) {
        project.saveButton(b.getStatus(), b.getEvent());
        globalStatus = Status.SAVING;
        break;
      } else {
        b.callButton(b.getStatus());
        break;
      }
    }
  }
  // reset clicked values so that it does not affect the next frame
  clickedX = -10;
  clickedY = -10;
}

/** This method returns a random integer between the numbers specified 
/* the range of numbers the method chooses from is defined in the method's parameters */
public int randomise(int min, int max) {
  float random = random(min, max);
  int number = (int)random;
  return number;
}

// mouse listener method and global mouse variable
// variables to store where the last place clicked was
public float clickedX; 
public float clickedY;
void mouseClicked() {
  clickedX = mouseX;
  clickedY = mouseY;
}

// keyboard listener methods here
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && globalStatus == Status.PLAYING) {
      mainEvent.getCharacter().goUp();
    } else if (keyCode == DOWN && globalStatus == Status.PLAYING) {
      mainEvent.getCharacter().goDown();
    }
  }
  if (key == ' ') {
    if (globalStatus == Status.PLAYING) {
      globalStatus = Status.PAUSE;
      mainEvent.drawGame();
    } else if (globalStatus == Status.PAUSE) {
      globalStatus = Status.PLAYING;
      mainEvent.playGame();
    }
  }
}

void keyTyped() {
  // use this for project.saveGame()
  if (globalStatus == Status.TYPING && project.typing) {
    if (key == BACKSPACE) {
      if (project.savedName.length()>0) {
        project.savedName = project.savedName.substring(0, project.savedName.length()-1);
      }
    } else {
      project.savedName += key;
    }
  }
}

/** How statuses are to be used: 
/* "loading" status -> user is choosing what game slot to play at core and completion all slots are empty
/* "choosing" status -> user is choosing what character's game event they want to play
/* "play" status -> user starts to play game event
/* "playing" status -> user is playing game event or continuing to play event
/* "pause" status -> for when game event is stopped temporarily
/* "saving" status -> to save game data
/* "quit" status -> terminates the program */
enum Status {
  LOADING, CHOOSING, PLAY, PLAYING, PAUSE, SAVING, TYPING, QUIT;
}
