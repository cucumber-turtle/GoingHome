/** This class is for health points
/* health point works same way as object does except it has less functions
/* also is found from data file using a different style instead of event-type-name-variation.png
/* health is stored in data file as event-type-name.png
/* health points have a set y region but are moved from the right to the left of the screen (x value is changed)
/* for every tick of the timer */

public class Health {
  private PImage point;
  private float posX, posY;

  public Health(String event, String name) {
    point = loadImage(event+"-health-"+name+".png");
  }

  // second constructor is used to create duplicate object without loading image again
  public Health (PImage pic) {
    point = pic;
  }

  public PImage getImage() {
    return point;
  }

  public void assignYRegion(float yRegion) {
    posY= yRegion;
  }

  public void assignXRegion(float xRegion) {
    posX = xRegion;
  }

  public void moveX(float speed) {
    if (posX == 0.0f) {
      throw new IllegalArgumentException("Please initialise x first");
    }
    posX = posX-speed;
  }

  public boolean notInBoundary(float boundary) {
    if (posX+point.width<boundary) {
      return true;
    } else {
      return false;
    }
  }

  public void drawPoint() {
    if (posY == 0.0f) { 
      throw new IllegalArgumentException("Please initialise y first");
    }
    if (posX == 0.0f) {
      throw new IllegalArgumentException("Please initialise y first");
    }
    image(point, posX, posY);
  }

  public boolean isTouching(float x, float y, float cWidth, float cHeight) {
    if (x+cWidth>=posX && x<= posX+point.width && 
      y+cHeight>=posY && y<=posY+point.height) {
      return true;
    }
    return false;
  }
}
