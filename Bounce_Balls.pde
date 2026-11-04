
import processing.sound.*;

SoundFile muziek;

Bal[] ballen = new Bal[4];

int aantalBallen = 3;
int punten = 0;

int platformX = 150;
int platformY = 400;
int platformBreedte = 120;

void setup() {
  size(400, 500);

  try {
    muziek = new SoundFile(this, "muziek.mp3");
    muziek.loop();
  } catch (Exception e) {
    println("Muziek kon niet worden geladen: " + e);
  }

  // De vier ballen maken
  ballen[0] = new Bal(100, 50, 2, -9, color(255, 70, 70), 30);
  ballen[1] = new Bal(200, 100, -2, 0, color(70, 150, 255), 45);
  ballen[2] = new Bal(300, 150, 1, 0, color(255, 220, 50), 60);
  ballen[3] = new Bal(150, 80, 3, 0, color(200, 70, 255), 45);
}

void draw() {
  // Achtergrond
  background(20, 30, 80);

  // Extra bal bij meer dan 50 punten
  if (punten > 50) {
    aantalBallen = 4;
  }

  // Maan
  fill(255, 240, 150);
  ellipse(340, 70, 50, 50);

  // Sterren
  fill(255);
  ellipse(50, 80, 4, 4);
  ellipse(150, 120, 4, 4);
  ellipse(250, 50, 4, 4);
  ellipse(300, 180, 4, 4);
  ellipse(80, 250, 4, 4);

  // Platform bewegen
  if (keyPressed && (key == 'a' || key == 'A')) {
    platformX -= 8;
  }

  if (keyPressed && (key == 'd' || key == 'D')) {
    platformX += 8;
  }

  platformX = constrain(platformX, 0, width - platformBreedte);

  // Ballen bewegen
  for (int i = 0; i < aantalBallen; i++) {
    if (ballen[i].bewegen()) {
      punten++;
    }

    ballen[i].tekenen();
  }

  // Platform tekenen
  fill(80, 200, 120);
  rect(platformX, platformY, platformBreedte, 15);

  // Punten tekenen
  fill(255);
  textSize(25);
  text("Punten: " + punten, 20, 35);
}


// CLASS BAL
class Bal {
  float x;
  float y;
  float snelheidX;
  float snelheidY;
  float grootte;
  color kleur;

  Bal(float startX, float startY, float sx, float sy, color k, float g) {
    x = startX;
    y = startY;
    snelheidX = sx;
    snelheidY = sy;
    kleur = k;
    grootte = g;
  }

  boolean bewegen() {
    snelheidY += 0.3;
    y += snelheidY;
    x += snelheidX;

    boolean geraakt = false;

    // Botsing met platform
    if (snelheidY > 0 &&
        y + grootte / 2 >= platformY &&
        y - grootte / 2 < platformY &&
        x + grootte / 2 > platformX &&
        x - grootte / 2 < platformX + platformBreedte) {

      y = platformY - grootte / 2;
      snelheidY = -9;
      snelheidX = (x - (platformX + platformBreedte / 2)) / 8;
      geraakt = true;
    }

    // Zijkanten
    if (x < grootte / 2) {
      x = grootte / 2;
      snelheidX = abs(snelheidX);
    }

    if (x > width - grootte / 2) {
      x = width - grootte / 2;
      snelheidX = -abs(snelheidX);
    }

    // Bovenkant
    if (y < grootte / 2) {
      y = grootte / 2;
      snelheidY = abs(snelheidY);
    }  

    // Bal opnieuw laten beginnen
    if (y > height + grootte) {
      y = 50;
      x = random(30, width - 30);
      snelheidX = random(-3, 3);
      snelheidY = 0;
    }

    return geraakt;
  }

  void tekenen() {
    fill(kleur);
    ellipse(x, y, grootte, grootte);
  }
}
