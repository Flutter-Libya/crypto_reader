import 'package:bitcoin_ticker/Networking.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String sellectedCurrency = "USD";

  Future<String> btcRate;
  Future<String> ethRate;
  Future<String> bnbRate;

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> myDropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      );
      myDropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: sellectedCurrency,
      items: myDropDownItems,
      onChanged: (value) {
        setState(() {
          sellectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iOSCupertinoPicker() {
    List<Text> pickerItem = [];
    for (String currency in currenciesList) {
      pickerItem.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          sellectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: pickerItem,
    );
  }

  Future<String> afterDataComes() async {
    var data = await CryptoData().getCoinData('BTC', sellectedCurrency);
    return data.toStringAsFixed(2);
  }

  Future<String> afterSecondDataComes() async {
    var data = await CryptoData().getCoinData('ETH', sellectedCurrency);
    return data.toStringAsFixed(2);
  }

  Future<String> afterThirdDataComes() async {
    var data = await CryptoData().getCoinData('BNB', sellectedCurrency);
    return data.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    btcRate = afterDataComes();
    ethRate = afterSecondDataComes();
    bnbRate = afterThirdDataComes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CurrencyCard(
                    dataFunction: () => btcRate,
                    crypto: 'BTC',
                    currency: sellectedCurrency,
                  ),
                  CurrencyCard(
                    dataFunction: () => ethRate,
                    crypto: 'ETH',
                    currency: sellectedCurrency,
                  ),
                  CurrencyCard(
                    dataFunction: () => bnbRate,
                    crypto: 'BNB',
                    currency: sellectedCurrency,
                  ),
                ],
              ),
            ),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSCupertinoPicker() : androidDropDown(),
            ),
          ],
        ),
      ),
    );
  }

}

class CurrencyCard extends StatelessWidget {
  final Future<String> Function() dataFunction;
  final String crypto;
  final String currency;

  CurrencyCard({this.dataFunction, this.crypto, this.currency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: FutureBuilder<String>(
            future: dataFunction(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError || snapshot.data == null) {
                return Text(
                  'Error: Failed to load data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                );
              } else {
                return Text(
                  '1 $crypto = ${snapshot.data} $currency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
