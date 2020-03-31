import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

RefreshController refreshController = RefreshController(initialRefresh: false);

var totalDeath;
var totalRecovered;
var totalNewDeathToday;
var totalActiveCases;
var totalSeriousCases;
var totalCases;
var totalUnresolved;
var totalNewCasesToday;
bool isLoading = false;

class _MyAppState extends State<MyApp> {
  void getData() async {
    setState(() {
      isLoading = true;
    });

    http.Response response =
        await http.get("https://thevirustracker.com/free-api?global=stats");
    if (response.statusCode == 200) {
      String data = response.body;
      totalCases = await jsonDecode(data)["results"][0]["total_cases"];
      totalDeath = await jsonDecode(data)["results"][0]["total_deaths"];
      totalRecovered = await jsonDecode(data)["results"][0]["total_recovered"];
      totalNewDeathToday =
          await jsonDecode(data)["results"][0]["total_new_deaths_today"];
      totalActiveCases =
          await jsonDecode(data)["results"][0]["total_active_cases"];
      totalDeath = await jsonDecode(data)["results"][0]["total_deaths"];
      totalSeriousCases =
          await jsonDecode(data)["results"][0]["total_serious_cases"];
      totalUnresolved =
          await jsonDecode(data)["results"][0]["total_unresolved"];
      totalNewCasesToday =
          await jsonDecode(data)["results"][0]["total_new_cases_today"];
      setState(() {
        isLoading = false;
      });
      refreshController.refreshCompleted();
    } else {
      print("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "CoronaVirus Tracker WorldWide",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
          ),
          backgroundColor: Colors.red,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/virus.JPG",
                  ),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: SmartRefresher(
              onRefresh: getData,
              controller: refreshController,
              enablePullDown: true,
              child: SingleChildScrollView(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "This app is made by Ahmed Titef",
                      style: TextStyle(color: Colors.cyan),
                    ),
                    CardsInfo(
                        totalCases, Icons.done_outline, "Cases", Colors.yellow),
                    CardsInfo(totalRecovered, Icons.healing, "Recovered",
                        Colors.green),
                    CardsInfo(totalUnresolved, Icons.cached, "Unresolved",
                        Colors.blue),
                    CardsInfo(totalDeath, Icons.cancel, "Death", Colors.red),
                    CardsInfo(totalNewCasesToday, Icons.mood_bad,
                        "New Cases Today", Colors.brown),
                    CardsInfo(totalNewDeathToday, Icons.assistant_photo,
                        "New Death Today", Colors.deepOrange),
                    CardsInfo(totalActiveCases, Icons.mood_bad, "Active Cases",
                        Colors.deepPurple),
                    CardsInfo(totalSeriousCases, Icons.report, "Serious Cases",
                        Colors.cyanAccent),
                  ],
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardsInfo extends StatelessWidget {
  var title;
  var icon;
  var numbers;
  var color;

  CardsInfo(this.numbers, this.icon, this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      child: Card(
        elevation: 10,
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$title",
                    style: TextStyle(color: color, fontSize: 25),
                  ),
                  Icon(
                    icon,
                    size: 40,
                    color: color,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  isLoading
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.deepPurple,
                        )
                      : Text(
                          "$numbers",
                          style: TextStyle(color: color, fontSize: 30),
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
