import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sensors/sensors.dart';
import 'package:flutter/material.dart';

import '../env.dart' as env;

class Main extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => PageState();
}

class PageState extends State<Main> {
    var gyroscopeEvent;
    var accelerometerEvent;
    String message = 'aaaa';
    IO.Socket socket = IO.io(env.websocketHost, <String, dynamic> {
        'transports': ['websocket']
    });
    Timer timer;
    double sensitivity = 0.0;
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
        this.socket.on('connect', (_) {
            this.message = 'connect';
        });
        this.socket.on('error', (data) {
            this.message = data.toString();
        });
        this.socket.on('connect_error', (data) {
            print(data);
            this.message = data.toString();
        });
    }
    update() {
        setState(() {});
        Map<String, dynamic> reslut = {
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
        this.socket.emit('mobile-update', json.encode(reslut));
    }
    @override
    dispose() {
        this.timer.cancel();
        this.gyroscopeEvent.cancel();
        this.accelerometerEvent.cancel();
        super.dispose();
    }
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Home Page')
            ),
            body: Column(
                children: <Widget>[
                    Text(sensitivity.toString()),
                    Text(message.toString()),
                    Slider(
                        min: 0.0,
                        max: 100.0,
                        value: sensitivity,
                        onChanged: (newValue) {
                            sensitivity = newValue;
                        }
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            RaisedButton(
                                child: Text('關機'),
                                onPressed: () {
                                    print('==');
                                },
                            ),
                            RaisedButton(
                                child: Text('重置'),
                                onPressed: () {
                                    print('OuO');
                                },
                            )
                        ]
                    )
                ]
            )
        );
    }
}
