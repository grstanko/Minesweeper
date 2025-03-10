
void setup() {
  size(1020, 1020);
  setup_board();
}
int flags;
void setup_board() {
  for (int iy = 0; iy < cells.length; iy++) {
    for (int ix = 0; ix < cells.length; ix++) {
      cells[iy][ix] = new Cell();
    }
  }
  for (int i = 0; i < 750; i++) {
    int x = (int)(Math.random()*100);
    int y = (int)(Math.random()*100);
    if (cells[y][x].is_bomb) { i--; continue; }
    else cells[y][x].is_bomb = true;
  }
  for (int iy = 0; iy < cells.length; iy++) {
    for (int ix = 0; ix < cells[iy].length; ix++) {
      Cell xy;
      try {
        xy = cells[iy-1][ix-1];
      } catch (Exception e) {xy = null;}
      Cell y;
      try {
        y = cells[iy-1][ix];
      } catch (Exception e) {y = null;}
      Cell Xy;
      try {
        Xy = cells[iy-1][ix+1];
      } catch (Exception e) {Xy = null;}
      Cell x;
      try {
        x = cells[iy][ix-1];
      } catch (Exception e) {x = null;}
      Cell X;
      try {
        X = cells[iy][ix+1];
      } catch (Exception e) {X = null;}
      Cell xY;
      try {
        xY = cells[iy+1][ix-1];
      } catch (Exception e) {xY = null;}
      Cell Y;
      try {
        Y = cells[iy+1][ix];
      } catch (Exception e) {Y = null;}
      Cell XY;
      try {
        XY = cells[iy+1][ix+1];
      } catch (Exception e) {XY = null;}
      cells[iy][ix].xy = xy;
      cells[iy][ix].y = y;
      cells[iy][ix].Xy = Xy;
      cells[iy][ix].x = x;
      cells[iy][ix].X = X;
      cells[iy][ix].xY = xY;
      cells[iy][ix].Y = Y;
      cells[iy][ix].XY = XY;
    }
  }
}

final int BOX_DIM = 10;
final int PAD = 10;


Cell[][] 
  cells = new Cell[100][100];

void draw() {
  background(#999999);
  fill(#00FF00);
  text(flags + " / " + 750, 10, 10);
  cells[0][0].draw(0, 0, 0, 0);
}

class Cell {
  boolean is_bomb;
  boolean is_revealed;
  boolean is_flagged;
  public Cell xy, y, Xy, x, X, xY, Y, XY;
  // xy  y Xy
  // x CC  X
  // xY  Y XY

  
  void draw(int bx, int by, int ix, int iy) {
    fill(is_revealed ? #CCCCCC : #FFFFFF);
    rect(PAD+bx+ix*BOX_DIM,PAD+by+iy*BOX_DIM, BOX_DIM, BOX_DIM);
    fill(#FF0000);
    if (is_flagged) {
              text("F", PAD+bx+ix*BOX_DIM, PAD*2+by+iy*BOX_DIM);

    }
    if (is_revealed) {
      if (is_bomb) {
        text("B", PAD+bx+ix*BOX_DIM, PAD*2+by+iy*BOX_DIM);
      } else {
        int c = count();
        if (c == 0) {} else {
        text(count(), PAD+bx+ix*BOX_DIM, PAD*2+by+iy*BOX_DIM);}
      }
    }
      if (Y != null) {Y.draw(bx, by, ix, iy+1); }
      if ((iy == 0) && (X != null)) X.draw(bx, by, ix+1, iy); 
  }
  void reveal() {
    if (is_bomb) end_game();
    is_revealed = true;
    if (count() == 0) {
      if (X!=null && !X.is_revealed) X.reveal();
      if (Y!=null && !Y.is_revealed) Y.reveal();
      if (x!=null && !x.is_revealed) x.reveal();
      if (y!=null && !y.is_revealed) y.reveal();
    }
  }
  int count() {
    int count = 0;
    if (xy != null && xy.is_bomb) count++;
    if (y != null && y.is_bomb) count++;
    if (Xy != null && Xy.is_bomb) count++;
    if (x != null && x.is_bomb) count++;
    if (X != null && X.is_bomb) count++;
    if (xY != null && xY.is_bomb) count++;
    if (Y != null && Y.is_bomb) count++;
    if (XY != null && XY.is_bomb) count++;
    return count;
  }
  boolean all_flagged() {
    int fcount = 0;
    if (xy != null && xy.is_flagged) fcount++;
    if (y != null && y.is_flagged) fcount++;
    if (Xy != null && Xy.is_flagged) fcount++;
    if (x != null && x.is_flagged) fcount++;
    if (X != null && X.is_flagged) fcount++;
    if (xY != null && xY.is_flagged) fcount++;
    if (Y != null && Y.is_flagged) fcount++;
    if (XY != null && XY.is_flagged) fcount++;
    return fcount == count();
  }
  void reveal_around() {
    if (xy != null && !xy.is_flagged) xy.reveal();
    if (y != null && !y.is_flagged) y.reveal();
    if (Xy != null && !Xy.is_flagged) Xy.reveal();
    if (x != null && !x.is_flagged) x.reveal();
    if (X != null && !X.is_flagged) X.reveal();
    if (xY != null && !xY.is_flagged) xY.reveal();
    if (Y != null && !Y.is_flagged) Y.reveal();
    if (XY != null && !XY.is_flagged) XY.reveal();
  }
}

void end_game() {
  text("You lost", 0, 0);
  noLoop();
}
 
interface Difficulty {
  int width();
  int height();
  int bomb_count();
  void display();
}
class Easy implements Difficulty {
  public Easy() {}
  int width() { return 100; }
  int height() { return 100; }
  int bomb_count() { return 750; }
  void display() {}
}
void mouseReleased() {
  int x = (mouseX-PAD)/BOX_DIM;
  int y = (mouseY-PAD)/BOX_DIM;
  if (x < 0 || x > 99) return;
  if (y < 0 || y > 99) return;
  System.out.println("2");
  if (mouseButton == LEFT) {
    cells[y][x].reveal();
  } else if (mouseButton ==RIGHT) {
    cells[y][x].is_flagged = !cells[y][x].is_flagged;
    flags += cells[y][x].is_flagged ? 1 : 0;
  } else if (mouseButton == CENTER) {
    if (cells[y][x].all_flagged())
      cells[y][x].reveal_around();
  }
}
