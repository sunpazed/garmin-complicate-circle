using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Timer as Timer;
using Toybox.Complications as Complications;

enum {
  SCREEN_SHAPE_CIRC = 0x000001,
  SCREEN_SHAPE_SEMICIRC = 0x000002,
  SCREEN_SHAPE_RECT = 0x000003,
  SCREEN_SHAPE_SEMI_OCTAGON = 0x000004
}

public class WatchView extends Ui.WatchFace {

  // globals for devices width and height
  var dw = 0;
  var dh = 0;

  function initialize() {
   Ui.WatchFace.initialize();
  }

  function onLayout(dc) {

    // w,h of canvas
    dw = dc.getWidth();
    dh = dc.getHeight();

    // define the global bounding boxes
    defineBoundingBoxes(dc);

  }

  function onUpdate(dc) {

    // clear the screen
    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    dc.clear();

    // grab time objects
    var clockTime = Sys.getClockTime();

    // define time, day, month variables
    var hour = clockTime.hour;
    var minute = clockTime.min < 10 ? "0" + clockTime.min : clockTime.min;
    var font = Gfx.FONT_SYSTEM_NUMBER_HOT;
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    dc.drawText(dw/2,dh/2-(dc.getFontHeight(font)/2),font,hour.toString()+":"+minute.toString(),Gfx.TEXT_JUSTIFY_CENTER);

    // draw bounding boxes (debug)
    drawBoundingBoxes(dc);

  }

  function onShow() {
  }

  function onHide() {
  }

  function onExitSleep() {
  }

  function onEnterSleep() {
  }

  function defineBoundingBoxes(dc) {

    // "bounds" format is an array as follows [ x, y, r ]
    //  x,y = center of circle
    //  r = radius

    var radius = dw/5;

    boundingBoxes = [
      {
        "label" => "Heart Rate",
        "bounds" => [dw/4,dh/4,radius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_HEART_RATE
      },
      {
        "label" => "Temperature",
        "bounds" => [dw*3/4,dh/4,radius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE
      },
      {
        "label" => "Steps",
        "bounds" => [dw/4,dh*3/4,radius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_STEPS
      },
      {
        "label" => "BodyBatt",
        "bounds" => [dw*3/4,dh*3/4,radius],
        "value" => "",
        "complicationId" => Complications.COMPLICATION_TYPE_BODY_BATTERY
      }
    ];

  }

  // callback that updates the complication value
  function updateComplication(complication) {

    var thisComplication = Complications.getComplication(complication);
    var thisType = thisComplication.getType();

    for (var i=0; i < boundingBoxes.size(); i=i+1){

      if (thisType == boundingBoxes[i]["complicationId"]) {
        boundingBoxes[i]["value"] = thisComplication.value;
        boundingBoxes[i]["label"] = thisComplication.shortLabel;
      }

    }

  }

  // debug by drawing bounding boxes and labels
  function drawBoundingBoxes(dc) {

    dc.setPenWidth(1);

    for (var i=0; i < boundingBoxes.size(); i=i+1){

      var x = boundingBoxes[i]["bounds"][0];
      var y = boundingBoxes[i]["bounds"][1];
      var r = boundingBoxes[i]["bounds"][2];

      // draw a circle
      dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_PURPLE);
      dc.drawCircle(x,y,r);

      // draw the complication label and value
      var value = boundingBoxes[i]["value"];
      var label = boundingBoxes[i]["label"];
      var font = Gfx.FONT_SYSTEM_TINY;

      dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      dc.drawText(x,y-(dc.getFontHeight(font)),font,label.toString(),Gfx.TEXT_JUSTIFY_CENTER);
      dc.drawText(x,y,font,value.toString(),Gfx.TEXT_JUSTIFY_CENTER);

    }

  }


}
