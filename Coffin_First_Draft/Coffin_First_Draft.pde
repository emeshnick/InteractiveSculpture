import SimpleOpenNI.*;
SimpleOpenNI kinect;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
String message;

Target firstTrig;

void setup() {
 //Setup kinect conection
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();
 
 //setup OSCP port
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("127.0.0.1",12000);
 message = "not triggered";
 
 //Create processing window
 size(640, 480);
 fill(255, 0, 0);
 
 //Creates instance of area measured
 firstTrig = new Target();
}

void draw() {
  //Same draw function as basic skeleton tracking
  //Calls target actions within draw skeleton to 
  //allow for modification to add a second user. 
  //Not currently working but in future iterations?
  kinect.update();
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {
  int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {
    drawSkeleton(userId);
    }
  }
}

void drawSkeleton(int userId) {
 stroke(0);
 strokeWeight(5);
 
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);

 noStroke();

 fill(255,0,0);
 drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
 drawJoint(userId, SimpleOpenNI.SKEL_NECK);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
 drawJoint(userId, SimpleOpenNI.SKEL_NECK);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
 
 //PVector to get x, y, z, of any indivitual joint, in this case the right hand
 PVector test = getJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
 firstTrig.checkCollision(test);
 
 //Checks if the target area is being triggered and performs different actions
 if (firstTrig.triggered == true){
   tint(250, 0, 0);
   if (message == "not triggered"){
     message = "triggered";
     println("z = " + test.z);
     println(test);
     sendOSCMessage();
     
   }
 } else {
   noTint();
   if (message == "triggered"){
     message = "not triggered";
     sendOSCMessage();
     println("out of bounds");
   }
 }
}


void drawJoint(int userId, int jointID) {
 PVector joint = new PVector();

 float confidence = kinect.getJointPositionSkeleton(userId, jointID,
joint);
 if(confidence < 0.5){
   return;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(joint, convertedJoint);
 ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
 //println(convertedJoint);
}

// Method that retrieves the 3d vector of the location of any individual joint
PVector getJoint(int userId, int jointID){
  PVector temp = new PVector();
  
  float confidence = kinect.getJointPositionSkeleton(userId, jointID,
temp);
 if(confidence < 0.5){
   return temp;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(temp, convertedJoint);
 return convertedJoint;
}

//Method from skeleton tracking example
void onNewUser(SimpleOpenNI kinect, int userID){
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}

//Method to send OSCmessage 
void sendOSCMessage() {
  OscMessage myMessage = new OscMessage(message);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}
