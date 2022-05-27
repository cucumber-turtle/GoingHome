/** This class is used to store image/s of character and to specify controls */
public class GameCharacter {
  private final PImage character;
  private final String characterName;
  private int frames; // currently characters don't have animation frames
  private float bottom, top;
  private float x, y, speed;

  public GameCharacter(String gameName, String charName, String frame, float min, float max) {
    character = loadImage(gameName+"-character-"+charName+"-"+frame+".png");
    character.resize(0, 130);
    characterName = charName;
    frames = Integer.parseInt(frame);
    speed = 10;
    x = (width/2) - (character.width)/2;
    y = height/2 - (character.height)/2;
    top = min;
    bottom = max;
  }

  public void goUp() {
    // if the character is not at the top of the game screen
    // move character up
    y-=speed;
    if (y<top) {
      //y+=speed;
    }
  }

  public void goDown() {
    // if the character is not at the bottom of the game screen
    // move character down
    y+=speed;
    if (y+((character.height)/2)>bottom) {
      //y-=speed;
    }
  }

  public void drawChar() {
    image(character, x, y);
  }

  public void setSpeed(float speeder) {
    speed = speeder;
  }

  public float getSpeed() {
    return speed;
  }
  public String getCharName() {
    return characterName;
  }
  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }
  public float getWidth() {
    return character.width;
  }

  public float getHeight() {
    return character.height;
  }
}
