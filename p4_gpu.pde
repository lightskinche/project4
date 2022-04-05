// This is the provided code for Project 4.  Your main task will be to modify the
// provided .frag and .vert shader programs to create various visual effects.

// Using the scroll wheel zooms in and out.
// Pressing the space bar locks/unlocks the object's position.

// Some global variables
PShader floorShader;
PShader circle_shader;
PShader fractal_shader;
PShader image_manip_shader;
PShader bumps_shader;
PImage shell_texture;
PImage bumps_texture;

float offsetY;
float offsetX;
float zoom = -200;
boolean locked = false;
float dirY = 0;
float dirX = 0;
float time = 9;
float delta_time = 0.02;

// initialize variables and load shaders
void setup() {
  size(640, 640, P3D);
  offsetX = width/2;
  offsetY = height/2;
  noStroke();
  fill(204);

  // load some textures
  shell_texture = loadImage("data/pic_shell.jpg");
  bumps_texture = loadImage("data/pic_bumps.jpg");

  // load the shaders
  circle_shader = loadShader("data/spiral.frag", "data/spiral.vert");
  fractal_shader = loadShader("data/fractal.frag", "data/fractal.vert");
  image_manip_shader = loadShader("data/image_manip.frag", "data/image_manip.vert");
  bumps_shader = loadShader("data/bumps.frag", "data/bumps.vert");

  // floor shader
  floorShader = loadShader("data/floor.frag", "data/floor.vert");
}

void draw() {

  background(0);

  // control the scene rotation via the current mouse location
  if (!locked) {
    dirY = (mouseY / float(height) - 0.5) * 2;
    dirX = (mouseX / float(width) - 0.5) * 2;
  }

  // if the mouse is pressed, update the camera location
  if (mousePressed) {
    offsetY += (mouseY - pmouseY);
    offsetX += (mouseX - pmouseX);
  }

  // create a single directional light
  directionalLight(200, 200, 200, 0, 0, -1);

  // translate and rotate all objects to simulate a camera
  // NOTE: processing +y points DOWN
  translate(offsetX, offsetY, zoom);
  rotateY(-dirX * 1.5);
  rotateX(dirY);
  
  // Draw a floor plane with the default shader
  shader(floorShader);
  beginShape();
  vertex(-300, 300, -400);
  vertex( 300, 300, -400);
  vertex( 300, 300, 200);
  vertex(-300, 300, 200);
  endShape();
  

  // Use the fractal shader
  shader(fractal_shader);
  
  // pass the parameters cx and cy to the fractal shader
  float r = 0.07;
  float mx = 0.443;
  float my = -0.14;
  float cx = mx + r * sin(time);
  float cy = my + r * cos(time);
  fractal_shader.set ("cx", cx);
  fractal_shader.set ("cy", cy);
  
  textureMode(NORMAL);
  beginShape();
  vertex(50, 50, -300, 0, 0);
  vertex(300, 50, -300, 1, 0);
  vertex(300, 300, -300, 1, 1);
  vertex(50, 300, -300, 0, 1);
  endShape();

  // Use the image manipulation shader
  image_manip_shader.set("my_texture", shell_texture);
  shader(image_manip_shader);
  textureMode(NORMAL);
  beginShape();
  texture(shell_texture);
  vertex(-300, 50, 100, 0, 0);
  vertex(-50, 50, 100, 1, 0);
  vertex(-50, 300, 100, 1, 1);
  vertex(-300, 300, 100, 0, 1);
  endShape();
  
  // Use the bumps shader
  shader(bumps_shader);
  pushMatrix();
  translate (-300, 0, -300);
  beginShape();
  texture(bumps_texture);
  vertex(50, 50, 0, 0, 0);
  vertex(300, 50, 0, 1, 0);
  vertex(300, 300, 0, 1, 1);
  vertex(50, 300, 0, 0, 1);
  endShape();
  popMatrix();

  // Use the circles shader
  shader(circle_shader);
  beginShape();
  vertex(50, 50, 100, 0, 0);
  vertex(300, 50, 100, 1, 0);
  vertex(300, 300, 100, 1, 1);
  vertex(50, 300, 100, 0, 1);
  endShape();

  // update the time variable
  time += delta_time;
}

void keyPressed() {
  if (key == ' ') {
    locked = !locked;
  }
}

void mouseWheel(MouseEvent event) {
 zoom += event.getCount() * 12.0;
}
