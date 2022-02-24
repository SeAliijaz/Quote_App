import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_app/Constants/constants.dart';
import 'package:quote_app/Models/quote_model.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///API_Link
  String linkAPI = 'https://favqs.com/api/qotd';

  ///Method
  Future<Quote> fetchData() async {
    Quote quoteModel;
    http.Response response = await http.get(Uri.parse(linkAPI));
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    quoteModel = Quote.fromJson(jsonResponse);
    return quoteModel;
  }

  ///Init State
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily motivation Quotes',
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: FutureBuilder<Quote>(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<Quote> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final v = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: size.width,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "${v.quoteText}",
                            style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Divider(),
                          Container(
                            width: size.width,
                            child: Center(
                              child: Text(
                                '-${v.quoteAuthor}-',
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        Share.share("${v.quoteText} - ${v.quoteAuthor}").then(
                          (value) =>
                              showToastMsg('Sharing your Quote Successfully!'),
                        );
                      },
                      icon: Icon(Icons.share),
                    ),
                    IconButton(
                      onPressed: () {
                        FlutterClipboard.copy(
                                "${v.quoteText} - ${v.quoteAuthor}")
                            .then(
                          (value) => showToastMsg('Copied Quote Successfully!'),
                        );
                      },
                      icon: Icon(Icons.copy),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
