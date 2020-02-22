#include <LBLE.h>
#include <LBLEPeriphral.h>

LBLEService BLEService("19B10010-E8F2-537E-4F6C-D104768A1214");
LBLECharacteristicInt BLEWrite("19B10012-E8F2-537E-4F6C-D104768A1214", LBLE_WRITE);
LBLECharacteristicString BLERead("19B10011-E8F2-537E-4F6C-D104768A1214", LBLE_READ);

void startLBLE() {
  LBLE.begin();
  while (!LBLE.ready()) {
    delay(100);
  }
  Serial.println("BLE ready");
}

void setup() {

  Serial.begin(9600);
  startLBLE();

  pinMode(5, OUTPUT);

  BLEService.addAttribute(BLERead);
  BLEService.addAttribute(BLEWrite);

  Serial.print("Device Address = [");
  Serial.print(LBLE.getDeviceAddress());
  Serial.println("]");

  LBLEAdvertisementData advertisement;
  advertisement.configAsConnectableDevice("BLE Servo");

  LBLEPeripheral.setName("BLE Servo");
  LBLEPeripheral.addService(BLEService);
  LBLEPeripheral.begin();
  LBLEPeripheral.advertise(advertisement);
}

String readAnalog() {
  String analog0 = String(analogRead(A0));
  String analog1 = String(analogRead(A1));
  return analog0 + "," + analog1;
}

void showConected() {
  Serial.print("conected=");
  Serial.println(LBLEPeripheral.connected());
}

void loop()
{
  BLERead.setValue(readAnalog());
  if (BLEWrite.getValue() == 0) {
    digitalWrite(5, LOW);
  } else {
    digitalWrite(5, HIGH);
  }
  //Serial.println(readAnalog());
  delay(2000);
}
