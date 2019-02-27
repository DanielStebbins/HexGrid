import java.util.ArrayList;
import java.util.List;

List<Hexagon> background = new ArrayList<Hexagon>();
Entity test;
Hexagon mouseHex;
Entity selected;

void setup()
{
  size(1300, 950);
  
  for(int x = 1; x < 25; x++)
  {
    for(int y = 1; y < 15; y++)
    {
      int temp = 62 * y;
      
      if(x % 2 == 0)
      {
        temp += 30;
      }

      background.add(new Hexagon(52 * x, temp, 35, 6, (int)(Math.random() * 30), (int)(Math.random() * 40 + 70), (int)(Math.random() * 30)));
    }
  }
  
  //Move values... 3=2, 4=3, 7=4, 11~=5
  test = new Entity(0, 0, 20, 4, 255, 0, 0, 11);
  mouseHex = background.get(0);
  mouseHex.g += 150;
  test.move(background.get(0));
}

void draw()
{
  background(20, 98, 224);
    
  pushMatrix();
  for(Hexagon h : background)
  {
    h.display();
  }
  popMatrix();
    
  pushMatrix();
  test.display();
  popMatrix();
}

void mouseMoved()
{
  mouseHex.g -= 145;
  mouseHex = nearestHex(mouseX, mouseY);
  mouseHex.g += 145;
}

void mouseClicked()
{
  if(selected == null)
  {
    selected = mouseHex.occupant;
    
    if(selected != null)
    {
      selected.r += 100;
      selected.g += 100;
      selected.b += 100;
      
      moveShade(145);
    }
  }
  else
  {
    if(selected == mouseHex.occupant)
    {
      selected.r -= 100;
      selected.g -= 100;
      selected.b -= 100;
      moveShade(-145);
      selected = null;
    }
    else
    {
      moveShade(-145);
      selected.position.occupant = null;
      selected.move(mouseHex);
      moveShade(145);
    }
  }
}

public Hexagon nearestHex(int mX, int mY)
{
  int min = Integer.MAX_VALUE;
  int currentDistance = 0;
  Hexagon hex = background.get(0);
  
  for(Hexagon h : background)
  {
    currentDistance = distance(mX, mY, h.x, h.y);
    if(currentDistance < min)
    {
      min = currentDistance;
      hex = h;
    }
  }
    
  return hex;
}

public static int distance(int x1, int y1, int x2, int y2)
{
  return (int) (Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
}

public void moveShade(int colorShift)
{
  for(Hexagon h : background)
  {
    if(distance(selected.x, selected.y, h.x, h.y) < 9010 * selected.moveRange)
    {
      h.g += colorShift;
    }
  }
}
