Board board;
Menu menu;
int gridX = 25, gridY = 25, px = 25, offset = (700 - gridY * px) / 2;

void setup() {
 size(1050, 700);
 board = new Board(gridX, gridY, px, offset);
 menu = new Menu(board, gridY * px + 700 - gridY * px, (700 - gridY * px) / 2, 300, 600, 50);
 menu.display();
 board.display();
}

void draw() {
 board.listen();
 menu.listen();
}