import 'dart:async'; //For StreamController/Stream
import 'dart:io'; //InternetAddress utility

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectionStatusListener {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusListener _singleton =
      ConnectionStatusListener._internal();
  ConnectionStatusListener._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusListener getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController<bool> connectionChangeController =
      StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void startListen() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    _checkConnection();
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    _checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> _checkConnection() async {
    bool previousConnection = hasConnection;

    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();

    if ([
      ConnectivityResult.mobile,
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
    ].contains(connectivityResult)) {
      try {
        final result = await InternetAddress.lookup("google.com");
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          hasConnection = true;
        } else {
          hasConnection = false;
        }
      } on SocketException catch (_) {
        hasConnection = false;
      }
    } else {
      debugPrint("Connection is not found");
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }

  Future<bool> checkConnection() async {
    bool isConnectedToInternet = false;
    int attempt = 0;

    do {
      attempt += 1;
      isConnectedToInternet = await _checkConnection();
      await Future.delayed(const Duration(milliseconds: 50));
      debugPrint(
          "$attempt. attempt to conntect to the internet: $isConnectedToInternet ");
    } while (!isConnectedToInternet && attempt < 5);

    return isConnectedToInternet;
  }
}
