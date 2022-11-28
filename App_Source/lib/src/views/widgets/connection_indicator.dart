import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Widget getInternetConnection(ConnectivityResult result) {
  return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      color: _getConnectionColor(result),
      padding: const EdgeInsets.all(10),
      child: Text(
          _getConnectionText(result),
          style: const TextStyle(fontSize: 20, color: Colors.white)
      )
  );
}

Color _getConnectionColor(ConnectivityResult result) {
  switch(result) {
    case ConnectivityResult.none:
      return Colors.red;
    case ConnectivityResult.mobile:
    case ConnectivityResult.bluetooth:
      return Colors.orange;
    case ConnectivityResult.wifi:
    case ConnectivityResult.ethernet:
      return Colors.lightGreen;
    default:
      return Colors.black;
  }
}

String _getConnectionText(ConnectivityResult result) {
  switch(result) {
    case ConnectivityResult.none:
      return "Internetverbindung: Offline";
    case ConnectivityResult.mobile:
      return "Internetverbindung: Mobil";
    case ConnectivityResult.bluetooth:
      return "Internetverbindung: Unbekannt";
    case ConnectivityResult.wifi:
      return "Internetverbindung: Wlan";
    case ConnectivityResult.ethernet:
      return "Internetverbindung: Ethernet";
    default:
      return "Internetverbindung: Unbekannt";
  }
}