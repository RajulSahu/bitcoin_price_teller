import 'package:flutter/material.dart';
import '/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'get_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';
  String rateBTC = '?';
  String rateETH = '?';
  String rateLTC = '?';
  String demo = 'Rajul';
  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value!;
            updateBTCRate(selectedCurrency);
            updateETHRate(selectedCurrency);
            updateLTCRate(selectedCurrency);
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() async {
          selectedCurrency = currenciesList[selectedIndex];
          updateBTCRate(selectedCurrency);
          updateETHRate(selectedCurrency);
          updateLTCRate(selectedCurrency);
        });
      },
      children: pickerItems,
    );
  }

  Widget? getPicker() {
    if (Platform.isAndroid) {
      return androidDropDown();
    } else if (Platform.isIOS) {
      return iOSPicker();
    } else {
      return null;
    }
  }

  Future<String> calcRate(String from, String to) async {
    // from = 'BTC'
    // to = 'INR'
    NetworkHelper nh = NetworkHelper(from_curr: from, to_curr: to);
    var data = await nh.getData();
    double fullRate = data['rate'];
    String finalRate = fullRate.toStringAsFixed(0);
    return finalRate;
  }

  Future<void> updateBTCRate(String selectedCurrency) async {
    rateBTC = await calcRate('BTC', selectedCurrency);
  }

  Future<void> updateETHRate(String selectedCurrency) async {
    rateETH = await calcRate('ETH', selectedCurrency);
  }

  Future<void> updateLTCRate(String selectedCurrency) async {
    rateLTC = await calcRate('LTC', selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('🤑 Bitcoin Price Teller'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ${cryptoList[0]} = $rateBTC $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ${cryptoList[1]} = $rateETH $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ${cryptoList[2]} = $rateLTC $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 240.0),
            child: Container(
              height: 120.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30.0, top: 18.0),
              color: Colors.lightBlue,
              child: getPicker(),
            ),
          ),
        ],
      ),
    );
  }
}
