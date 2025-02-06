import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:newa_app/category.dart';
import 'package:newa_app/model.dart';
import 'package:http/http.dart';
import 'package:newa_app/news_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = ["Top News", "India", "World", "Finance", "Health"];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    String today = DateTime.now().toIso8601String().split('T')[0];
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2025-01-06&sortBy=publishedAt&apiKey=7c333b2ad49740b7859358b99f88fbdb";

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);

          newsModelList = newsModelList.sublist(0, 4);
        } catch (e) {
          print(e);
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  getNewsofIndia() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=7c333b2ad49740b7859358b99f88fbdb";

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);

          newsModelListCarousel = newsModelListCarousel.sublist(
              0,
              newsModelListCarousel.length > 4
                  ? 4
                  : newsModelListCarousel.length);
        } catch (e) {
          print(e);
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery("in");
    getNewsofIndia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SafeArea(
            child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          print("Blank search");
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Category(Query: searchController.text)));
                        }
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                        child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value == " ") {
                          print("BLANK SEARCH");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Category(Query: value)));
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search News....."),
                    ))
                  ],
                )),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: navBarItem.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Category(Query: navBarItem[index])));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        navBarItem[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: isLoading
                ? SizedBox(
                    height: 200,
                    child: CircularProgressIndicator(),
                  )
                : CarouselSlider(
                    options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true),
                    items: newsModelListCarousel.map((instance) {
                      return Builder(
                        builder: (BuildContext context) {
                          try {
                            return Container(
                              width: double.infinity,
                              child: InkWell(
                                onTap: () {
                                  if (instance.newsUrl.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsView(url: instance.newsUrl)),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "No URL available for this news")),
                                    );
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            instance.newsImg ??
                                                'https://via.placeholder.com/150',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child; // Image has fully loaded
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(Icons.broken_image,
                                                    size: 50,
                                                    color: Colors.grey),
                                              );
                                            },
                                          )),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black12
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Text(
                                              instance.newsHead ??
                                                  "No Title Available",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        },
                      );
                    }).toList(),
                  ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Latest News ",
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
                      try {
                        return Container(
                            height: 200,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: InkWell(
                              onTap: () {
                                // Check if the newsUrl is not empty
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
                                      content: Text(
                                          "No URL available for this news"),
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
                                          newsModelList[index].newsImg ??
                                              'https://via.placeholder.com/150',
                                          fit: BoxFit.cover,
                                          height: 300,
                                          width: double.infinity,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child; // Image fully loaded
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          (loadingProgress
                                                                  .expectedTotalBytes ??
                                                              1)
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(Icons.broken_image,
                                                  size: 50, color: Colors.grey),
                                            );
                                          },
                                        )),
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
                                                    Colors.black12
                                                        .withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          padding: EdgeInsets.fromLTRB(
                                              15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsModelList[index].newsHead,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                      } catch (e) {
                        print(e);
                        return Container();
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Category(Query: "India")));
                      },
                      child: Text("Show More"),
                    ),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
