import 'package:flutter/material.dart';
import 'package:quote_app/Components/favorite_quotes.dart';
import 'package:quote_app/Data/quote_data.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Daily motivation',
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tooltip(
                message: 'Daily Quotes',
                child: Tab(
                  icon: Icon(
                    Icons.today,
                  ),
                ),
              ),
              Tab(
                icon: Icon(Icons.favorite),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/bgg.jpg',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: QuoteData(),
              ),
            ),
            FavoriteQuotes(),
          ],
        ),
      ),
    );
  }
}
