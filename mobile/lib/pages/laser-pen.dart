import 'dart:async';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sensors/sensors.dart';
import 'package:flutter/material.dart';

class Main extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => PageState();
}

class PageState extends State<Main> {
    var gyroscopeEvent;
    var accelerometerEvent;
    bool left = false;
    bool right = false;
    bool middle = false;
    bool enable = true;
    bool connentd = false;
    bool doConnent = false;
    Timer timer;
    String connentError = '';
    double sensitivity = 0.0;
    IO.Socket socket;
    GyroscopeEvent gyroscopeResult = GyroscopeEvent(0, 0, 0);
    AccelerometerEvent accelerometerResult = AccelerometerEvent(0, 0, 0);

    PageState() {
        var duration = Duration(
            microseconds: 1000
        );
        this.timer = Timer.periodic(duration, (Timer timer) {
            this.update();
        });
        this.gyroscopeEvent = gyroscopeEvents.listen((GyroscopeEvent event) {
            gyroscopeResult = event;
        });
        this.accelerometerEvent = accelerometerEvents.listen((AccelerometerEvent event) {
            accelerometerResult = event;
        });
    }

    connectSocket(String host) {
        this.socket = IO.io(host, <String, dynamic> {
              'transports': ['websocket']
        });
        this.socket.on('connect', (data) {
            this.connentd = true;
        });
        this.socket.on('error', (data) {
            this.connentError = data;
        });
        this.socket.on('connect_error', (data) {
            this.connentError = data.toString();
            this.connentd = false;
        });
    }

    update() {
        setState(() {});
        Map<String, dynamic> reslut = {
            "sensitivity": this.sensitivity,
            "left": this.left,
            "right": this.right,
            "middle": this.middle,
            "gyroscope": {
                "x": this.gyroscopeResult.x,
                "y": this.gyroscopeResult.y,
                "z": this.gyroscopeResult.z
            },
            "accelerometer": {
                "x": this.accelerometerResult.x,
                "y": this.accelerometerResult.y,
                "z": this.accelerometerResult.z
            }
        };
        this.emit('mobile-update', json.encode(reslut));
    }

    emit(String channel, [String reslut = '']) {
        if (this.doConnent && this.connentd && this.enable) {
            this.socket.emit(channel, reslut);
        }
    }

    @override
    dispose() {
        this.timer.cancel();
        this.socket.close();
        this.gyroscopeEvent.cancel();
        this.accelerometerEvent.cancel();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('雷射筆')
            ),
            body: Column(
                children: <Widget>[
                    Visibility(
                        visible: this.doConnent == false,
                        child: RaisedButton(
                            child: Text('掃描QRCODE'),
                            onPressed: () async {
                                try {
                                    var barcode = await BarcodeScanner.scan();
                                    this.doConnent = true;
                                    this.connectSocket(barcode);
                                } catch (e) {
                                    print(e);
                                }
                            }
                        )
                    ),
                    Visibility(
                        visible: this.doConnent == true && this.connentError != '',
                        child: Text(this.connentError)
                    ),
                    Visibility(
                        visible: this.doConnent == true && this.connentd == false && this.connentError == '',
                        child: Text('連線中')
                    ),
                    Visibility(
                        visible: this.doConnent == true && this.connentd == true && this.connentError == '',
                        child: Column(
                            children: <Widget>[
                                Slider(
                                    min: 0.0,
                                    max: 100.0,
                                    value: this.sensitivity,
                                    onChanged: (newValue) {
                                        this.sensitivity = newValue;
                                    }
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                        RaisedButton(
                                            child: Text(this.enable ? '關機' : '開機'),
                                            onPressed: () {
                                                this.enable = !this.enable;
                                            }
                                        ),
                                        RaisedButton(
                                            child: Text('重置'),
                                            onPressed: () {
                                                this.emit('mobile-to-center');
                                            }
                                        ),
                                        RaisedButton(
                                            child: Text('左鍵'),
                                            onPressed: () {},
                                            onHighlightChanged: (bool state) {
                                                this.left = state;
                                            }
                                        ),
                                        RaisedButton(
                                            child: Text('中鍵'),
                                            onPressed: () {},
                                            onHighlightChanged: (bool state) {
                                                this.middle = state;
                                            }
                                        ),
                                        RaisedButton(
                                            child: Text('右鍵'),
                                            onPressed: () {},
                                            onHighlightChanged: (bool state) {
                                                this.right = state;
                                            }
                                        )
                                    ]
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }
}
