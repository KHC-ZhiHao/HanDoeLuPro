import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Main extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => PageState();
}

class PageState extends State<Main> {
    @override
    Widget build(BuildContext context) {
        double size = MediaQuery.of(context).size.width / 3;
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                title: Text('Han Doe Lu Pro')
            ),
            body: Column(
                children: <Widget>[
                    Container(
                        color: Colors.red,
                        child: Row(
                            children: <Widget>[
                                SizedBox(
                                    width: size,
                                    height: size,
                                    child: Card(
                                        child: InkWell(
                                            onTap: () {
                                                Navigator.of(context).pushNamed('/laserpen');
                                            },
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                    Icon(MdiIcons.sword),
                                                    Text('雷射筆')
                                                ]
                                            )
                                        ),
                                    ),
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }
}
