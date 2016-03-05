int coords[][] = new int[17][4];
int posX = 0, posY = 0;
int origw, origh;
int Min, Max;

PImage img;
PImage orig;
PImage orig2;

boolean selects[] = new boolean[17];
boolean open = false;

void setup()
{
  size(800, 600);
  clean();
  interfaces();
}

void draw()
{
  if (img != null)
  {
    interfaces();
    image(img, posX, posY);
  }
}

void clean()
{
   for (int i = 0; i < selects.length; i++)
    selects[i] = false; 
}

/* Interface */
void interfaces()
{
  stroke(#607d8b);
  fill(#607d8b);
  // box C
  rect(100, 0, 600, 500);
  fill(#37474f);

  // panel A
  rect(0,0, 100, 600);
  // panel B
  rect(700,0, 100, 600);
  // panel D
  rect(100,500, 600, 100);
  
  // Buttons panel C
  // Open
  initialize_button(150, 525, 100, 50, #283593, "Open", 1, selects[1]);
  // Save
  initialize_button(325, 525, 100, 50, #283593, "Save", 2, selects[2]);
  // Reset
  initialize_button(500, 525, 100, 50, #283593, "Reset", 3, selects[3]);
  
  //Buttons panel A
  // RGB
  initialize_button(10, 25, 75, 50, #d32f2f, "RGB", 4, selects[4]);
  // R
  initialize_button(25, 100, 35, 35, #d32f2f, "R", 5, selects[5]);
  // G
  initialize_button(25, 175, 35, 35, #d32f2f, "G", 6, selects[6]);
  // B
  initialize_button(25, 250, 35, 35, #d32f2f, "B", 7, selects[7]);

  // Salt
  initialize_button(5, 325, 90, 35, #d32f2f, "Salt", 15, selects[15]);
  // Pepper
  initialize_button(5, 375, 90, 35, #d32f2f, "Pepper", 16, selects[16]);

  //Buttons panel B
  /* median */
  // 3
  initialize_button(725, 25, 35, 35, #2e7d32, "3", 8, selects[8]);
  // 5
  initialize_button(725, 75, 35, 35, #2e7d32, "5", 9, selects[9]);
  // 7
  initialize_button(725, 125, 35, 35, #2e7d32, "7", 10, selects[10]);

  // YUV
  initialize_button(710, 180, 75, 50, #2e7d32, "YUV", 11, selects[11]);
  // Y
  initialize_button(725, 250, 35, 35, #2e7d32, "Y", 12, selects[12]);
  // U
  initialize_button(725, 300, 35, 35, #2e7d32, "U", 13, selects[13]);
  // V
  initialize_button(725, 350, 35, 35, #2e7d32, "V", 14, selects[14]);
}

void initialize_button(int x, int y, int dx, int dy, color c, String text, int button, boolean selected)
{
    if (!open && button != 1)
      c = 128;
    if (selected)
      fill(#0091ea);
    else
      fill(c);
    rect(x, y, dx, dy);
    fill(255);
    text(text, x+dx/2-dx/6, y+dy/2-dy/6, dx, dy);

    coords[button][0] = x;
    coords[button][1] = x+dx;
    coords[button][2] = y;
    coords[button][3] = y+dy;
}

void mousePressed()
{
  for (int i = 0; i < coords.length; i++)
  {
    if(mouseButton == LEFT &&
      mouseX >= coords[i][0] && mouseX <= coords[i][1] &&
      mouseY >= coords[i][2] && mouseY <= coords[i][3])
    {
      if (open)
      {
        OnClick(i);
        if ((i > 3 && i < 8) || (i > 10 && i < 15))
        {
          clean();
          selects[i] = true;
        }
      }
      else
        if (i == 1)
        {
          OnClick(i);
          open = true;
        }
    }
  }
}

void OnClick(int btn)
{
  switch(btn)
  {
    case 1: open(); break;
    case 2: save(); break;
    case 3: reset(); break;
    case 4: RGB("RGB"); break;
    case 5: RGB("R"); break;
    case 6: RGB("G"); break;
    case 7: RGB("B"); break;
    case 8: median(3); break;
    case 9: median(5); break;
    case 10: median(7); break;
    case 11: YUV("YUV"); break;
    case 12: YUV("Y"); break;
    case 13: YUV("U"); break;
    case 14: YUV("V"); break;
    case 15: salt_pepper(true); break;
    case 16: salt_pepper(false); break;
  }
}

/* Functions */
void scaling()
{
  int w = 500;
  int h = 500;
  
  if (img.width > img.height)
  {
    w = 600;
    h = (600 * img.height) / img.width;
  }
  else if (img.width < img.height)
  {
    h = 500;
    w = (500 * img.width) / img.height;
  }

  img.resize(w, h);
  orig.resize(w, h);
  posX = 100+(600-w)/2;
  posY = (500-h)/2; 
}

/* OPEN */
void open()
{
  selectInput("Select file", "fileSelected"); 
}

void fileSelected(File selection)
{
   if (selection == null)
    println("Window was closed or the user hit cancel.");
  else
  {
    String path = selection.getAbsolutePath().toLowerCase();
    if (path.substring(path.length()-4 ).equals(".gif") ||
    path.substring(path.length()-4 ).equals(".png") ||
    path.substring(path.length()-4 ).equals(".tga") ||
    path.substring(path.length()-5 ).equals(".jpeg") ||
    path.substring(path.length()-4 ).equals(".jpg")
    )
    {
      clean();
      img = loadImage(selection.getAbsolutePath());
      orig = img.copy();
      orig2 = img.copy();
      origw = orig2.width;
      origh = orig2.height;
/*
      Min = getMin();
      println(Min);
      
      Max = getMax();
      println(Max);
*/
      scaling();
    }
    else
      println("Il file che hai scelto non è un immagine!");
  }
}

/* Reset */
void reset()
{
  clean();
  img = orig2.copy();
  orig = orig2.copy();
  scaling();
}

/* Save */
void save()
{
  selectOutput("Select a file to write to:", "fileSelectedO");
}

void fileSelectedO(File selection)
{
  if (selection == null)
    println("Window was closed or the user hit cancel.");
  else
  {
    img.resize(origw, origh);
    img.save(savePath(selection.getAbsolutePath()));
    scaling();
  }
}

/* RGB, R, G, B */
void RGB(String mode)
{
  PImage tmp;
  img = orig.copy();
  tmp = img.copy();
  tmp.loadPixels();

  if (mode == "RGB")
  {
    scaling();
    return;
  }

  if(mode == "R")
  {
    for (int i = 0; i < orig.pixels.length; i++)
    {
      int r = int(red(orig.pixels[i]));
      tmp.pixels[i] = color(r);
    }
  }
  else if(mode == "G")
  {
    for (int i = 0; i < orig.pixels.length; i++)
    {
      int g = int(green(orig.pixels[i]));
      tmp.pixels[i] = color(g);
    }    
  }
  else if(mode == "B")
  {
    for (int i = 0; i < orig.pixels.length; i++)
    {
      int b = int(blue(orig.pixels[i]));
      tmp.pixels[i] = color(b);
    }    
  }
  img = tmp.copy();
  scaling();
}

/* YUV, Y, U, V */
void YUV(String mode)
{
  PImage tmp;
  tmp = orig.copy();
  tmp.loadPixels();
  
  if (mode == "YUV")
  {
    for (int i = 0; i < orig.pixels.length; i++)
    {
      int r = int(red(orig.pixels[i]));
      int g = int(green(orig.pixels[i]));
      int b = int(blue(orig.pixels[i]));
      int y = int(0.3*float(r) +  0.6*float(g) + 0.1*float(b));
      int u,v;
      //u = int(((b-y)/2) + 114.75);
      //v = int(((r-y)/2) + 111.57);
      u = int(r * -.168736 + g * -.331264 + b *  .500000 + 128);
      v = int(r *  .500000 + g * -.418688 + b * -.081312 + 128);
      tmp.pixels[i] = color(y, u, v);
    }
  }
  else if(mode == "Y")
  {
    for (int i = 0; i < orig.pixels.length; i++)
    {
      int r = int(red(orig.pixels[i]));
      int g = int(green(orig.pixels[i]));
      int b = int(blue(orig.pixels[i]));
      int y = int(0.3*float(r) +  0.6*float(g) + 0.1*float(b));
      tmp.pixels[i] = color(y);
    }
  }
  else if(mode == "U")
  {
    for (int i = 0; i < orig.pixels.length; i++)
    {
      int r = int(red(orig.pixels[i]));
      int g = int(green(orig.pixels[i]));
      int b = int(blue(orig.pixels[i]));
      int y = int(0.3*float(r) +  0.6*float(g) + 0.1*float(b));
      //int u = int(((b-y)/2) + 114.75);
      int u = int(r * -.168736 + g * -.331264 + b *  .500000 + 128);
      tmp.pixels[i] = color(u);
    }
  }
  else if(mode == "V")
  {
    for (int i = 0; i < orig.pixels.length; i++)
    {
      int r = int(red(orig.pixels[i]));
      int g = int(green(orig.pixels[i]));
      int b = int(blue(orig.pixels[i]));
      int y = int(0.3*float(r) +  0.6*float(g) + 0.1*float(b));
      //int v = int(((r-y)/2) + 111.57);
      int v = int(r *  .500000 + g * -.418688 + b * -.081312 + 128);
      tmp.pixels[i] = color(v);
    }
  }

  tmp.updatePixels();
  img = tmp.copy();
  scaling();
}

/* Salt & Pepper */
void salt_pepper(boolean salt_pepper)
{
  int X = 0, C = 0;
  PImage tmp, tmp2;
  tmp = img.copy();
  tmp2 = orig.copy();
  tmp.loadPixels();
  tmp2.loadPixels();
  
  int rand = 0;
  
  if (salt_pepper) // salt
  {
    X = 3;
    C = 255;
  }
  else // pepper
    X = 5;

  for (int i = 0; i < tmp.pixels.length; i++)
  {
    rand = int(random(100)+1);
    if (rand >= 1 && rand <= X)
    {
       tmp.pixels[i] = color(C);
       tmp2.pixels[i] = color(C);
    }
  }

  tmp.updatePixels();
  tmp2.updatePixels();
  img = tmp.copy();
  orig = tmp2.copy();
  scaling();
}

/* Median */
void median(int p)
{
  img = medianx(p, img).copy();
  orig = medianx(p, orig).copy();
  
  img.updatePixels();
  orig.updatePixels();
}

PImage medianx(int p, PImage timg2)
{
  int offset = p/2;

  PImage timg = timg2.copy();

  PImage t1, t2, t3;
  t1 = timg.copy();
  t2 = timg.copy();
  t3 = timg.copy();

  PImage tmp1, tmp2, tmp3;
  float mediano1, mediano2, mediano3;
  float[] tmpR, tmpG, tmpB;
  
  timg.loadPixels();

  for (int i = 0; i < timg.width; i++)
  {
    for(int j = 0; j < timg.height; j++)
    {
       tmp1 = timg.get( max(i-offset,0) , max(j-offset,0) , min(p,timg.width-i) , min(p,timg.height-j) );
       tmp2 = timg.get( max(i-offset,0) , max(j-offset,0) , min(p,timg.width-i) , min(p,timg.height-j) );
       tmp3 = timg.get( max(i-offset,0) , max(j-offset,0) , min(p,timg.width-i) , min(p,timg.height-j) );

       tmp1.loadPixels();
       tmp2.loadPixels();
       tmp3.loadPixels();

       int len = tmp1.pixels.length;

       //casting in float
       tmpR = new float[len];
       tmpG = new float[len];
       tmpB = new float[len];

       for(int k = 0; k < len; k++)
       {
         tmpR[k] = red(tmp1.pixels[k]);
         tmpG[k] = green(tmp2.pixels[k]);
         tmpB[k] = blue(tmp3.pixels[k]);
       }
       
       tmpR = sort(tmpR);
       tmpG = sort(tmpG);
       tmpB = sort(tmpB);

       if (len % 2 == 1)
       {
         mediano1 = tmpR[len/2];
         mediano2 = tmpG[len/2];
         mediano3 = tmpB[len/2];
       }
       else
       {
         mediano1 = (tmpR[len/2-1] + tmpR[len/2])/2;
         mediano2 = (tmpG[len/2-1] + tmpG[len/2])/2;
         mediano3 = (tmpB[len/2-1] + tmpB[len/2])/2;
       }

       t1.set(i, j, color(mediano1));
       t2.set(i, j, color(mediano2));
       t3.set(i, j, color(mediano3));
    }
  }
  
  for (int i = 0; i < timg.pixels.length; i++)
    timg.pixels[i] = color(int(red(t1.pixels[i])), int(green(t2.pixels[i])), int(blue(t3.pixels[i])));

  timg.updatePixels();
  return timg;
}

int getMin()
{
  int min = int(green(img.pixels[0]));
  for (int i = 0; i < img.pixels.length; i++)
    if (green(img.pixels[i]) < min) min = int(green(img.pixels[i]));
  return min;
}

int getMax()
{
  int max = int(green(img.pixels[0]));
  for (int i = 0; i < img.pixels.length; i++)
    if (green(img.pixels[i]) > max) max = int(green(img.pixels[i]));
  return max;
}

int Normalize(int v) { return 255 * ((v - Min) / (Max - Min)); }