import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../common/locator .dart';
import '../common/push_notification_service.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final siteCookie;

  WebViewContainer(this.url, this.siteCookie);

  @override
  createState() => _WebViewContainerState(this.url, this.siteCookie);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  var _url;
  var siteCookie;
  final _key = UniqueKey();
  final CookieManager cookieManager = CookieManager.instance();
  _WebViewContainerState(this._url, this.siteCookie);

  @override
  void initState() {
    super.initState();

    print(siteCookie);

    init();
  }

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _pushNotificationService.initialise();

    cookieManager.setCookie(
      url: Uri.parse(_url),
      name: ".AspNetCore.Identity.Application",
      value: siteCookie['.AspNetCore.Identity.Application'],
    );

    cookieManager.setCookie(
      url: Uri.parse(_url),
      name: ".AspNetCore.Identity.ApplicationC1",
      value: siteCookie['.AspNetCore.Identity.ApplicationC1'],
    );
    //.AspNetCore.Identity.ApplicationC2
    cookieManager.setCookie(
      url: Uri.parse(_url),
      name: ".AspNetCore.Identity.ApplicationC2",
      value: siteCookie['.AspNetCore.Identity.ApplicationC2'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Expanded(
            child: InAppWebView(
          key: _key,
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED);
          },
          initialUrlRequest: URLRequest(url: Uri.parse(_url)),
          //initialOptions: siteCookie,
        ))
      ],
    )));
  }
}
