

public class Box
{
  //encapsulated items
  private int x = 0;
  private int y = 0;
  private int h = 0;
  private int w = 0;
  private boolean isDragged = false;
  private color col = color(66, 134, 244);
  private PImage image;
  
  //overloaded constructors
 Box()
 {
   this.x = 0;
   this.y = 0;  
   this.w = 10;
   this.h = 10;
   this.image = null;
 }
  /*X,Y coords and height and witdth and string for file*/
 Box(int x, int y, int wid, int hei, PImage image)
 {
   this.x = x;
   this.y = y;  
   this.w = wid;
   this.h = hei;
   this.image = image;
 }
 
  Box(int x, int y, int wid, int hei)
 {
   this.x = x;
   this.y = y;  
   this.w = wid;
   this.h = hei;
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
    if(mouseX < this.w + this.x && mouseX > this.x && mouseY < this.h + this.y && mouseY > this.y)
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
 
 public int getWidth()
{
 return this.w; 
}
 
 public int getHeight()
 {
   return this.h; 
 }
 
 public PImage getImage()
 {
   return this.image;
 }
}
