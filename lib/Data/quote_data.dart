import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import '../Models/quote_model.dart';
import '../DataBase_Helper/database_helper.dart';

class QuoteData extends StatefulWidget {
  @override
  _QuoteDataState createState() => _QuoteDataState();
}

///API_Link
String linkAPI = 'https://favqs.com/api/qotd';

///To Add Faviroute btn
bool isWhite = false;
bool isRed = false;
Color btnClr;
IconData btn;

///Call the API and fetch the response
Future<Quote> fetchQuote() async {
  final response = await http.get(Uri.parse(linkAPI));
  if (response.statusCode == 200) {
    return Quote.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}

class _QuoteDataState extends State<QuoteData>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive {
    return true;
  }

  Future<Quote> quote;
  var dbHelper;
  Future<List<Quote>> wholeQuotes;

  @override
  void initState() {
    super.initState();
    quote = fetchQuote();
    dbHelper = DataBaseHelper();
    btn = Icons.favorite;
    btnClr = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Quote>(
      future: quote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 50.0),
                  child: Text(
                    "${snapshot.data.quoteText}",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '-${snapshot.data.quoteAuthor}-',
                  style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                      fontFamily: 'quoteScript'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Share.share(
                            '${snapshot.data.quoteText}--${snapshot.data.quoteAuthor}');
                      },
                    ),
                    IconButton(
                        icon: Icon(
                          btn,
                          color: btnClr,
                        ),
                        onPressed: () {
                          if (isWhite == false) {
                            setState(() {
                              btn = Icons.favorite;
                              btnClr = Colors.white;
                              isWhite = true;
                            });
                          } else if (isRed == false) {
                            setState(() {
                              btn = Icons.favorite;
                              btnClr = Colors.red;
                              isRed = true;
                              Quote q = Quote(
                                  quoteId: null,
                                  quoteText: snapshot.data.quoteText,
                                  quoteAuthor: snapshot.data.quoteAuthor);
                              dbHelper.saveQuote(q);
                              final snackBar = SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  'Added to favorites',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            });
                          }
                        }),
                  ],
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  'Loading Data',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }
}
