import processing.pdf.*;





class myBlock {
  int x, y;
  int size = 20;
  int isInSolution = 0;
  int isRight = 0;
  int isBottom = 0;
}

class pairOfInt {
  int x, y;
}


void setup() {
  //general setup
  size(800, 800, PDF, "maze.pdf"); // save to maze.pdf
  //create a maze
  square(200, 200, 400);// so each block small block is 20x20

  myBlock[][] myMaze = new myBlock[20][20];
  myMaze = initializeMaze(myMaze);
  pairOfInt entranceExit = setupEntranceAndExit();
  //create a solution
  int maxPermutation = 3; //allow max number of times for the solution to go up or down
  myMaze = setUpSolution(myMaze, maxPermutation, entranceExit);

  myMaze = setUpTexture(myMaze);
  
  
  
  drawMaze(myMaze);
  
  drawEntranceExit(entranceExit);

  printMaze(myMaze);
}


void drawEntranceExit(pairOfInt entranceExit){
  stroke(255);
  line(200, 200 + entranceExit.x * 20, 200, 200 + entranceExit.x * 20 + 20);
  line(600, 200 + entranceExit.y * 20, 600, 200 + entranceExit.y * 20 + 20); 
}



void drawMaze(myBlock[][] myMaze){
  for(int i = 0; i < 20; i++){
    for(int t = 0; t < 20; t++){
      drawBlock(myMaze[i][t]);
    }
  }
}

void drawBlock(myBlock block){
  if (block.isRight == 1){
    line(200 + block.x*20 +20, 200 + block.y*20, 200 + block.x*20 +20, 200 + block.y*20 +20); 
  }
  
  if (block.isBottom == 1){
    line(200 + block.x*20, 200 + block.y*20 +20, 200 + block.x*20 +20, 200 + block.y*20 +20); 
  }
  
}


void printMaze(myBlock[][] myMaze) {
  for(int i = 0; i < 20; i++){
    for(int t = 0; t < 20; t++){
      printBlock(myMaze[i][t]);
    }
  }
}

void printBlock(myBlock block){
  println("coords: ", block.x, " ", block.y);
  println("isRight: " , block.isRight);
  println("isBottom: ", block.isBottom);
  
}



myBlock[][] initializeMaze(myBlock[][] myMaze) {
  

  for (int i = 0; i < 20; i++) {
    for (int t = 0; t < 20; t++) {
      myBlock emptyBlock = new myBlock();
      emptyBlock.x = i;
      emptyBlock.y = t;
      myMaze[i][t] = emptyBlock;
    }
  }

  return myMaze;
}







//add texture to the map, consider if the current block is in solution or not
//if the block is in solution, we will not add a wall to block it.
myBlock[][] setUpTexture(myBlock[][] myMaze) {

  for (int i = 0; i < 20; i ++ ) {
    for (int y = 0; y < 20; y++) {
      if (myMaze[i][y].isInSolution == 1) {
        if (i == 19 || myMaze[i+1][y].isInSolution == 0) {
          int z = get25Chance();
          if (z == 1) {
            myMaze[i][y].isRight = 1;//there is no solution block on the left so it is possible to get a wall
          }
        }

        if (y == 19 || myMaze[i][y+1].isInSolution == 0) {
          int z = get25Chance();
          if (z == 1) {
            myMaze[i][y].isBottom = 1;//no solution block at the bottom so it is possible to get a wall there
          }
        }
      } else {
        int a = get25Chance();
        if (a == 1) {
          myMaze[i][y].isRight = 1;//there is a wall on the left of this block
        }
        int b = get25Chance();
        if (b == 1) {
          myMaze[i][y].isBottom = 1;// a wall at the bottom of this block
        }
      }
    }
  }



  return myMaze;
}
//helper function to roll 25 chance
int get25Chance() {
  float r = random(100);
  if (r <25) {
    return 1;
  }
  return 0;
}

//to setup solution so that it is randomize, we need some permutation on the path, currently there is a bug where
//it might reach a corner and goes back out and the corner is considered to be in the path of the solution
myBlock[][] setUpSolution(myBlock[][] myMaze, int maxPermutation, pairOfInt entranceExit) {

  int currentX = 0;
  int currentY = entranceExit.x;

  myMaze[currentX][currentY].isInSolution = 1;


  while (currentX != 19 && currentY != entranceExit.y) {
    if (maxPermutation > 0) {
      float r = random(100);
      if (r < 5) {
        maxPermutation --;
        if (currentY == 0) {
          currentY = 1;
          myMaze[currentX][currentY].isInSolution = 1;
        }
        if (currentY == 19) {
          currentY = 18;
          myMaze[currentX][currentY].isInSolution = 1;
        }
        if (currentY < 19 && currentX > 0) {
          float y = random(100);
          if (y < 50) {
            currentY --;
            myMaze[currentX][currentY].isInSolution = 1;
          } else {
            currentY ++;
            myMaze[currentX][currentY].isInSolution = 1;
          }
        }
      }

      if ( currentY < entranceExit.y) {
        currentY ++;
        myMaze[currentX][currentY].isInSolution = 1;
      }
      if (currentY > entranceExit.y) {
        currentY --;
        myMaze[currentX][currentY].isInSolution = 1;
      }

      if (currentY == entranceExit.y) {
        currentX ++;
        myMaze[currentX][currentY].isInSolution = 1;
      }
    }
  }


  return myMaze;
}



pairOfInt setupEntranceAndExit() {//entrance on right side, exit on the left with random y coords.
  int entranceY = floor(random(20));
  int exitY = floor(random(20));

  pairOfInt toReturn = new pairOfInt();

  toReturn.x = entranceY;
  toReturn.y = exitY;

  return toReturn;
}
