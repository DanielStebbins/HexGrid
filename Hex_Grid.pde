import java.util.ArrayList;
import java.util.List;

List<Hexagon> background = new ArrayList<Hexagon>();
Entity test;
Hexagon mouseHex;
Entity selected;

void setup()
{
  fullScreen();
  
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
  
  test = new Entity(0, 0, 20, 4, 255, 0, 0, 5);
  mouseHex = background.get(0);
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

void mouseClicked()
{
  if(selected == null)
  {
    selected = mouseHex.occupant;
    selected.r = 0;
    selected.b = 255;
  }
  else
  {
    selected.move(mouseHex);
  }
  
}

void mouseMoved()
{
  mouseHex = nearestHex(mouseX, mouseY);
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
