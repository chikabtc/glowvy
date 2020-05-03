import 'package:Dimodo/common/tools.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/webview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:share/share.dart';
import 'dart:io' show Platform;
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'setting/language.dart';

class SettingScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  SettingScreen({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool enabledNotification = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      checkNotificationPermission();
    });
  }

  void checkNotificationPermission() async {
    try {
      NotificationPermissions.getNotificationPermissionStatus().then((status) {
        if (mounted)
          setState(() {
            enabledNotification = status == PermissionStatus.granted;
          });
      });
    } catch (err) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    kRateMyApp.init().then((_) {});

    TextStyle textStyle = Theme.of(context)
        .textTheme
        .body2
        .copyWith(fontSize: 15, color: kDefaultFontColor);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: Container(),
            backgroundColor: Colors.white,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: DynamicText(S.of(context).accounts,
                  style: textStyle.copyWith(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
              background: Image.network(
                kProfileBackground,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => {
                          (widget.user != null)
                              ? print("logged in")
                              : Navigator.pushNamed(context, "/register")
                        },
                        child: Container(
                          height: 97,
                          color: Colors.white,
                          child: Row(children: <Widget>[
                            Container(width: 16),
                            CircleAvatar(
                              radius: 32.5,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/icons/setting/profile-picture.png',
                                ),
                              ),
                            ),
                            Container(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                DynamicText(
                                    (widget.user != null)
                                        ? S.of(context).welcomeToDimodo
                                        : S.of(context).clickToSignIn,
                                    style: textStyle.copyWith(
                                        fontWeight: FontWeight.w600)),
                                Container(height: 5),
                                DynamicText(
                                    (widget.user != null &&
                                            widget.user.fullName != null)
                                        ? widget.user.fullName
                                        : "Shop like Korean",
                                    style: textStyle.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color:
                                            kDarkSecondary.withOpacity(0.5))),
                              ],
                            ),
                          ]),
                        ),
                      ),
                      Container(
                        height: 5.0,
                        color: kDefaultBackground,
                      ),
                      SettingCard(
                        title: S.of(context).orderHistory,
                        onTap: () => widget.user == null
                            ? Navigator.pushNamed(context, "/login")
                            : Navigator.pushNamed(context, "/orders"),
                        trailingWidget: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              DynamicText(S.of(context).viewAll,
                                  style: kBaseTextStyle.copyWith(
                                    fontSize: 12,
                                    color: kDarkSecondary.withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                  )),
                              // Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black26)
                            ]),
                      ),
                      kFullDivider,
                      SettingCard(
                          title: S.of(context).customerSupport,
                          onTap: () =>
                              CustomerSupport.openFacebookMessenger(context)),
                      kFullDivider,
                      SettingCard(
                          title: S.of(context).feedback,
                          onTap: () async => {
                                await FlutterMailer.send(MailOptions(
                                  body: '',
                                  subject: 'Feedback',
                                  recipients: ['support@dimodo.inbox.ai'],
                                ))
                              }),
                      kFullDivider,
                      Container(height: 5, color: kDefaultBackground),
                      kDivider,
                      SettingCard(
                        title: S.of(context).shippingAddress,
                        onTap: () => widget.user == null
                            ? Navigator.pushNamed(context, "/login")
                            : Navigator.pushNamed(context, "/manage_address"),
                      ),
                      Container(height: 5, color: kDefaultBackground),
                      kDivider,
                      SettingCard(
                        title: S.of(context).rateTheApp,
                        trailingWidget: SvgPicture.asset(
                            'assets/icons/setting/rate.svg',
                            width: 24),
                        onTap: () => kRateMyApp
                            .showRateDialog(context)
                            .then((v) => setState(() {})),
                      ),
                      kFullDivider,
                      SettingCard(
                        title: S.of(context).share,
                        trailingWidget: SvgPicture.asset(
                            'assets/icons/setting/share.svg',
                            width: 24),
                        onTap: () => Share.share(
                          Platform.isAndroid
                              ? "ca-app-pub-8984237340323037/4196743612"
                              : "ca-app-pub-8984237340323037/8355480475",
                        ),
                      ),
                      kFullDivider,
                      SettingCard(
                          title: S.of(context).privacyPolicy,
                          trailingWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                DynamicText("1.0",
                                    style: textStyle.copyWith(
                                      fontSize: 12,
                                      color: kDarkSecondary.withOpacity(0.5),
                                      fontWeight: FontWeight.w500,
                                    )),
                                // CommonIcons.arrowForward
                              ]),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebView(
                                      url:
                                          "https://sites.google.com/view/dimodo/home",
                                      title: "DIMODO PRIVACY POLICY")))),
                      SettingCard(
                          title: S.of(context).language,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Language()))),
                      kFullDivider,
                      if (widget.user == null)
                        SettingCard(
                          fontColor: kDarkSecondary,
                          title: S.of(context).login,
                          trailingWidget: null,
                          onTap: () => Navigator.pushNamed(context, "/login"),
                        ),
                      if (widget.user != null)
                        SettingCard(
                          trailingWidget: null,
                          fontColor: kDarkSecondary,
                          title: S.of(context).logout,
                          onTap: widget.onLogout,
                        ),
                      Expanded(child: Container(color: kDefaultBackground))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  final String title;
  final Function onTap;
  final trailingWidget;
  final Color color;
  final fontColor;

  SettingCard(
      {this.title,
      this.onTap,
      this.fontColor = kDarkBG,
      this.trailingWidget =
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
      this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: color,
        margin: EdgeInsets.only(bottom: 1.0),
        elevation: 0,
        child: ListTile(
          onTap: onTap,
          title: DynamicText(title,
              style: kBaseTextStyle.copyWith(
                  color: fontColor, fontWeight: FontWeight.w600)),
          trailing: trailingWidget,
          contentPadding: EdgeInsets.only(left: 15, right: 15),
        ));
  }
}
