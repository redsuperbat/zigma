import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final int initialPage = 0;
  List<dynamic> returnList;
  int stateButtonIndex = initialPage;
  final controller = PageController(
    initialPage: initialPage,
  );

  Future<dynamic> getUserBuyingAdverts(context) async {
    if (DataProvider.of(context).advertList.userListBuying.length != 0) {
      returnList = DataProvider.of(context).advertList.userListBuying;
    } else {
      returnList = await DataProvider.of(context)
          .advertList
          .getSpecificAdverts("B", DataProvider.of(context).user.user.id, "A");
      if (returnList.length == 0) {
        return noAdverts(context);
      }
    }
    return returnList;
  }

  Future<dynamic> getUserSellingAdverts(context) async {
    if (DataProvider.of(context).advertList.userListSelling.length != 0) {
      returnList = DataProvider.of(context).advertList.userListSelling;
    } else {
      returnList = await DataProvider.of(context)
          .advertList
          .getSpecificAdverts("S", DataProvider.of(context).user.user.id, "A");
      if (returnList.length == 0) {
        return noAdverts(context);
      }
    }
    return returnList;
  }

  void pageChanged(int index) {
    setState(() {
      stateButtonIndex = index;
    });
  }

  void buttonChangePage(int index) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFF93DED0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Color(0xFF93DED0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Column(
                    children: <Widget>[
                      _profileNameStyled(),
                      _profileRatingStyled(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0, top: 10, bottom: 25),
                  child: _profilePictureStyled(),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8, right: 15,left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                stateButtons("Säljer", 0),
                stateButtons("Köper", 1),
                stateButtons("Alla", 2)
              ],
            ),
          ),
          Flexible(
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                pageChanged(index);
              },
              children: <Widget>[
                getAdverts(getUserSellingAdverts(context)),
                getAdverts(getUserBuyingAdverts(context)),
                getAdverts(DataProvider.of(context)
                    .advertList
                    .getCombinedUserLists()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stateButtons(String text, int index) {
    return Container(
      alignment: Alignment(0, 0),
      width: MediaQuery.of(context).size.width / 3.3,
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFFECA72C)),
          color: index == stateButtonIndex ? Color(0xFFECA72C) : Colors.white),
      child: MaterialButton(
        onPressed: () {
          buttonChangePage(index);
        },
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: index == stateButtonIndex ? Colors.white : Color(0xFFECA72C)),
        ),
      ),
    );
  }

  Widget getAdverts(Future adverts) {
    return FutureBuilder(
      future: adverts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data is List ? snapshot.data.length : 1,
            itemBuilder: (context, index) {
              if (snapshot.data is List) {
                return cardBuilder(snapshot.data[index]);
              } else {
                return snapshot.data;
              }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget cardBuilder(Advert a) {
    return MaterialButton(
      onPressed: () {
        DataProvider.of(context).routing.routeUserAdvertPage(context, a, false);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 8),
                height: 100,
                width: 70,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    a.bookTitle,
                    style: TextStyle(
                        color: Color(0xff373F51), fontWeight: FontWeight.bold),
                  ),
                  Text(a.authors,
                      style: TextStyle(color: Colors.black87, fontSize: 12)),
                  Text("Upplaga: " + a.edition, style: TextStyle())
                ],
              ),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
            Expanded(
                flex: 2,
                child: Text(
                  a.price.toString() + ":-",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Color(0xffDE5D5D),fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 25),
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
    return GestureDetector(
      onTap: () {
        profilePicDialog();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.transparent,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black87, offset: Offset(0, 5), blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            DataProvider.of(context).user.user.image,
            fit: BoxFit.cover,
            width: 150,
            height: 150,
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
                text: DataProvider.of(context).user.user.username,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
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
                text: DataProvider.of(context).user.user.soldBooks > 5
                    ? "Mellanliggande Bokförsäljare"
                    : "Novis Bokförsäljare",
                // Email tills vidare
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ]),
      ),
    );
  }

  void profilePicDialog() {
    print("Im in show alertDialog");
    Dialog dialog = Dialog(
      insetAnimationCurve: Curves.decelerate,
      insetAnimationDuration: Duration(milliseconds: 500),
      backgroundColor: Color(0xFFECE9DF),
      child: Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.network(DataProvider.of(context).user.user.image),
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
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
