/** this class is to keep track of what's going on on the display */
public class GoingHome {
  public int levelsPlayed, levelsCompleted;
  public String savedName;
  public float highScore;
  public boolean typing;
  private final String[] savePathFiles = {"savefile-1.txt", "savefile-2.txt", "savefile-3.txt", "savefile-4.txt"};
  private String[] allSavedNames = {"", "", "", ""};
  private int numberOfFile;
  private GameEvent ocean, sky, savedEvent;
  private Status savedStatus;

  /** Game constructor starts up a new game and sets up important data */
  public GoingHome() {
    ocean = new GameEvent("ocean");
    sky = new GameEvent("sky");
    levelsPlayed = 0;
    levelsCompleted = 0;
    highScore = 0;

    savedName = "Empty Slot";
    typing = false;

    globalStatus = Status.LOADING;
    loadGame();
  }

  /** User chooses a box with an associated game file
  /* if the game file is not an "empty slot", the game data will be loaded
  /* if the game file is an "empty slot", a new game will be created */
  public void loadGame() {

    boxesOnScreen.clear();
    imagesOnScreen.clear();
    
    if (globalStatus == Status.LOADING) {
      for (int i = 0; i < savePathFiles.length; i++){
        loadGameFile(false, savePathFiles[i], i);
      }
      // load game logo
      Picture title = new Picture("going-home.png", width/2, 100);
      imagesOnScreen.add(title);

      /** if clicked on any of these boxes, take to game choosing
      /* for extension: each box has an associated game txt file
      /* the string written on the box will be written and loaded from the text file */
      boxesOnScreen.add(new Button(width/2-500, 650, 400, 90, 7, allSavedNames[0], color(60, 15, 90), false));
      boxesOnScreen.add(new Button(width/2+100, 650, 400, 90, 7, allSavedNames[1], color(60, 15, 90), false));
      boxesOnScreen.add(new Button(width/2-600, (height/2)+250, 400, 90, 7, allSavedNames[2], color(60, 15, 90), false));
      boxesOnScreen.add(new Button(width/2+200, (height/2)+250, 400, 90, 7, allSavedNames[3], color(60, 15, 90), false));
      
      for (int i = 0; i <  boxesOnScreen.size(); i++) {
        Button b = boxesOnScreen.get(i);
        b.setColour(220, 180, 100, 255);
        b.assignStatus(Status.CHOOSING);
        b.setTextSize(60);
        if (b.isTouching(clickedX, clickedY)) {
          loadGameFile(true, savePathFiles[i], i);
          break;
        }
      }
    }
  }

  public void chooseEvent() {

    boxesOnScreen.clear();
    imagesOnScreen.clear();
    if (globalStatus == Status.CHOOSING) {
      // load feesh for core and scooter for completion
      // text to instruct user to choose a game event
      // if they click on feesh it makes "ocean" the main game event
      Button instructions = new Button(width/2 - 500, 300, 1000, 100, 7, "Please choose a character:", color(50, 40, 60), true);
      instructions.setColour(240, 200, 190, 255);


      Button scooter = new Button(1100, 600, 280, 280, 7, "", color(0), false);
      scooter.setColour(20, 15, 60, 255);
      scooter.setTexture(loadImage("scooter-title.png"));
      scooter.setEvent(sky);
      scooter.assignStatus(Status.PLAY);
      boxesOnScreen.add(scooter);

      Button feesh = new Button(600, 600, 280, 280, 7, "", color(0), false);
      feesh.setColour(20, 15, 60, 255);
      feesh.setTexture(loadImage("feesh-title.png"));
      feesh.setEvent(ocean);
      feesh.assignStatus(Status.PLAY);
      boxesOnScreen.add(feesh);
      // return button to go back to loading menu
      backButton.assignStatus(Status.LOADING);

      boxesOnScreen.add(feesh);
      boxesOnScreen.add(instructions);
    }
  }

  /** Pauses the game event and makes paused game options
  /* return -> stops current game and returns to chooseEvent
  /* continue -> continues playing event */
  public void paused() {
    boxesOnScreen.clear();

    fill(255, 255, 255);
    rect(width/2 - 500, 150, 950, 800);

    Button title = new Button(width/2 - 125, 150, 200, 100, 0, "Paused", color(0), true);
    title.setColour(255, 255, 255, 255);
    boxesOnScreen.add(title);

    Button unpause = new Button(width/2 - 125, 350, 200, 100, 7, "Continue", color(0), false);
    unpause.setColour(255, 100, 100, 255);
    unpause.assignStatus(Status.PLAYING);
    boxesOnScreen.add(unpause);

    Button goBack = new Button(width/2 - 125, 550, 200, 100, 7, "Back", color(0), false);
    goBack.setColour(255, 100, 100, 255);
    goBack.assignStatus(Status.CHOOSING);
    boxesOnScreen.add(goBack);

    Button goMenu = new Button(width/2 - 125, 750, 200, 100, 7, "Main Menu", color(0), false);
    goMenu.setColour(255, 100, 100, 255);
    goMenu.assignStatus(Status.LOADING);
    boxesOnScreen.add(goMenu);
  }

  /** for challenge, make method that uploads levelsPlayed completed and highscore from file
  /* call this method in loadGame() before any of the boxes are drawn, so that the names of the boxes are drawn
  /* call again after one of the buttons is clicked so that data is loaded into game */
  public void loadGameFile (boolean loading, String fileName, int fileNumber) {
    String[] data = loadStrings(fileName);
    String firstSplit = "";

    for (String line : data) {
      firstSplit += line;
    }

    data = split(firstSplit, " ");
    
    if (data[0].equals("SF")) { 

      if (loading) {
        // read data from file and load it into game variables
        String nameInFile = "";
        int state = 0;
        for (String word : data) {
          if (word.equals("")) {
            continue;
          }
          switch (state) {
          case 0:
            state = 1; // skip first word
            break;
          case 1:
            if (word.equals("Name:")) {
              state = 2;
              continue;
            }
            break;
          case 2: 
            if (word.equals("LevelsPlayed:")) {
              savedName = nameInFile;
              println(savedName);
              state = 3;
              continue;
            } else {
              nameInFile += word+" "; // write name
            }
            break;
          case 3:
            if (word.equals("LevelsCompleted:")) {
              state = 4;
              continue;
            } else {
              levelsPlayed = Integer.parseInt(word);
            }
            break;
          case 4: 
            if (word.equals("HighScore:")) {
              state = 5;
              continue;
            } else {
              levelsCompleted = Integer.parseInt(word);
            }
            break;
          case 5: 
            highScore = Float.parseFloat(word);
          }
        }
      } else {
        // read first two lines from file
        // first line verifies that the file is a game file
        // second line loads the name of the saved game
        String nameInFile = "";
        int state = 0;
        for (String word : data) {
          if (word.equals("")) {
            continue;
          }
          switch (state) {
          case 0:
            state = 1; // skip first word
            break;
          case 1:
            if (word.equals("Name:")) {
              state = 2;
              continue;
            }
            break;
          case 2: 
            if (word.equals("LevelsPlayed:")) {
              allSavedNames[fileNumber] = nameInFile;
            } else {
              nameInFile += word+" "; // write name
            }
            break;
          }
        }
      }
    } else {
      throw new IllegalArgumentException("File is invalid: not a saved data file.");
    }
  }

  public void saveButton(Status toBeCalled, GameEvent theEvent) {
    savedStatus = toBeCalled;
    savedEvent = theEvent;
  }

  /** User chooses if they want to save the game progress or not */
  public void saveGame () {
    boxesOnScreen.clear();

    if (globalStatus == Status.SAVING || globalStatus == Status.TYPING) {
      ArrayList <Button> savingBoxes = new ArrayList <Button>();

      fill(255, 255, 255); // change colour to something nicer?
      rect(width/2 - 350, 150, 700, 800);
      fill(0);
      textSize(50);
      text("Your game is unsaved.", width/2, 240);
      textSize(70);
      text("Do you want to save?", width/2, 290);

      Button yes = new Button(width/2 - 100, 500, 200, 100, 7, "Yes", color(0), false);
      yes.setColour(100, 255, 180, 255);
      yes.setTextSize(70);
      yes.assignStatus(Status.TYPING);

      Button no = new Button(width/2 - 100, 700, 200, 100, 7, "No", color(0), false);
      no.setColour(255, 100, 100, 255);
      no.setTextSize(70);
      no.assignStatus(savedStatus);
      no.setEvent(savedEvent);

      savingBoxes.add(yes);
      savingBoxes.add(no);

      for (Button b : savingBoxes) {
        if (b.isTouching(mouseX, mouseY)) {
          b.changeAlpha(1);
        } else {
          b.changeAlpha(0);
        }

        b.drawButton();

        if (b.isTouching(clickedX, clickedY)) {
          b.callButton(b.getStatus());
          break;
        }
      }
    }
  }

  /** Allows user to change the name of the game slot so that it is recognisable
  /* this does not change the name of the actual file */
  public void typeName() {
    boxesOnScreen.clear();

    fill(255, 255, 255); // change colour to something nicer?
    rect(width/2 - 350, 150, 700, 800);
    fill(0);
    textSize(50);
    text("Please enter a name for your file", width/2, 240);
    textSize(25);
    text("The name must be between 1-13 characters", width/2, 290);

    fill(100, 255, 180, 255); 
    rect(width/2 - 300, 400, 600, 100, 7);
    fill(0);
    textSize(30);
    text(savedName, width/2, 450);

    Button save = new Button(width/2 -100, 700, 200, 100, 7, "Save", color(0), false);
    save.setColour(255, 60, 120, 255);
    save.assignStatus(savedStatus);
    save.setEvent(savedEvent);

    if (save.isTouching(mouseX, mouseY)) {
      save.changeAlpha(1);
    } else {
      save.changeAlpha(0);
    }

    save.drawButton();

    if (save.isTouching(clickedX, clickedY)) {
      typing = false;
    }

    if (!typing) {
      // write file then go to savedStatus
      writeToFile();
      save.callButton(save.getStatus());
    }
  }

  /** Method saves new data to existing file in data directory */
  public void writeToFile() {
    String pathName = savePathFiles[numberOfFile];
    String[] data = new String[5];
    String name = savedName;
    String played = Integer.toString(levelsPlayed);
    String completed = Integer.toString(levelsCompleted);
    String highestScore = Float.toString(highScore);
    data[0] = "SF";
    data[1] = " Name: "+ name;
    data[2] = " LevelsPlayed: "+ played;
    data[3] = " LevelsCompleted: "+completed;
    data[4] = " Highscore: "+ highestScore;
    println("Data saved in file: "+pathName);
    saveStrings(dataPath(pathName), data);
    println("Inside path: "+dataPath(""));
  }
}
