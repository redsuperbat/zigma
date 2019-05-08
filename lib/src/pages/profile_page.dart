import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Advert> returnList;
  final controller = PageController(
    initialPage: 0,
  );

  Future<dynamic> getUserAdverts(context) async {
    if (DataProvider.of(context).advertList.getUserAdvertList().length != 0) {
      returnList = DataProvider.of(context).advertList.getUserAdvertList();
    } else {
      returnList =
          await DataProvider.of(context).advertList.getAdvertsFromIds(context);
      if (returnList.length == 0) {
        return noAdverts(context);
      }
    }
    return returnList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/advertPageBackground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
            ],
            leading: IconButton(
              color: Color(0xFFFFFFFF),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _profilePictureStyled(),
              _profileNameStyled(),
              _profileRatingStyled(),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Dina annonser:",
                          style: TextStyle(fontSize: 25),
                        ),
                        FutureBuilder(
                          future: getUserAdverts(context),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height/2.1,
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data is List
                                        ? snapshot.data.length
                                        : 1,
                                    itemBuilder: (context, index) {
                                      if (snapshot.data is List) {
                                        return cardBuilder(snapshot.data[index]);
                                      } else {
                                        return snapshot.data;
                                      }
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardBuilder(Advert a) {
    return MaterialButton(
      onPressed: () {
        DataProvider.of(context).routing.routeAdvertPage(context, a, false);
      },
      child: Card(
        child: Container(
          color: Color.fromRGBO(64, 75, 96, .9),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: a.images.length == 0
                      ? Image.asset('images/placeholder_book.png')
                      : Image.network(a.images[0]),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: <Widget>[
                  Text("Titel: " + a.bookTitle,
                      style: TextStyle(color: Colors.white)),
                  Text("Författare: " + a.authors,
                      style: TextStyle(color: Colors.white)),
                  Text("Upplaga: " + a.edition,
                      style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
            Expanded(
                flex: 2,
                child: Text(
                  a.price.toString() + ":-",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
          ]),
        ),
      ),
    );
  }

  Container noAdverts(context) {
    Container returner = Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              "Wooops! Verkar som du inte lagt upp några annonser än! (synd!)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35),
            ),
          ),
          RaisedButton(
            onPressed: () {
              DataProvider.of(context).routing.routeCreationPage(context);
            },
            child: Text("Lägg till en annons"),
          ),
        ],
      ),
    );
    return returner;
  }

  Widget _profilePictureStyled() {
    String userImageURI = DataProvider.of(context).user.getImage();
    return GestureDetector(
      onTap: () {},
      child: Center(
        child: Container(
          child: CircleAvatar(
            backgroundColor: Color(0xFF95453),
            radius: 75,
            backgroundImage: NetworkImage(
              userImageURI,
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileNameStyled() {
    return Center(
      child: RichText(
        text: TextSpan(
            // set the default style for the children TextSpans
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
            children: [
              TextSpan(
                text: DataProvider.of(context).user.getUsername(),
                style: TextStyle(
                  color: Color(0xFFE36B1B),
                ),
              ),
            ]),
      ),
    );
  }

  Widget _profileRatingStyled() {
    return Center(
      child: RichText(
        text: TextSpan(
            // set the default style for the children TextSpans
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
            children: [
              TextSpan(
                text: DataProvider.of(context).user.getEmail(),
                // Email tills vidare
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ]),
      ),
    );
  }
}

//  Widget _profileMenusStyled() {
//    return Column(
//      children: <Widget> [
//    Row(
//    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      children: <Widget>[
//        _displayAds ?
//        Container()
//            :
//        Container()
//      ],
//    ),
//    _displayAds ?
//    Container(
//    height: 250.0,
//    child: ListView.builder(
//    scrollDirection: Axis.vertical,
//    shrinkWrap: true,
//    itemCount: adList.length,
//    itemBuilder: cardBuilder(context, "ads"),)
//    ) :
//
//
//    cardBuilder("ads")
//        : cardBuilder("reviews");
//    ]
//    );
//  }
