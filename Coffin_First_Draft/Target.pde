class Target {
  int x, y, z, d;
  boolean triggered;
  
  public Target(){
    triggered = false;
  }
  
  void checkCollision(PVector joint){
     if (joint.x > Constants.X1 && joint.x < Constants.X2
     && joint.y > Constants.Y1 && joint.y < Constants.Y2
     && joint.z > Constants.Z1 && joint.z < Constants.Z2){
           triggered = true; 
     } else {
       triggered = false;
     } 
  }
  
}
