
 

#include <AFMotor.h>

AF_DCMotor motor1(1);
AF_DCMotor motor2(2);
AF_DCMotor motor3(3);
AF_DCMotor motor4(4);

void setup() {
  Serial.begin(57600);
  Serial.setTimeout(1);
  motor1.setSpeed(0);
      motor1.run(RELEASE);
      motor2.setSpeed(0);
      motor2.run(RELEASE);
      motor3.setSpeed(0);
      motor3.run(RELEASE);
      motor4.setSpeed(0);
      motor4.run(RELEASE);
 
}
void loop () {
  // Seri porttan veri var mı kontrol et
     // Seri porttan gelen veriyi oku

     int direction = 0;
 
   direction = Serial.read();
  
  
  Serial.println(direction);
   
   
    
    // Left
     if (direction == 52) {

       E();

       
    }
   
    else if (direction == 51) {

       W();

     
     
    }


    // Forward
    else if (direction == 50) {

      S();

      
    }
    
    // Backward
    else if (direction == 49) {

      N();

      
      
    }
  
   else  {

    motor1.setSpeed(0);
      motor1.run(RELEASE);
      motor2.setSpeed(0);
      motor2.run(RELEASE);
      motor3.setSpeed(0);
      motor3.run(RELEASE);
      motor4.setSpeed(0);
      motor4.run(RELEASE);
      delay(1);
   }


}



void E(){
motor1.setSpeed(255);
      motor1.run(FORWARD);
      motor2.setSpeed(255);
      motor2.run(BACKWARD);
      motor3.setSpeed(255);
      motor3.run(FORWARD);
      motor4.setSpeed(255);
      motor4.run(BACKWARD);
      delay(1);

  
}

void W (){

      motor1.setSpeed(255);
      motor1.run(BACKWARD);
      motor2.setSpeed(255);
      motor2.run(FORWARD);
      motor3.setSpeed(255);
      motor3.run(BACKWARD);
      motor4.setSpeed(255);
      motor4.run(FORWARD);
      delay(1);

  
}


void N () {

motor1.setSpeed(255);
      motor1.run(BACKWARD);
      motor2.setSpeed(255);
      motor2.run(BACKWARD);
      motor3.setSpeed(255);
      motor3.run(BACKWARD);
      motor4.setSpeed(255);
      motor4.run(BACKWARD);
      delay(1);

  
}


void S () {

 motor1.setSpeed(255);
      motor1.run(FORWARD);
      motor2.setSpeed(255);
      motor2.run(FORWARD);
      motor3.setSpeed(255);
      motor3.run(FORWARD);
      motor4.setSpeed(255);
      motor4.run(FORWARD);
      delay(1);


  
}
  
