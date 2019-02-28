import java.util.ArrayList;
import java.util.List;

List<ArrayList<Hexagon>> background = new ArrayList<ArrayList<Hexagon>>();
Entity test;
Hexagon mouseHex;
int listX = 0, listY = 0;
Entity selected;

void setup()
{
  size(1300, 950);
  
  for(int x = 1; x < 25; x++)
  {
    background.add(new ArrayList<Hexagon>());
    
    for(int y = 1; y < 15; y++)
    {
      int temp = 62 * y;
      
      if(x % 2 == 0)
      {
        temp += 30;
      }

      background.get(x - 1).add(new Hexagon(52 * x, temp, 35, 6, (int)(Math.random() * 30), (int)(Math.random() * 40 + 70), (int)(Math.random() * 30)));
    }
  }
  
  //Move values... 3=2, 4=3, 7=4, 11~=5
  test = new Entity(0, 0, 20, 4, 255, 0, 0, 7);
  mouseHex = nearestHex(mouseX, mouseY);
  mouseHex.g += 150;
  test.move(background.get(0).get(0));
}

void draw()
{
  background(20, 98, 224);
    
  pushMatrix();
  for(ArrayList<Hexagon> list : background)
  {
    for(Hexagon h : list)
    {
      h.display();
    }
  }
  popMatrix();
    
  pushMatrix();
  test.display();
  popMatrix();
}

void mouseMoved()
{
  mouseHex.g -= 145;
  
  List<Hexagon> adjacent = new ArrayList<Hexagon>();
  adjacent.add(mouseHex);
  
  /*
   *           ***
  ***          ***
  ***           *
  odd          even
  */
  
  for(int x = -1; x < 2; x++)
  {
    for(int y = -1; y < 2; y++)
    {
      if(listX + x >= 0 && listX + x < background.size() && listY + y >= 0 && listY + y < background.get(0).size())
      {
        adjacent.add(background.get(listX + X).get(listY + Y));
      }
    }
  }
  
  if(listX % 2 == 0)
  {
    if(listX + 1 < background.size() && listY + 1 < background.get(0).size())
      adjacent.remove(background.get(listX + 1).get(listY + 1));
  }
  
  
  mouseHex = nearestHex(adjacent, mouseX, mouseY);
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
  Hexagon hex = background.get(0).get(0);
  
  for(int x = 0; x < background.size(); x++)
  {
    for(int y = 0; y < background.get(0).size(); y++)
    {
      currentDistance = distance(mX, mY, background.get(x).get(y).x, background.get(x).get(y).y);
      if(currentDistance < min)
      {
        min = currentDistance;
        hex = background.get(x).get(y);
        listX = x;
        listY = y;
      }
    }
  }
    
  return hex;
}

public Hexagon nearestHex(List<Hexagon> choices, int mX, int mY)
{
  int min = Integer.MAX_VALUE;
  int currentDistance = 0;
  Hexagon hex = choices.get(0);
  
  for(int i = 0; i < choices.size(); i++)
  {
    currentDistance = distance(mX, mY, choices.get(i).x, choices.get(i).y);
    if(currentDistance < min)
    {
      min = currentDistance;
      hex = choices.get(i);
       
      if(i == 0)
      {
        listY += 1;
      }
      else if(i == 1)
      {
        listY -= 1;
      }
      else if(i == 2)
      {
        listX += 1;
        listY += 1;
      }
      else if(i == 3)
      {
        listX += 1;
        listY -= 1;
      }
      else if(i == 4)
      {
        listX -= 1;
        listY += 1;
      }
      else if(i == 5)
      {
        listX -= 1;
        listY -= 1;
      }
      
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
  for(ArrayList<Hexagon> list : background)
  {
    for(Hexagon h : list)
    {
      if(distance(selected.x, selected.y, h.x, h.y) < 9010 * selected.moveRange)
      {
        h.g += colorShift;
      }
    }
  }
}
