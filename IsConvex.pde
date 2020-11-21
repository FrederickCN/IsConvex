// https://docs.google.com/presentation/d/1Z2wNwvV24nIxRbhFieR48Ezfmx6kaO3gJb7GdrtLJRo/edit?usp=sharing
// Author: Tingzhao Wang
// Instructor: Norm Krumpe

Polygon poly;

void setup() {
  size(800, 600);
  poly = new Polygon(5);
  poly.draw();
  println(poly.isConvex());
}

void draw() {
}

void mousePressed() {
  poly.addPoint(mouseX, mouseY);
  poly.draw();
}

void keyPressed() {
  if (key == 'c') {
    poly = new Polygon(0);
    poly.draw();
  }
}

class Polygon {
  ArrayList<PVector> points;
  Polygon(int numberOfPoints) {
    points = new ArrayList<PVector>();
    for (int i = 0; i < numberOfPoints; i++) {
      points.add(new PVector(random(width), random(height)));
    }
  }

  boolean isConvex() {
    for (int i = 0; i < points.size(); i++) {
      PVector p1 = points.get(i);
      PVector p2 = points.get((i+1) % points.size());
      int left = 0, right = 0; //<>//
      for (int j = 0; j < points.size(); j++) { //<>//
        if (j != i && j != (i+1) % points.size()) { //<>//
          if (isLeft(p1, p2, points.get(j))) { //<>//
            left++; //<>//
          } else { //<>//
            right++; //<>//
          } //<>//
        } //<>//
      } //<>//
      if (left != 0 && right != 0) { //<>//
        println(left + "  ---  " + right + "  ---  " + i + "  ---  " + (i+1) % points.size()); //<>//
        return false; //<>//
      } //<>//
    } //<>//
    return true;
  }

  boolean isLeft(PVector wallPointA, PVector wallPointB, PVector checkedPoint) {
    float pos = (checkedPoint.x - wallPointA.x)*(wallPointB.y - wallPointA.y) - 
            (checkedPoint.y - wallPointA.y)*(wallPointB.x - wallPointA.x);
    return pos < 0;
  }

  void draw() {
    background(0);
    if(points.size() == 0) {
      textSize(20);
      text("Press c to clear and left click to add point", 10, 580);
      return;
    }
    stroke(255, 255, 0);
    strokeWeight(4);

    for (int i = 0; i < points.size() - 1; i++) {
      PVector start = points.get(i);
      PVector end = points.get(i + 1);      
      line(start.x, start.y, end.x, end.y);
    }

    PVector start = points.get(0);
    PVector end = points.get(points.size() - 1);      
    line(start.x, start.y, end.x, end.y);


    stroke(0, 255, 0);
    strokeWeight(10);
    for (PVector p : points) {
      point(p.x, p.y);
    }
    textSize(32);
    if(isConvex() && points.size() > 2) {
      text("convex", 10, 30);
    } else if(points.size() > 2) {
      text("concave", 10, 30);
    }
    textSize(20);
    text("Press c to clear and left click to add point", 10, 580);
    
  }

  int getNearestPointIndex(float x, float y, ArrayList<PVector> points) {
    double min = getEuclidean(x, y, points.get(0));
    int minIndex = 0;
    for (int i = 1; i < points.size(); i++) {
      if (getEuclidean(x, y, points.get(i)) < min) {
        minIndex = i;
        min = getEuclidean(x, y, points.get(i));
      }
    }
    return minIndex;
  }

  double getEuclidean(float x, float y, PVector mp) {
    double distance = Math.sqrt((x - mp.x)*(x - mp.x) + (y - mp.y)*(y - mp.y));
    return distance;
  }

  void addPoint(float x, float y) {
    points.add(new PVector(x, y));
  }
}
