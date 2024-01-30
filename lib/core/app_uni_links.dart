import 'package:uni_links/uni_links.dart';

import '../extensions.dart';

class UniLinksHelper {
  static void listenDeepLink() async {
    Future.delayed(
        const Duration(seconds: 1), () async => await getInitialUri());
    uriLinkStream.listen((uri) => _initLink(uri));
  }

  static void _initLink(Uri? uri) {
    if (uri == null) return;

    if (uri.scheme == "https" || uri.scheme == "http") {
      uri.toString().toLinkRedirector?.redirect();
    } else {
      var initialLink = uri.queryParameters["link"];

      if (initialLink == null) return;

      Uri? initialLinkURI = Uri.tryParse(initialLink);
      if (initialLinkURI != null) {
        initialLink.toString().toLinkRedirector?.redirect();
      }
    }
  }
}
