public class Box
{
  //encapsulated items
  private int x = 0;
  private int y = 0;
  private int h = 0;
  private int w = 0;
  private int z = 0;
  private int moveRange = 0;
  private boolean isDragged = false;
  private color col = color(255, 0, 0);
  private PImage image;
  private int imageIndex;
  
  //overloaded constructors
 Box()
 {
   this.x = 0;
   this.y = 0;  
   this.w = 10;
   this.h = 10;
   this.z = 0;
   this.image = null;
 }
  /*X,Y coords and height and witdth and string for file*/
 Box(int x, int y, int wid, int hei, int z, PImage image, int moveRange, int imageIndex)
 {
   this.x = x;
   this.y = y;  
   this.w = wid;
   this.h = hei;
   this.z = z;
   this.image = image;
   this.moveRange = moveRange;
   this.imageIndex = imageIndex;
 }
 
  Box(int x, int y, int wid, int hei, int z)
 {
   this.x = x;
   this.y = y;  
   this.w = wid;
   this.h = hei;
   this.z = z;
 }
 
 //throws the image over the presized box
 public void setDrawings()
 {
   if(this.image == null)
   {}
   else
   {
     imageMode(CORNER);
     image.resize(this.w,this.h);
     image(this.image,this.x,this.y);
   }
 }
 
 //sets up a box
 public void displayBox()
{
   fill(col);
   rect(this.x,this.y,this.w,this.h);
}

 //to be done as a scan for the boxes, only dimensions needed
  public boolean isWithin()
  {
    if((int) (cameraX + (mouseX - width / 2) * cameraZ / 822.76) < this.w + this.x && (int) (cameraX + (mouseX - width / 2) * cameraZ / 822.76) > this.x && (int) (cameraY + (mouseY - height / 2) * cameraZ / 822.76) < this.h + this.y && (int) (cameraY + (mouseY - height / 2) * cameraZ / 822.76) > this.y)
      return true;
    return false;
  }  
  
  //getters and setters
 public void setColor(color col)
 {
  this.col = col; 
 }
 
 public int getX()
 {
  return this.x;
 }
 
 public void setX(int x)
 {
   this.x = x;
 }
 
 public int getY()
 {
  return this.y; 
 }
 
 public void setY(int y)
 {
   this.y = y;
 }
 
 public boolean getIsDragged()
 {
   return this.isDragged;
 }
 
 public void setIsDragged(boolean isDragged)
 {
   this.isDragged = isDragged; 
 }
 
 public void setWidth(int w)
 {
   this.w = w;
 }
 
 public int getWidth()
{
 return this.w; 
}

 public void setHeight(int h)
 {
   this.h = h;
 }
 
 public int getHeight()
 {
   return this.h; 
 }
 
 public PImage getImage()
 {
   return this.image;
 }
 
 public int getZ()
 {
   return this.z;
 }
 
  public void setZ(int z)
 {
   this.z = z;
 }
 
 public void setImage(PImage image)
 {
   this.image = image;
 }
 
 public int getMoveRange()
 {
   return moveRange;
 }
 
 public int getImageIndex()
 {
   return imageIndex;
 }
}
