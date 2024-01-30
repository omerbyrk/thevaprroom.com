// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';

import '../consts.dart';
import '../globals.dart';

/// Allows the user to close the app by double tapping the back-button.
///
/// You must specify a [SnackBar], so it can be shown when the user taps the
/// back-button.
///
/// Since the back-button is an Android feature, this Widget is going to be
/// nothing but the own [child] if the current platform is anything but Android.
class DoubleBackToCloseAppWidget extends StatefulWidget {
  /// The [SnackBar] shown when the user taps the back-button.
  final SnackBar snackBar;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates a widget that allows the user to close the app by double tapping
  /// the back-button.
  const DoubleBackToCloseAppWidget({
    Key? key,
    required this.snackBar,
    required this.child,
  }) : super(key: key);

  @override
  DoubleBackToCloseAppWidgetState createState() =>
      DoubleBackToCloseAppWidgetState();
}

class DoubleBackToCloseAppWidgetState
    extends State<DoubleBackToCloseAppWidget> {
  /// Completer that gets completed whenever the current snack-bar is closed.
  var _closedCompleter = Completer<SnackBarClosedReason>()
    ..complete(SnackBarClosedReason.remove);

  /// Returns whether the current platform is Android.
  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  /// Returns whether the [DoubleBackToCloseAppWidget.snackBar] is currently visible.
  bool get _isSnackBarVisible => !_closedCompleter.isCompleted;

  @override
  void initState() {
    // TODO: implement initState

    if (Globals.goBackFunction.isCompleted) {
      Globals.goBackFunction = Completer<dynamic Function()>();
    }

    Globals.goBackFunction.complete(_handleWillPop);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /// Returns whether the next back navigation of this route will be handled
  /// internally.
  ///
  /// Returns true when there's a widget that inserted an entry into the
  /// local-history of the current route, in order to handle pop. This is done
  /// by [Drawer], for example, so it can close on pop.
  bool get _willHandlePopInternally =>
      ModalRoute.of(context)?.willHandlePopInternally ?? false;

  @override
  Widget build(BuildContext context) {
    assert(() {
      _ensureThatContextContainsScaffold();
      return true;
    }());

    if (_isAndroid) {
      return WillPopScope(
        onWillPop: _handleWillPop,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  /// Handles [WillPopScope.onWillPop].
  Future<bool> _handleWillPop() async {
    if (Globals.configuration.homeScreen.active) {
      debugPrint(
          "_handleWillPop ${ModalRoute.of(context)!.settings.name.toString()}");
      if (ModalRoute.of(context)!.settings.name == AppConsts.homeWebviewRoute) {
        var controller = await Globals.inAppWebViewController.future;
        if (await controller.canGoBack()) {
          await controller.goBack();
          return false;
        } else {
          await Future.delayed(
              Duration.zero,
              () => Navigator.of(context)
                  .pushReplacementNamed(AppConsts.homeRoute));
          return false;
        }
      }
    } else {
      var controller = await Globals.inAppWebViewController.future;
      if (await controller.canGoBack()) {
        await controller.goBack();
        return false;
      }
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();

    if (_isSnackBarVisible || _willHandlePopInternally) {
      MoveToBackground.moveTaskToBack();
      return false;
    } else {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      _closedCompleter = scaffoldMessenger
          .showSnackBar(widget.snackBar)
          .closed
          .wrapInCompleter();

      return false;
    }
  }

  /// Throws a [FlutterError] if this widget was not wrapped in a [Scaffold].
  void _ensureThatContextContainsScaffold() {
    if (Scaffold.maybeOf(context) == null) {
      throw FlutterError(
        '`DoubleBackToCloseApp` must be wrapped in a `Scaffold`.',
      );
    }
  }
}

extension<T> on Future<T> {
  /// Returns a [Completer] that allows checking for this [Future]'s completion.
  ///
  /// See https://stackoverflow.com/a/69731240/6696558.
  Completer<T> wrapInCompleter() {
    final completer = Completer<T>();
    then(completer.complete).catchError(completer.completeError);
    return completer;
  }
}
