import java.util.ArrayList;
import java.util.List;

List<ArrayList<Hexagon>> background = new ArrayList<ArrayList<Hexagon>>();
Entity test;
Hexagon mouseHex;
int listX = 0, listY = 0;
float cameraX = 2650, cameraY = 3050, cameraZ = 0;
int moveX = 0, moveY = 0;
Entity selected;

void setup()
{
  size(1300, 950, P3D);
  //(height / 2) / tan(PI / 6)
  cameraZ = 1500;
  
  for(int x = 1; x < 100; x++)
  {
    background.add(new ArrayList<Hexagon>());

    for(int y = 1; y < 100; y++)
    {
      int temp = 60 * y;

      if(x % 2 == 0)
      {
        temp += 30;
      }

      background.get(x - 1).add(new Hexagon(52 * x, temp, 35, 6, (int)(Math.random() * 30), (int)(Math.random() * 40 + 70), (int)(Math.random() * 30), x, y));
    }
  }

  //Move values... 3=2, 4=3, 7=4, 11~=5
  test = new Entity(0, 0, 20, 4, 255, 0, 0, 7);
  mouseHex = nearestHex(mouseX, mouseY);
  mouseHex.g += 150;
  test.move(background.get(50).get(50));
}

void draw()
{
  background(20, 98, 224);
  if(moveX > 0)
  {
    cameraX += 10;
  }
  else if(moveX < 0)
  {
    cameraX -= 10;
  }
  if(moveY > 0)
  {
    cameraY += 10;
  }
  else if(moveY < 0)
  {
    cameraY -= 10;
  }
  camera(cameraX, cameraY, cameraZ, cameraX, cameraY, 0, 0, 1, 0);

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

void mouseWheel(MouseEvent event)
{
  float e = event.getCount();
  cameraZ += 30 * e;
}

void keyPressed()
{
  //w
  if(key == 119)
  {
    moveY = -1;
  }
  //s
  else if(key == 115)
  {
    moveY = 1;
  }
  //a
  else if(key == 97)
  {
    moveX = -1;
  }
  //d
  else if(key == 100)
  {
    moveX = 1;
  }
}

void keyReleased()
{
  //w
  if(key == 119)
  {
    moveY = 0;
  }
  //s
  else if(key == 115)
  {
    moveY = 0;
  }
  //a
  else if(key == 97)
  {
    moveX = 0;
  }
  //d
  else if(key == 100)
  {
    moveX = 0;
  }
}

void mouseMoved()
{
  mouseHex.g -= 145;

  /*
  List<Hexagon> adjacent = new ArrayList<Hexagon>();
  adjacent.add(mouseHex);

  
   *           ***
  ***          ***
  ***           *
  odd          even
  

  for(int x = -1; x < 2; x++)
  {
    for(int y = -1; y < 2; y++)
    {
      if(listX + x >= 0 && listX + x < background.size() && listY + y >= 0 && listY + y < background.get(0).size())
      {
        adjacent.add(background.get(listX + x).get(listY + y));
        background.get(listX + x).get(listY + y).r += 100;
        delay(100);
        background.get(listX + x).get(listY + y).r -= 100;
      }
    }
  }

  if(listX % 2 == 0)
  {
    if(listX + 1 < background.size() && listY + 1 < background.get(0).size())
    {
      adjacent.remove(background.get(listX + 1).get(listY + 1));
    }
    if(listX - 1 >= 0 && listY + 1 < background.get(0).size())
    {
      adjacent.remove(background.get(listX - 1).get(listY + 1));
    }
  }
  else
  {
    if(listX + 1 < background.size() && listY - 1 >= 0)
    {
      adjacent.remove(background.get(listX + 1).get(listY - 1));
    }
    if(listX - 1 >= 0 && listY - 1 >= 0)
    {
      adjacent.remove(background.get(listX - 1).get(listY - 1));
    }
  }
  */
  //X constant is -650 and Y constant is -475 when cameraZ = (height / 2) / tan(PI / 6) (822.76).
  mouseHex = nearestHex((int) (mouseX + cameraX - 650), (int) (mouseY + cameraY - 475));
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

      listX = hex.listPositionX;
      listY = hex.listPositionY;
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
