/*
Daniel Stebbins
This is my own work, D.S.
This project displays a grid made of hexagons and allows the user to move entities by clicking on them.
*/


// Excess Troy Code----------------------
int xOffset = 0;
int yOffset = 0;
PImage[] images = new PImage[5];
color col = color(216);
 /*X,Y coords and height and witdth and string for file*/
Box boxes[] = new Box[5];
boolean dragging = false;
int state;
ArrayList<Box> shownItems = new ArrayList<Box>();
//-----------------------------

import java.util.ArrayList;
import java.util.List;

//Stores all hexagons.
List<ArrayList<Hexagon>> background = new ArrayList<ArrayList<Hexagon>>();

//Stores the hexagons the selected entity can move to.
List<Hexagon> movable = new ArrayList<Hexagon>();
Entity test1, test2;
Entity selected;

//Stores the hexagon the mouse is in and the list position of that hexagon.
Hexagon mouseHex;
int listX = 0, listY = 0;

//Stores camera position.
float cameraX = 2650, cameraY = 2300, cameraZ = 0;

//Stores whether the user is panning up, down, left, or right.
int moveX = 0, moveY = 0;

boolean isShifting = false;

void setup()
{
  //---------------------------------
  fullScreen();
  frameRate(60);
  //rendering images, needs to be 1 more than boxes loop, factors in the menu itself
  
  for(int i = 0; i < images.length; i++)
  {
   images[i] = loadImage("image" + i + ".png"); 
  }
  
  //this is going to be the "dropdown" selection
  for(int i = 0; i < boxes.length; i++)
  {
   boxes[i] = new Box(0,i*100,100,100,images[i]);
  }
  state = 0;  
  //-------------------------------
  //size(1300, 950, P3D);
  cameraZ = (height / 2) / tan(PI / 6);
  
  //Creating the array of hexagons.
  for(int x = 1; x < 100; x++)
  {
    background.add(new ArrayList<Hexagon>());

    for(int y = 1; y < 75; y++)
    {
      int temp = 60 * y;

      if(x % 2 == 0)
      {
        temp += 30;
      }
      
      //Creates a shape with this x value, y value, radius, number of sides, r, g, b, list x position, and list y position.
      background.get(x - 1).add(new Hexagon(52 * x, temp, 35, 6, (int)(Math.random() * 30), (int)(Math.random() * 40 + 70), (int)(Math.random() * 30), x - 1, y - 1));
    }
  }

  //Creates two entities, each with their own color, movement range, and position in the list.
  test1 = new Entity(0, 0, 20, 4, 255, 0, 0, 4);
  test2 = new Entity(0, 0, 20, 4, 0, 0, 255, 6);
  test1.move(background.get(50).get(38));
  test2.move(background.get(49).get(38));
}

void draw()
{
  //Sets background color.
  background(20, 98, 224);
  
  //Moves the highlighted hexagon to the mouse.
  moveCursor();
  
  //Sets basic left, right, down, up movement speed.
  float move = cameraZ / 90;
  
  //Increases movement speed if the user is holding shift.
  if(isShifting)
  {
    move = cameraZ / 40;
  }
 
 //Moving the user's camera if they are hitting the proper key and are inside the x-y limits of the program.
  if(moveX > 0 && cameraX + move < 4500)
  {
    cameraX += move;
    moveCursor();
  }
  else if(moveX < 0 && cameraX + move > 1000)
  {
    cameraX -= move;
    moveCursor();
  }
  if(moveY > 0 && cameraY + move < 4000)
  {
    cameraY += move;
    moveCursor();
  }
  else if(moveY < 0 && cameraY + move > 500)
  {
    cameraY -= move;
    moveCursor();
  }
  
  //Sets the camera to the specified location.
  camera(cameraX, cameraY, cameraZ, cameraX, cameraY, 0, 0, 1, 0);

  //Draws the hexagon background.
  pushMatrix();
  for(ArrayList<Hexagon> list : background)
  {
    for(Hexagon h : list)
    {
      h.display();
    }
  }
  popMatrix();

  //Draws the entities onto the hexagons.
  pushMatrix();
  test1.display();
  test2.display();
  popMatrix();
  
  //------------------------------
  
  //ensures that all the placed items are set up
  for(Box b: shownItems)
    {
      if(b.getImage() == null)
       b.displayBox();
       else
       b.setDrawings();
    }
  
  //looks for displaying just the botton or everything
  switch(state)
  {
    case 0:
    {
      boxes[0].setDrawings();
      break; 
    }
    case 1:
    {
      for(Box b : boxes)
      {
      if(b.getImage() == null)
       b.displayBox();
       else
       b.setDrawings();
      }
     break; 
    }
  }
 
 //allows the program to exit
 if(escapePressed())
 {
   exit();
 }
  //------------------------------
}

//Moves the hightlighted hexagon if the mouse is moved.
void mouseMoved()
{
  moveCursor();
}

//Zooms the camera in or out if the user scrolls.
void mouseWheel(MouseEvent event)
{
  float e = event.getCount();
  float zoom = 0;
  
  //Increases speed if the user is pressing shift.
  if(isShifting)
  {
    zoom = e * cameraZ / 10;
  }
  else
  {
    zoom = e * cameraZ / 20;
  }
  
  //Limits how close or far the user can zoom.
  if(cameraZ + zoom < 4500 && cameraZ + zoom > 500)
  {
    cameraZ += zoom;
  }

  //Updates mouse position.
  moveCursor();
}

//Hightlights the hexagon under the user's mouse.
void moveCursor()
{
  //Deselects previous hexagon if this is not the initialization of the program.
  if(mouseHex != null)
  {
    mouseHex.g -= 145;
  }
  
  List<Hexagon> choices = new ArrayList<Hexagon>();
  
  //Loops through a nine by nine square, not including hexes outside the board or the corners that should not be selected depending on if the column number is even or odd.
  for(int x = -1; x < 2; x++)
  {
    for(int y = -1; y < 2; y++)
    {
      if(listX + x < background.size() && listX + x >= 0 && listY + y < background.get(listX + x).size() && listY + y >= 0)
      {
        if(listX + 1 % 2 == 0)
        {
          if(!(x == -1 && y == -1) && !(x == 1 && y == -1))
          {
            choices.add(background.get(listX + x).get(listY + y));
          }
        }
        else
        {
          if(!(x == -1 && y == 1) && !(x == 1 && y == 1))
          {
            choices.add(background.get(listX + x).get(listY + y));
          }
        }
      }
    }
  }
  
  //Moves the cursor to the nearest hexagon of the seven options. 822.76 is approximately equal to (the window height / 2) / tan(PI / 6) - the default camera Z position.
  mouseHex = nearestHex(choices, (int) (cameraX + (mouseX - width / 2) * cameraZ / 822.76), (int) (cameraY + (mouseY - height / 2) * cameraZ / 822.76));
  mouseHex.g += 145;
}

//Activates if the user presses a certain key.
void keyPressed()
{
  //w
  if(key == 119)
  {
    moveY = -1;
  }
  //s
  if(key == 115)
  {
    moveY = 1;
  }
  //a
  if(key == 97)
  {
    moveX = -1;
  }
  //d
  if(key == 100)
  {
    moveX = 1;
  }
  if(key == CODED && keyCode == SHIFT)
  {
    isShifting = !isShifting;
  }
}

//Activates if the user releases a key.
void keyReleased()
{
  //w
  if(key == 119)
  {
    moveY = 0;
  }
  //s
  if(key == 115)
  {
    moveY = 0;
  }
  //a
  if(key == 97)
  {
    moveX = 0;
  }
  //d
  if(key == 100)
  {
    moveX = 0;
  }
}

//Manipulates entities when the user clicks.
void mouseClicked()
{
  if(mouseButton == LEFT)
  {
    if(selected == null)
    {
      selected = mouseHex.occupant;
  
      //Selecting an entity from the board.
      if(selected != null)
      {
        //Makes the entity slightly transparent.
        selected.r += 100;
        selected.g += 100;
        selected.b += 100;
        
        //Updates the shading which shows where this entity can move.
        calculateMovement();
        moveShade(145);
      }
    }
    else
    {
      //Unselecting an entity if the user clicks on it again.
      if(selected == mouseHex.occupant)
      {
        selected.r -= 100;
        selected.g -= 100;
        selected.b -= 100;
        
        //Updates movement shading.
        moveShade(-145);
        selected = null;
      }
      //Moving the entity to an unoccupied hex inside it's move range.
      else if(movable.contains(mouseHex) && mouseHex.occupant == null)
      {
        moveShade(-145);
        selected.position.occupant = null;
        selected.move(mouseHex);
        calculateMovement();
        moveShade(145);
      }
    }
  }
  //Moving an entity regardless of move range for special circumstances.
  else if(mouseButton == CENTER && selected != null && mouseHex.occupant == null)
  {
     moveShade(-145);
     selected.position.occupant = null;
     selected.move(mouseHex);
     calculateMovement();
     moveShade(145);
  }
}

//Loops through every provided hexagon option and returns the one the shortest distance away from the mouse.
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
      
      //Updates closest hex and closest hex list position.
      hex = choices.get(i);
      listX = hex.listPositionX;
      listY = hex.listPositionY;
    }
  }

  return hex;
}

//Returns the distance between two points, not including the square root to improve processing speed.
public static int distance(int x1, int y1, int x2, int y2)
{
  return (int) (Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
}

//calculates which hexagons the currently selected entity can move to.
public void calculateMovement()
{
  //Clears previously movable hexagons.
  movable.clear();
 
  //Sets the y offset to 0 if the entity is in an even column, 1 if odd.
  int yOffset = 0;
  if((listX + 1) % 2 == 0)
  {
    yOffset = 1;
  }
 
  //Loops from the entity's column to the column on the right edge of the movement range.
  for(int x = 0; x <= selected.moveRange; x++)
  {
    if(listX + x < background.size() && listX + x >= 0)
    {
      //Re-centering the y coordinate on each new even index row.
      if((listX + x) % 2 == 0)
      {
        yOffset += 1;
      }
      
      //Loops through the correct number of hexagons for each column, adding them to the list of movable hexagons.
      for(int y = yOffset + -selected.moveRange - 1; y <= selected.moveRange - x + yOffset - 1; y++)
      {
        if(listY + y < background.size() && listY + y >= 0)
        {
          movable.add(background.get(listX + x).get(listY + y));

        }
      }
    }
  }
  
  //Resetting the y offset.
  yOffset = 0;
    
  //Loops through the left hand side of the movement range. Same process as above but with some of the signs inverted to account for the negative x values.
  for(int x = -1; x >= -selected.moveRange; x--)
  {
    if(listX + x < background.size() && listX + x >= 0)
    {
      if((listX + x) % 2 == 0)
      {
        yOffset += 1;
      }
        
      for(int y = yOffset + -selected.moveRange; y <= selected.moveRange + x + yOffset; y++)
      {
        if(listY + y < background.size() && listY + y >= 0)
        {
          movable.add(background.get(listX + x).get(listY + y));
        }
      }
    }
  }
}

//Displays the hexagons the selected entity can move to as more brightly green than the others.
public void moveShade(int colorShift)
{
  for(Hexagon h : movable)
  {
    h.g += colorShift;
  }
}

//---------------------------------Troy Methods------------------------

//autofixes the mouse so the image doesn't bug out
//also ensures that only one object is set up to move
void mousePressed() 
{
  boolean anotherDragged = false;
    
   //allows for boxes to be selected in different states (no conflict)
  switch(state)
  {
    case 0:
    {
      if(boxes[0].isWithin() && state == 0)
        state = 1;
      else
      {
        for(int i = shownItems.size()-1; i >= 0; i--)
        {
          if(shownItems.get(i).isWithin() && !anotherDragged)
          {
            shownItems.get(i).setIsDragged(true);
            anotherDragged = true;
            shownItems.get(i).setColor(255);
            xOffset = mouseX - shownItems.get(i).getX();
            yOffset = mouseY - shownItems.get(i).getY();
          }
        } 
      }
     break; 
    }
   case 1:
     {
       //resets the state to 0, works like a button
       if(boxes[0].isWithin())
         state = 0;
       
      //makes the boxes white when clicked
      for(int i = boxes.length-1; i > 0; i--)
      {
       if(boxes[i].isWithin()&& !anotherDragged)
       {
         boxes[i].setIsDragged(true);
         anotherDragged = true;
         boxes[i].setColor(255);
         xOffset = mouseX - boxes[i].getX();
         yOffset = mouseY - boxes[i].getY();
       }
      }
      break; 
     }
  }
}


//sets the objects in their place when the mouse is released
void mouseReleased()
{
  switch(state)
  {
    case 0:
    {
      for(int i = 0; i < shownItems.size(); i++)
      {
        //sets up the trash can and deselects objects
        shownItems.get(i).setIsDragged(false);
        if(shownItems.get(i).getX() < boxes[0].getWidth()/4 && shownItems.get(i).getY() < boxes[0].getHeight()/4)
          {
            shownItems.remove(i);
            i--;
          }
      }
      break;
    }
    case 1:
    {
      for(int i = 1; i < boxes.length; i++)
      {
       if(boxes[i].isWithin())
       {
         boxes[i].setColor(0);
         /*X,Y coords and height and witdth and string for file*/
         //places the prototype images onto the board
         shownItems.add(new Box(boxes[i].getX(), boxes[i].getY(), boxes[i].getWidth(), boxes[i].getHeight(), boxes[i].getImage()));
         boxes[i].setX(0);
         boxes[i].setY(i*boxes[i].getWidth());
         state = 0;
       }
       boxes[i].setIsDragged(false);
      }
      break;
    }   
  }
}


//pulls the images with the mouse
void mouseDragged()
{
  switch(state)
  {
    case 0:
    {
      //pulls with accouting for offset
      for(int i = 0; i < shownItems.size(); i++)
      {
       if(shownItems.get(i).getIsDragged())
       {
         shownItems.get(i).setX(mouseX-xOffset);
         shownItems.get(i).setY(mouseY-yOffset);
       }
     }
      break;
    }
    case 1:
    {
      //same as shownItems
      for(int i = 0; i < boxes.length; i++)
      {
       if(boxes[i].getIsDragged())
       {
         boxes[i].setX(mouseX-xOffset);
         boxes[i].setY(mouseY-yOffset);
       }
      }
      break;
    }
  }
}

//kicks out of the program
boolean escapePressed() 
{
  if (keyCode == ESC) 
  {
    return true;
  } 
  return false;
}
