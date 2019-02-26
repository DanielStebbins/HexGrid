public class Entity extends Polygon
{
  int moveRange;
  public Entity(int x, int y, int radius, int sides, int r, int g, int b, int moveRange)
  {
    super(x, y, radius, sides, r, g, b);
    this.moveRange = moveRange;
  }
  
  public void toClick(int mX, int mY)
  {
    Hexagon newPosition = nearestHex(mX, mY);
    x = newPosition.x;
    y = newPosition.y;
  }
  
  public Hexagon nearestHex(int mX, int mY)
  {
    int min = Integer.MAX_VALUE;
    int currentDistance = 0;
    Hexagon hex = background.get(0);
    
    for(Hexagon h : background)
    {
      currentDistance =(int) (Math.pow(mX - h.x, 2) + Math.pow(mY - h.y, 2));
      if(currentDistance < min)
      {
        min = currentDistance;
        hex = h;
      }
    }
    
    return hex;
  }
}
