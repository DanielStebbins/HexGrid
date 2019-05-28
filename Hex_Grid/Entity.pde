//Stores the movement range, color, and current hexagon occupied.
public class Entity
{
  int x;
  int y;
  int moveRange;
  PImage image;
  Hexagon position;
  public Entity(Hexagon position, PImage image, int moveRange)
  {
    this.position = position;
    this.image = image;
    this.moveRange = moveRange;
  }
  
  //Sets a new position and current hexagon when the entity moves.
  public void move(Hexagon mouseHex)
  {
     x = mouseHex.x;
     y = mouseHex.y;
     mouseHex.occupant = this;
     position = mouseHex;
  }
  
 public void setDrawings()
 {
   if(this.image == null)
   {}
   else
   {
     imageMode(CORNER);
     image.resize(70, 70);
     image(this.image,this.x,this.y);
   }
 }
}
