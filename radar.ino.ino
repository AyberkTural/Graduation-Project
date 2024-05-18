#include <Servo.h>

// Ultrasonik Sinyal pinleri
const int trigPin = 10;
const int echoPin = 11;

long duration;
int distance;

Servo myServo; 

void setup() {
  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT); 
  Serial.begin(9600);
  myServo.attach(12); // Servo motor sinyal pini
  
}
void loop() {
  // 15 derece ile 165 derece arasında dön
  for (int i = 0 ; i <= 360 ; i ++){

         myServo.write(i);
         delay(30);
         Serial.print(calculateDistance());
         Serial.print(",");
         Serial.print(i);
         Serial.println();
  }

for (int i = 360 ; i >= 0 ; i --){

         myServo.write(i);
         delay(30);
         Serial.print(calculateDistance());
         Serial.print(",");
         Serial.print(i);
         Serial.println();
  }
  
}

int calculateDistance(){ 
  
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH); 
  distance= duration*0.017;
  return distance;
}
