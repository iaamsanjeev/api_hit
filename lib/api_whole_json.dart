import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiWholeJson extends StatefulWidget {
  const ApiWholeJson({super.key});

  @override
  _ApiWholeJsonState createState() => _ApiWholeJsonState();
}

class _ApiWholeJsonState extends State<ApiWholeJson> {
  bool isLoading = true;
  List productList = [];
  Future<void> fetchData() async {
    final url = Uri.parse("https://dummyjson.com/products");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("data--->$data");
      productList = data["products"];
      print(productList);
      // reviews = data['reviews'];
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
          title: Text("Api Whole Json "),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(productList[index]['title'] ?? "hi"),
                                      // Text(productList[index]['description']),
                                      Text(productList[index]['tags'][0] ??
                                          "tags"),
                                      Text(productList[index]['brand'] ??
                                          "brand"),
                                      Text(productList[index]['category'] ??
                                          "cate"),
                                      Text(
                                          "${(productList[index]['price'] as num).toDouble()} " ??
                                              "3.8"),
                                      Text(
                                          "${productList[index]['dimensions']}"),
                                      Text(productList[index]
                                          ['warrantyInformation']),
                                      Text(productList[index]
                                          ['shippingInformation']),
                                      // Text(productList[index]['meta'].toString()),
                                      // Text(productList[index]['reviews'][0].toString())
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ));
  }
}
