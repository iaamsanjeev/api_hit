import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class ApiHitFutureBuilder extends StatefulWidget {
  const ApiHitFutureBuilder({super.key});

  @override
  _ApiHitFutureBuilderState createState() => _ApiHitFutureBuilderState();
}

class _ApiHitFutureBuilderState extends State<ApiHitFutureBuilder> {
  List products = [];
  Future<List<dynamic>> fetchProduct() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      print(response.body);
      final json = jsonDecode(response.body);
      print(json);
      products = json['products'];
      return products;
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Api Hit with Future Builder"),
          // actions: [
          //   InkWell(
          //       onTap: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => ApiHitFutureBuilder()));
          //       },
          //       child: Padding(
          //         padding: const EdgeInsets.only(right: 8.0),
          //         child: Icon(Icons.arrow_circle_right),
          //       ))
          // ],
        ),
        body: FutureBuilder<List<dynamic>>(
            future: fetchProduct(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              final products = snapshot.data;
              return ListView.builder(
                  itemCount: products!.length,
                  itemBuilder: (_, index) {
                    final product = products[index];
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            product!['images'][0] ?? "",
                            width: 100,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['title'] ?? ""),
                              // Text(productList[index]['description']),
                              Text(product['tags'][0] ?? ""),
                              Text(product['brand']),
                              Text(product['category']),
                              Text("${(product['price'] as num).toDouble()}"),
                              Text("${product['dimensions']}"),
                              Text(product['warrantyInformation']),
                              Text(product['shippingInformation']),
                              // Text(productList[index]['meta'].toString()),
                              Text(product['reviews'][1]['comment'].toString())
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            }));
  }
}
