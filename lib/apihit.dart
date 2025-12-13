import 'dart:convert';
import 'dart:math';

import 'package:api_hitt/api_whole_json.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  bool isLoading = true;
  List productList = [];
  List reviews = [];
  Future<void> fetchData() async {
    final url = Uri.parse("https://dummyjson.com/products/1");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("data--->$data");
      productList = [data];
      reviews = data['reviews'];
    } else {
      // handle error
      print("Error");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("api screen"),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ApiWholeJson()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.arrow_circle_right),
              ))
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              // padding: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Products",
                    style: TextStyle(color: Colors.black),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (_, index) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Image.network(
                                  productList[index]['images'][0],
                                  width: 100,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productList[index]['title']),
                                    // Text(productList[index]['description']),
                                    Text(productList[index]['tags'][0]),
                                    Text(productList[index]['brand']),
                                    Text(productList[index]['category']),
                                    Text(
                                        "${(productList[index]['price'] as num).toDouble()}"),
                                    Text("${productList[index]['dimensions']}"),
                                    Text(productList[index]
                                        ['warrantyInformation']),
                                    Text(productList[index]
                                        ['shippingInformation']),
                                    // Text(productList[index]['meta'].toString()),
                                    Text(productList[index]['reviews'][1]
                                            ['comment']
                                        .toString())
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
