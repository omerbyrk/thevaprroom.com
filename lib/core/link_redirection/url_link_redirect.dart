import '../app_helper.dart';
import 'link_redirector.dart';

class URLLinkRedirect extends LinkRedirector {
  URLLinkRedirect(super.link);

  @override
  void redirect() async {
    await super.readyToRedirect;
    await Future.delayed(super.duration);
    AppHelper.loadUrlInWebview(link);
  }
}
