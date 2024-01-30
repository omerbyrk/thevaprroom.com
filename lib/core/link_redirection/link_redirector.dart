import '../../globals.dart';

abstract class LinkRedirector {
  final String link;
  Duration duration;
  LinkRedirector(this.link, {this.duration = Duration.zero});
  void redirect();

  Future<void> get readyToRedirect async {
    await Globals.waitForBuildContext;
  }
}
