public class Button {
  private final float boxWidth, boxHeight, boxX, boxY, cornerRadius;
  private final String boxText;
  private color boxColour, textColour; 
  private int r, g, b, a; 
  private PImage img;
  private Status boxStatus; 
  private GameEvent game; // only used for some boxes and is otherwise null
  private float tSize;
  private boolean noTouch, isTouching, yesNo, drawBox = true;

  /** Button constructor */
  public Button (float x, float y, float w, float h, float r, String t, color tc, boolean touch) {
    boxX = x;
    boxY = y;
    boxHeight = h;
    boxWidth = w;
    cornerRadius = r; // value to change how round the edges are of rectangle
    boxText = t;
    textColour = tc;
    noTouch = touch;
  }

  public boolean isTouching(float x, float y) {
    if (noTouch) { 
      return false;
    }
    if (x>boxX && x< boxX+boxWidth) {
      if (y>boxY && y<boxY+boxHeight) {
        isTouching = true;
        return true;
      }
    }
    isTouching = false;
    return false;
  }

  public void assignStatus(Status status) {
    boxStatus = status;
  }

  public Status getStatus() {
    return boxStatus;
  }

  public void setEvent(GameEvent gameEvent) {
    game = gameEvent;
  }

  public GameEvent getEvent() {
    return game;
  }

  public void callButton(Status status) {

    if (status == null) {
      return;
    } else {
      switch(status) {
      case LOADING:
        globalStatus = Status.LOADING;
        backButton.setDraw(false);
        exitButton.setDraw(true);
        pauseButton.setDraw(false);
        project.loadGame();
        break;
      case CHOOSING:
        globalStatus = Status.CHOOSING;
        mainEvent = null;
        backButton.setDraw(true);
        exitButton.setDraw(false);
        pauseButton.setDraw(false);
        project.chooseEvent();
        break;
      case PLAY:
        globalStatus = Status.PLAY;
        pauseButton.setDraw(false);
        backButton.setDraw(true);
        mainEvent = game;
        mainEvent.loadEvent();
        mainEvent.startGame();
        break;
      case PLAYING: 
        boxesOnScreen.clear();
        imagesOnScreen.clear();
        pauseButton.setDraw(true);
        backButton.setDraw(false);
        globalStatus = Status.PLAYING;
        mainEvent.playGame();
        break;
      case PAUSE:
        boxesOnScreen.clear();
        imagesOnScreen.clear();
        pauseButton.setDraw(false);
        globalStatus = Status.PAUSE;
        project.paused();
        break;
      case SAVING: 
        boxesOnScreen.clear();
        imagesOnScreen.clear();
        pauseButton.setDraw(false);
        globalStatus = Status.SAVING;
        project.saveGame();
        break;
      case TYPING:
        boxesOnScreen.clear();
        imagesOnScreen.clear();
        pauseButton.setDraw(false);
        globalStatus = Status.TYPING;
        project.typing = true;
        project.typeName();
        break;
      case QUIT:
        exit();
      }
    }
  }

  public void changeAlpha(int touching) {
    if (noTouch) { 
      return;
    }
    switch(touching) {
    case 0:
      boxColour = color(r, g, b, a);
      break;
    case 1:
      boxColour = color(r, g, b, a-150);
      break;
    }
  }

  public void setColour(int red, int green, int blue, int alpha) {
    r = red;
    g = green;
    b = blue;
    a = alpha;
    boxColour = color(r, g, b, a);
  }

  public void setDraw(boolean draw) {
    drawBox = draw;
    noTouch = !draw;
  }

  public void setTexture(PImage image) {
    img = image;
  }

  public void setTextSize(float size) {
    tSize = size;
  }

  public void drawButton() {
    if (drawBox) {
      if (img==null) {
        drawNoMask();
      } else {
        drawMask();
      }
    }
  }

  public void drawMask() {
    fill(boxColour);
    rect(boxX, boxY, boxWidth, boxHeight, cornerRadius);
    if (isTouching) {
      tint(boxColour, a);
    }
    image(img, boxX, boxY, boxWidth, boxHeight);
    fill(textColour);
    textSize(40*(boxWidth/boxHeight));
    text(boxText, boxX+(boxWidth/10), boxY+(boxHeight/10), boxX+((8*boxWidth)/10), boxY+((8*boxHeight)/10));
    noTint();
  }

  public void drawNoMask() {
    fill(boxColour);
    rect(boxX, boxY, boxWidth, boxHeight, cornerRadius);
    fill(textColour);
    if (boxText!= null) {
      if (tSize == 0.0f) { // checks if text size was initialised or not
        textSize(1.5*(boxWidth/boxText.length()));
      } else {
        textSize(tSize);
      }
      text(boxText, boxX+(boxWidth/20), boxY+(boxHeight/20), boxWidth-(boxWidth/20), boxHeight-(boxHeight/20));
    }
  }
}
