#include <Servo.h> 
int servoPin = 3;
Servo servo;  
int angle = 0;   // servo position in degrees 
void setup() 
{ 
  Serial.begin(9600);
  servo.attach(servoPin); 
} 

void open()
{
  // 90 to 120 - counterclockwise
  servo.write(120);
  delay(3200);
}
void close()
{ 
  // 0 - 90 clockwise
  servo.write(50);
  delay(3200);
}
void loop() 
{
  Serial.println("open");
  open();
  Serial.println("close");
  close();
} 
