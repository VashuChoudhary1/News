import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newa_app/model.dart';
import 'package:newa_app/news_view.dart';

class Category extends StatefulWidget {
  String Query;
  Category({super.key, required this.Query});
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  //List<String> navBarItem = ["Top News", "India", "World", "Finance", "Health"];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    String url = " ";
    if (query == "Top News" || query == "India") {
      url =
          "https://newsapi.org/v2/top-headlines?country=us&apiKey=7c333b2ad49740b7859358b99f88fbdb";
    } else {
      url =
          "https://newsapi.org/v2/everything?q=$query&from=2024-12-27&sortBy=publishedAt&apiKey=7c333b2ad49740b7859358b99f88fbdb";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("NEWS APP"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.Query,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: newsModelList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: InkWell(
                            onTap: () {
                              if (newsModelList[index].newsUrl.isNotEmpty) {
                                // Navigate to the NewsView screen if the URL is not empty
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsView(
                                            url: newsModelList[index].newsUrl,
                                          )),
                                );
                              } else {
                                // Show a SnackBar if there's no URL available
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("No URL available for this news"),
                                  ),
                                );
                              }
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          newsModelList[index].newsImg,
                                          fit: BoxFit.fitHeight,
                                          height: 300,
                                          width: double.infinity)),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 15, 10, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newsModelList[index].newsHead,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              newsModelList[index]
                                                          .newsDes
                                                          .length >
                                                      50
                                                  ? "${newsModelList[index].newsDes.substring(0, 55)}...."
                                                  : newsModelList[index]
                                                      .newsDes,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ));
                    }),
              ],
            ),
          ),
        ));
  }
}
