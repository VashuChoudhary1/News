import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<String> navBarItem = ["Top News", "India", "World", "Finance", "Health"];
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
                          /**  Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Search(searchController.text)));
                                        */
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
                        print(value);
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
                    print(navBarItem[index]);
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
            child: CarouselSlider(
              options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true),
              items: items.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/news.jpg",
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black12.withOpacity(0),
                                            Colors.black
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(
                                    "News Headline is here",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
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
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 1.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    "assets/news.jpg",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
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
                                            "News Headline",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Today's news at your area is this.....",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ));
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
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

  final List items = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.pink,
    Colors.purple
  ];
}
