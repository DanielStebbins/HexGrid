int xOffset = 0;
int yOffset = 0;
PImage[] images = new PImage[5];
color col = color(216);
 /*X,Y coords and height and witdth and string for file*/
Box boxes[] = new Box[5];
boolean dragging = false;
int state;
ArrayList<Box> shownItems = new ArrayList<Box>();


void setup() {  // setup() runs once
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
}

//height width are keywords, mouseX, mouseY
void draw() {  // draw() loops forever, until stopped
  background(col);
  
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
}

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
