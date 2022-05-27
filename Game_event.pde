public class GameEvent {
  GameEvent currentEvent;
  private final String gameName;
  private ArrayList <Object> allObjects = new ArrayList<Object>(), objectsOnScreen = new ArrayList<Object>(), 
    allAnimals = new ArrayList<Object>(); 
  private ArrayList <Health> allPoints = new ArrayList<Health>();
  private String story = "";
  private int pointsCollected, health, timer, maxPoints;
  private GameCharacter mainCharacter;
  private float radiusXScreen, radiusYScreen, bottomScreen =(height/2)+radiusYScreen, timeLimit, second, space = 500, timeSpace=1200;
  private Health point;
  private Picture checkPoint;

  public GameEvent(String game) {
    gameName = game;
    pointsCollected = 0;
    health = 100 * frameRate;
    timer = 0;
    maxPoints = 120;
    timeLimit = 60;
    radiusXScreen = 600;
    radiusYScreen = 350;
  }

  /** Here write the introduction to the game event with instructions
  /* if user clicks "continue" game begins otherwise intro stays on screen
  /* creates randomised scene */
  public void startGame() {

    boxesOnScreen.clear();
    imagesOnScreen.clear();
    notFinished = true;
    currentEvent = mainEvent;

    if (globalStatus == Status.PLAY) {

      objectsOnScreen.clear();
      allPoints.clear();

      createScene();
      pointsCollected = 0;
      health = 100 * frameRate;
      timer = 0;
      second = timeSpace;
      Button storyTeller = new Button(100, 150, 1000, 600, 7, story, color(50, 40, 60), true);
      storyTeller.setColour(240, 200, 190, 255);
      storyTeller.setTextSize(37);
      boxesOnScreen.add(storyTeller);

      Button cont = new Button(1180, 700, 400, 100, 7, "Continue", color(15, 100, 150), false);
      cont.setColour(250, 100, 200, 255);
      cont.assignStatus(Status.PLAYING);
      boxesOnScreen.add(cont);

      Picture icon = new Picture(mainCharacter.getCharName()+"-icon-2.png", 1500, 200);
      icon.changeSize(500);
      imagesOnScreen.add(icon);

      // return button to go back to choosing
      backButton.assignStatus(Status.CHOOSING);
    }
  }

  /** Every 50 places on the x axis decide whether or not to create object at y-region
  /* assign objects to y region assign y value to points
  /* assign an initial x region for objects and points */
  public void createScene() {
    checkPoint = new Picture("checkpoint.png", (width/2)+radiusXScreen+300, bottomScreen+100);
    float lastX = width/2 - radiusXScreen;
    for (int n = 0; n < (width/2)+radiusXScreen; n++) {
      int c3 = randomise(0, allObjects.size());
      Object onScene = new Object(allObjects.get(c3));
      onScene.assignYRegion(bottomScreen);
      onScene.assignXRegion(space+lastX);
      lastX +=space;
      objectsOnScreen.add(onScene);
    }

    if (allAnimals.size()>0) {
      for (int n = 0; n < 4; n++) {
        int c4 = randomise(0, allAnimals.size());
        Object onScene = new Object(allAnimals.get(c4));
        int c5 = randomise(1000, 9000);
        onScene.assignXRegion(c5);
        int c6 = randomise((int)((height/2)-radiusYScreen), (int)((height/2)+radiusYScreen));
        onScene.assignYRegion(c6);
        objectsOnScreen.add(onScene);
      }
    }

    int pastXRegion = 0;
    for (int n = 0; n <maxPoints; n++) {
      Health p = new Health(point.getImage());
      int c1 = randomise(50, 2000);
      p.assignXRegion(c1+pastXRegion);
      int c2 = randomise((int)((height/2)-radiusYScreen), (int)((height/2)+radiusYScreen));
      p.assignYRegion(c2);
      pastXRegion += c1;
      allPoints.add(p);
    }
  }

  /** method to play game */
  public void playGame() {
    boxesOnScreen.clear();
    if (globalStatus == Status.PLAYING && notFinished) {
      if (timer+(frameRate*(radiusXScreen/280))>= timeLimit*frameRate) {
        checkPoint.moveX(10);
      }
      ArrayList <Object> removeO = new ArrayList();
      ArrayList <Health> removeH = new ArrayList();
      timer++;
      health-=2;

      boolean newObjects = false;
      for (Object o : objectsOnScreen) {
        // animal objects must move faster than other objects to give illusion of live movement
        if (o.getType().equals("animal")) {
          o.moveX(mainCharacter.getSpeed()*2);
        } else {
          o.moveX(mainCharacter.getSpeed()*1.5);
        }
        if (o.notInBoundary((width/2)-radiusXScreen)) {
          removeO.add(o);
          newObjects = true;
        }
      }

      if (newObjects && millis()> second*4) {
        int c2 = randomise(0, allObjects.size());
        Object onScene = new Object(allObjects.get(c2));
        onScene.assignYRegion(bottomScreen);
        onScene.assignXRegion(width/2+(radiusXScreen));
        objectsOnScreen.add(onScene);
        second += timeSpace;
      }

      for (Health p : allPoints) {
        p.moveX(mainCharacter.getSpeed()*2); 
        if (p.notInBoundary((width/2)-radiusXScreen)) {
          removeH.add(p);
        }
        if (p.isTouching(mainCharacter.getX(), mainCharacter.getY(), 
          mainCharacter.getWidth(), mainCharacter.getHeight())) {
          pointsCollected++;
          health+=5;
          removeH.add(p);
        }
      }

      for (Object r : removeO) {
        objectsOnScreen.remove(r);
      }
      for (Health r : removeH) {
        allPoints.remove(r);
      }
    }
    // end of game checkpoint is drawn at an x coordinate so that when time ends
    // the checkpoint should be reached to win the game

    drawGame();

    if (timer>= timeLimit*frameRate) {
      delay(200);
      gameFinish();
    }

    if (health<=0) {
      delay(200);
      gameFinish();
    }
  }

  /** method to draw all graphics for playing the game, including the game screen
  /* does not include the pause button or the background */
  public void drawGame() {
    // stop drawing after timer is finished 
    if (globalStatus == Status.PLAYING || globalStatus == Status.PAUSE) {
      fill(10, 10, 50);
      rect((width/2)-radiusXScreen, (height/2)-radiusYScreen, radiusXScreen*2, radiusYScreen*2);

      clip((width/2)-radiusXScreen, (height/2)-radiusYScreen, radiusXScreen*2, radiusYScreen*2);
      for (Health p : allPoints) {
        p.drawPoint();
      }
      for (Object o : objectsOnScreen) {
        o.drawObject();
      }

      // timer and health point bars
      fill(255);
      rect(500, ((height/2)-radiusYScreen)+50, timeLimit*2, 40);
      rect(500, ((height/2)-radiusYScreen)+100, 100, 40);
      textSize(30);
      text("Timer", 440, ((height/2)-radiusYScreen)+60);
      text("Health", 440, ((height/2)-radiusYScreen)+110);


      if (timer/frameRate<=timeLimit) {
        fill(255, 40, 90);
        rect(500, ((height/2)-radiusYScreen)+50, (timer/frameRate)*2, 40);

        // write algorithm to determine how much health user has based on points collected and "energy spent"
        fill(100, 255, 50);
        rect(500, ((height/2)-radiusYScreen)+100, health/frameRate, 40);
      }

      checkPoint.drawPicture();

      mainCharacter.drawChar();

      clip(0, 0, width, height);
    }
  }

  /** This method is called when time limit is passed
  /* informs user if they won or lost and of their score
  /* allows user to choose to save game or return to menu
  /* updates levels played
  /* if user won, updates levels completed */
  public void gameFinish() {

    boxesOnScreen.clear();

    notFinished = false; // stops screen from deleting and creating new objects
    saved = false;
    pauseButton.setDraw(false);

    project.levelsPlayed++;

    fill(255, 255, 255, 210); // change colour to something nicer?
    rect(width/2 - 350, 150, 700, 800);

    String winLoss = "";
    if (health>0 && timer>= timeLimit*frameRate) {
      winLoss = "You Won";
      project.levelsCompleted++;
    } else {
      winLoss = "You Lost";
    }
    fill(0);
    textSize(100);
    text(winLoss, width/2, 240);

    textSize(50);
    text("Points collected: "+Integer.toString(pointsCollected), width/2, 400);
    text("Total health: "+Integer.toString(health/frameRate), width/2, 500);
    text("Highscore: ", width/2, 600); // you can leave this out

    Button replay= new Button(width/2 - 100, 700, 200, 100, 7, "Replay", color(0), false);
    replay.setColour(255, 100, 100, 255);
    replay.setEvent(currentEvent);
    replay.assignStatus(Status.PLAY);
    boxesOnScreen.add(replay);

    Button goBack = new Button(width/2 - 100, 820, 200, 100, 7, "Back", color(0), false);
    goBack.setColour(255, 100, 100, 255);
    goBack.assignStatus(Status.CHOOSING);
    boxesOnScreen.add(goBack);
  }

  /** Loads event data from txt file 
  /* objects animals points are all loaded as "models"
  /* models are not directly used by the game, they are used to create objects for the game */
  public void loadEvent() {
    objectsOnScreen.clear();
    allPoints.clear();
    allAnimals.clear();
    allObjects.clear();

    story = "";

    // Load data from txt file and organise so that info is processed in desired way (not line by line)
    String[] data = loadStrings(gameName+".txt");
    String firstSplit = "";

    for (String line : data) {
      firstSplit += line;
    }

    data = split(firstSplit, " ");

    // Write story and create character, objects, and health point as specified by file 
    if (data[0].equals("GE")) {
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
          if (word.equals("Story:")) {
            state = 2;
            continue;
          }
          break;
        case 2: 
          if (word.equals("Character:")) {
            state = 3;
            continue;
          } else {
            story += word+" "; // write story
          }
          break;
        case 3:
          if (word.equals("Animals:")) {
            state = 4;
            continue;
          } else {
            //make character 
            String frames = word.replaceAll("\\D+", "");
            String charName = word.replaceAll("\\d", "");
            mainCharacter = new GameCharacter(gameName, charName, frames, ((height/2)-radiusYScreen), (height/2)+radiusYScreen);
          }
          break;
        case 4:
          if (word.equals("Objects:")) {
            state = 5;
            continue;
          } else {
            String number = word.replaceAll("\\D+", "");
            if (!number.equals("")) {
              int frames = Integer.parseInt(number);
              String name = word.replaceAll("\\d", "");
              allAnimals.add(new Object(gameName, "animal", name, frames)); // make model animals
            }
          }
          break;
        case 5:
          if (word.equals("Health:")) {
            state = 6;
            continue;
          } else {
            String number = word.replaceAll("\\D+", "");
            if (!number.equals("")) {
              int variation = Integer.parseInt(number);
              String name = word.replaceAll("\\d", "");
              for (int v = 1; v<= variation; v++) {
                allObjects.add(new Object(gameName, "object", name, v)); // make model objects
              }
            }
          }
          break;
        case 6:
          point = new Health(gameName, word); // make model health point
        }
      }
    } else {
      throw new IllegalArgumentException("File is invalid: not a game event file.");
    }
  }

  // GameEvent class's return methods are below 
  public GameCharacter getCharacter() {
    return mainCharacter;
  }
  public String getEventName() {
    return gameName;
  }
  public int getPointsTotal() {
    return pointsCollected;
  }
}
