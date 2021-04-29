import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomEventosLV extends StatelessWidget {
  final Map eventos;

  CustomEventosLV(this.eventos);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(eventos[currentIndex], context);
      },
    );
  }

  Widget createViewItem(List events, BuildContext context) {
    return new Scaffold(
      body: ListTile(
        title: Card(
            child: new Container(
          height: 200,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          padding: EdgeInsets.all(5.0),
          child: Table(
            children: [
              TableRow(children: [
                Column(children: [
                  Text(events[0], style: TextStyle(fontSize: 20.0))
                ]),
              ]),
            ],
          ),
        )),
      ),
    );
  }
}
