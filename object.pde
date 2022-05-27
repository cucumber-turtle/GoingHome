/** This class is for all randomised on-screen game event objects */

public class Object {
  private final String gameName, type, objectName;
  private PImage image;
  private ArrayList <PImage> images = new ArrayList<PImage>();
  private int variation, frames, time, index, size; 
  private float x, y;
  // variables for animating animal objects
  private float second, localFrameRate = 180;

  public Object(String event, String category, String name, int number) {
    gameName = event;
    type = category;
    objectName = name;
    index = 0;
    if (category.equals("animal")) {
      frames = number;
      for (int n = 1; n <= frames; n++) {
        images.add(loadImage(gameName+"-animal-"+objectName+"-"+n+".png"));
      }
    } else if (category.equals("object")) {
      variation = number;
      image = loadImage(gameName+"-"+type+"-"+objectName+"-"+number+".png");
    } else {
      throw new RuntimeException("Invalid object category entered");
    }
  }

  // second constructor is used to create duplicate object without loading image again
  // or needing to give the constructor many arguments
  public Object(Object like) {
    gameName = like.getGameName();
    type = like.getType();
    objectName = like.getObjectName();
    if (!(type.equals("object") ||(type.equals("animal")))) {
      throw new RuntimeException("Invalid object category entered");
    }
    if (type.equals("animal")) {
      frames = like.getNumber();
      for (int n = 1; n <= frames; n++) {
        images.add(loadImage(gameName+"-animal-"+objectName+"-"+n+".png"));
      }
    } else if (type.equals("object")) {
      variation = like.getNumber();
      image = like.getImage();
    }
    x = width+1;
  }

  public void assignYRegion(float yRegion) {
    y = yRegion;
  }
  public void assignXRegion(float xRegion) {
    x = xRegion;
  }

  public void setSize(int s) {
    size = s;
  }

  // only works for non-animal
  public void drawObject() {
    // write stuff to animate animal object if frames>1
    if (y == 0.0f) { 
      throw new IllegalArgumentException("Please initialise y first");
    }
    if (size != 0.0f) {
      image.resize(0, size);
    }
    if (type == "animal") {
      image(images.get(index), x, y);
      if (millis() > second) {
        index++;
        second += localFrameRate;
      }
      if (index>= images.size()) {
        index = 0;
      }
    } else {
      image(image, x, y);
    }
  }
  // only works for non-animal atm
  public boolean notInBoundary(float boundary) {
    if (type.equals("animal")) {
      if (x+images.get(index).width<boundary) {
        return true;
      } else {
        return false;
      }
    } else {
      if (x+image.width<boundary) {
        return true;
      } else {
        return false;
      }
    }
  }

  public void moveX(float speed) {
    x = x-speed;
  }

  public String getGameName() {
    return gameName;
  }

  public String getType() {
    return type;
  } 

  public String getObjectName() {
    return objectName;
  }

  public int getNumber() {
    if (type.equals("animal")) {
      return frames;
    } else if (type.equals("object")) {
      return variation;
    }
    return 0;
  }

  public ArrayList<PImage> getImages() {
    return images;
  }

  public PImage getImage() {
    return image;
  }

  public float getX() {
    return x;
  }

  // only works for non-animal
  public float getWidth() {
    return image.width;
  }
}
