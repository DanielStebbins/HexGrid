public class Entity extends Polygon
{
  int moveRange;
  Hexagon position;
  public Entity(int x, int y, int radius, int sides, int r, int g, int b, int moveRange)
  {
    super(x, y, radius, sides, r, g, b);
    this.moveRange = moveRange;
  }
  
  public void move(Hexagon mouseHex)
  {
     x = mouseHex.x;
     y = mouseHex.y;
     mouseHex.occupant = this;
     position = mouseHex;
  }
}
