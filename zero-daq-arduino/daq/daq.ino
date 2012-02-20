
#include "max6675.h"

int thermoSCLK = 13;
int thermoCS0 = 10;
int thermoCS1 = 9;
int thermoMISO = 12;

MAX6675 thermocouple0(thermoSCLK, thermoCS0, thermoMISO);
MAX6675 thermocouple1(thermoSCLK, thermoCS1, thermoMISO);
int vccPin = 8;
int gndPin = 7;
  
void setup() {
  Serial.begin(9600);
  // use Arduino pins 
  pinMode(vccPin, OUTPUT); digitalWrite(vccPin, HIGH);
  pinMode(gndPin, OUTPUT); digitalWrite(gndPin, LOW);
  
  Serial.println(":::aok:::");
  // wait for MAX chip to stabilize
  delay(1500);
}

void loop() {
  // basic readout test, just print the current temp
  
//   Serial.print("C = "); 
//   Serial.println(thermocouple.readCelsius());
   
   String f0 = "f0,";
   f0 += thermocouple0.readFarenheit();
   Serial.println(f0);
   delay(500);
   
   String f1 = "f1,";
   f1 += thermocouple1.readFarenheit();
   Serial.println(f1);
   delay(500);
}
