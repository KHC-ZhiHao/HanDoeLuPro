import 'package:flutter/material.dart';

class Main extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => PageState();
}

class PageState extends State<Main> {
    double sensitivity = 0;
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Home Page')
            ),
            body: Column(
                children: <Widget>[
                    Text(sensitivity.toString()),
                    Slider(
                        min: 0.0,
                        max: 100.0,
                        value: sensitivity,
                        onChanged: (newValue) {
                            setState(() {
                                sensitivity = newValue;
                            });
                        }
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            RaisedButton(
                                child: Text('關機'),
                                onPressed: () {
                                    print('OuO');
                                },
                            ),
                            RaisedButton(
                                child: Text('按鍵代碼'),
                                onPressed: () {
                                    print('OuO');
                                },
                            ),
                            RaisedButton(
                                child: Text('推播訊息'),
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
