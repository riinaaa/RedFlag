import 'package:flutter/material.dart';

class add extends StatefulWidget {
  @override
  _addState createState() => _addState();
}

class _addState extends State<add> {
  List<DynamicWidget> listDynamic = [];
  List<String> fullNme = [];
  List<String> phone = [];

  Icon floatingIcon = new Icon(Icons.add);

  addDynamic() {
    if (fullNme.length != 0) {
      floatingIcon = new Icon(Icons.add);

      fullNme = [];
      listDynamic = [];
      print('if');
    }
    setState(() {});
    if (listDynamic.length >= 10) {
      return;
    }
    listDynamic.add(new DynamicWidget());
  }

  submitData() {
    floatingIcon = new Icon(Icons.arrow_back);
    fullNme = [];
    phone = [];
    listDynamic
        .forEach((widget) => fullNme.add(widget.controller_fullName.text));
    listDynamic.forEach((widget) => phone.add(widget.controller_phone.text));

    setState(() {});
    print(fullNme.length);
    print(phone.length);
  }

  @override
  Widget build(BuildContext context) {
    Widget result = new Flexible(
        flex: 1,
        child: new Card(
          child: ListView.builder(
            itemCount: fullNme.length,
            itemBuilder: (_, index) {
              return new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          margin: new EdgeInsets.only(left: 10.0),
                          child: new Text(
                              "Full Name ${index + 1} : ${fullNme[index]}"),
                        ),
                        Container(
                          margin: new EdgeInsets.only(left: 10.0),
                          child: new Text(
                              "Phone Number ${index + 1} : ${phone[index]}"),
                        ),
                      ],
                    ),
                    new Divider()
                  ],
                ),
              );
            },
          ),
        ));

    Widget dynamicTextField = new Flexible(
      flex: 2,
      child: new ListView.builder(
        itemCount: listDynamic.length,
        itemBuilder: (_, index) => listDynamic[index],
      ),
    );

    Widget submitButton = new Container(
      child: new ElevatedButton(
          onPressed: submitData,
          child: new Padding(
            padding: new EdgeInsets.all(16.0),
            child: new Text('Save Emergency Contact'),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF4E4EF7),
          )),
    );

    return new MaterialApp(
      home: new Scaffold(
        // appBar: new AppBar(
        //   title: new Text('Add Emergency contacts'),
        // ),

        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              fullNme.length == 0 ? dynamicTextField : result,
              fullNme.length == 0 ? submitButton : new Container(),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: addDynamic,
          child: floatingIcon,
          backgroundColor: Colors.red[200],
        ),
      ),
    );
  }
}

class DynamicWidget extends StatelessWidget {
  TextEditingController controller_fullName = new TextEditingController();
  TextEditingController controller_phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextField(
            controller: controller_fullName,
            decoration: new InputDecoration(hintText: 'Full Name '),
          ),
          TextField(
            controller: controller_phone,
            decoration: new InputDecoration(hintText: 'Phone Number '),
          ),
        ],
      ),
    );
  }
}
