using Toybox.System as Sys;
using Toybox.Complications as Complications;

public var bboxes = [];
public var boundingBoxes = [];

public function checkBoundingBoxes(points) {

  // iterate through each bounding box
  for(var i=0;i<boundingBoxes.size();i++) {

    var currentBounds = boundingBoxes[i];
    Sys.println("checking bounding box: " + currentBounds["label"]);

    // check if the current bounding box has been hit,
    // if so, return the corresponding complication
    if (checkBoundsForComplication(points,currentBounds["bounds"])) {
        return currentBounds["complicationId"];
    }

  }

  // we didn't hit a bounding box
  return false;

}

// true if the points are contained within this boundingBox
public function checkBoundsForComplication(points,boundingBox) {
  return circContains(points,boundingBox[0],boundingBox[1],boundingBox[2]);
}


public function circContains(points, circle_x, circle_y, rad) {
    var x = points[0];
    var y = points[1];

    if ((x - circle_x) * (x - circle_x) + (y - circle_y) * (y - circle_y) <= rad * rad) {
      return true;
    } else {
      return false;
    }
}
