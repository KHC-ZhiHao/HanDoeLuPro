#include <LBLE.h>
#include <LBLEPeriphral.h>

using namespace std;

char name[10] = "";

LBLEService AService("19B10010-E8F2-537E-4F6C-D104768A1214");
LBLECharacteristicInt ARead("19B10011-E8F2-537E-4F6C-D104768A1214", LBLE_READ);

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

  AService.addAttribute(ARead);

  Serial.print("Device Address = [");
  Serial.print(LBLE.getDeviceAddress());
  Serial.println("]");

  LBLEAdvertisementData advertisement;
  advertisement.configAsConnectableDevice("BLE Servo");

  LBLEPeripheral.setName("BLE Servo");
  LBLEPeripheral.addService(AService);
  LBLEPeripheral.begin();
  LBLEPeripheral.advertise(advertisement);
}

String readAnalog() {
  String A0 = String(analogRead(A0));
  String A1 = String(analogRead(A1));
  String A2 = String(analogRead(A2));
  String A3 = String(analogRead(A3));
  return A0 + "," + A1 + "," + A2 + "," + A3;
}

void loop()
{
  Serial.print("conected=");
  Serial.println(LBLEPeripheral.connected());
  Serial.println(readAnalog());
  //ARead.setValue(item);
  delay(1000);
}
