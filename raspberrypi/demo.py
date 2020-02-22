import struct
from bluepy.btle import Scanner, DefaultDelegate, Peripheral

device = Peripheral()

device.connect('78:A3:52:00:04:2D')
services = device.getServices()
characteristics = device.getCharacteristics()
descriptors = device.getDescriptors()
state = device.getState()

#displays all services
for service in services:
   print(service)

print("Handle   UUID                                Properties")
print("-------------------------------------------------------")                     
for ch in characteristics:
    print("  0x"+ format(ch.getHandle(),'02X')  +"   "+str(ch.uuid) +" " + ch.propertiesToString())
    if ch.uuid == '19b10011-e8f2-537e-4f6c-d104768a1214':
        print(struct.unpack('i', ch.read())[0])