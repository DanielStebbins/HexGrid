public class Polygon
{
  int x, y, radius, sides, r, g, b;
   
  public Polygon(int x, int y, int radius, int sides, int r, int g, int b)
  {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.sides = sides;
    this.r = r;
    this.g = g;
    this.b = b;
  }

  public void display()
  {
    fill(r, g, b);
    
    float angle = TWO_PI / sides;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle)
    {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  
  //Bad equals I know.
  public boolean equals(Object other)
  {
    Polygon temp = (Polygon) other;
    return(temp.x == x && temp.y == y);
  }
}
