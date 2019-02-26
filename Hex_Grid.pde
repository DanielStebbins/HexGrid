import java.util.ArrayList;
import java.util.List;

List<Hexagon> background = new ArrayList<Hexagon>();
Entity test;

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
  
  test = new Entity(0, 0, 20, 4, 255, 0, 0, 5);
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
  test.toClick(mouseX, mouseY);
}
