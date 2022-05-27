/** Class for pictures that serve no functional purpose
/* and for images like the game checkpoint 
/* images are added for aesthetic purposes */

public class Picture {
  private final PImage picture;
  private float x, y;

  public Picture(String pathName, float posX, float posY) {
    picture = loadImage(pathName);
    x = posX;
    y = posY;
  }
  public void drawPicture() {
    image(picture, x - picture.width/2, y);
  }

  public void changeSize(int size) {
    picture.resize(0, size);
  }

  public void moveX (float speed) {
    x = x - speed;
  }
}
