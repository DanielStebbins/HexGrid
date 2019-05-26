//Stores the positions (pixel and list), color, and current entity occupant.
public class Hexagon extends Polygon
{
  int listPositionX, listPositionY;
  Entity occupant;
  public Hexagon(int x, int y, int radius, int sides, int r, int g, int b, int lPX, int lPY)
  {
    super(x, y, radius, sides, r, g, b);
    listPositionX = lPX;
    listPositionY = lPY;
  }
}
