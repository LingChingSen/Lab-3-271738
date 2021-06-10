import 'dart:convert';
import 'package:http/http.dart' as http;
import 'newproduct.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ProductsScreen(),
      ),
    );
  }
}

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List _productList = [];
  String _titlecenter = "Loading...";
  double screenHeight, screenWidth;
  final df = new DateFormat('dd-MM-yyyy');
  TextEditingController _srcController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _testasync();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bun-Shop"),
      ),
      body: Center(
        child: Column(children: [
          Column(children: [
            TextFormField( 
               
              controller: _srcController,
              decoration: InputDecoration(
                
                hintText: "Search Buns",
                suffixIcon: IconButton(
                  onPressed: () => _loadProducts(_srcController.text),
                  icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white24)),
              ),
              
            )
          ]),
          if (_productList ==null)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(
                flex: 9,
                child: ListView.builder(
                    itemCount: _productList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                        child: Card(
                         child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color:Colors.cyan[600],
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                    ),
                                  ]
                                ),

                 
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                          margin: EdgeInsets.all(8.0),
                                          width: 150.0,
                                          height: 150.0,
                                          decoration: new BoxDecoration(
                                              image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: new NetworkImage(
                                                      "https://crimsonwebs.com/s271738/bunshop/images/${_productList[index]['id']}.png")))),
                                    ),
                                    Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 15, 5, 0),
                                                child: Text(
                                                    "Bun Name: " +
                                                        _productList[index]
                                                            ['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                        fontSize: 15)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 15, 5, 0),
                                                child: Text(
                                                  "Price: RM " +
                                                      _productList[index]
                                                          ['price'],
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 15, 5, 0),
                                                child: Text(
                                                  "Filling: " +
                                                      _productList[index]
                                                          ['type'],
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 15, 5, 0),
                                                child: Text(
                                                  "Quantity Avaliable: " +
                                                      _productList[index]
                                                          ['qty'],
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                              ),
                                            ])
                                          ],
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          alignment: Alignment.centerRight,
                                          child: PopupMenuButton(
                                              onSelected: (newValue) {
                                                if (newValue == 1) {}
                                                if (newValue == 0) {}
                                              },
                                              child: Icon(Icons.menu),
                                              itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                       child: ElevatedButton(
                                                      onPressed: () =>
                                                          {},
                                                      child:
                                                          Text("Add to Cart"),
                                                    ),
                                                    ),
                                                  ]),
                                        ))
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ));
                    })),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewProduct()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _loadProducts(String prname) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunshop/php/loadproduct.php"),
        body: {"prname": prname}).then((response) {
      if (response.body == "nodata") {
        Fluttertoast.showToast(
            msg: "No Buns Found!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.red,
            fontSize: 20.0);
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["products"];
        _titlecenter = "";
      }
      setState(() {});
    });
  }

  Future<void> _testasync() async {
    _loadProducts("");
  }
}
