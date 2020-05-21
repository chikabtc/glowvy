import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/constants.dart';

/// Server config
//todo: Dimodo Server
const serverConfig = {
  "url": "http://dimodo.app",
  "consumerKey": "ck_b7594bc4391db4b56c635fe6da1072a53ca4535a",
  "consumerSecret": "cs_980b9edb120e15bd2a8b668cacc734f7eca0ba40",
  "forgetPassword": "http://demo.mstore.io/wp-login.php?action=lostpassword"
};

const afterShip = {
  "api": "e2e9bae8-ee39-46a9-a084-781d0139274f",
  "tracking_url": "https://Dimodo.aftership.com"
};

const Payments = {
  "paypal": "assets/icons/payment/paypal.png",
  "stripe": "assets/icons/payment/stripe.png",
  "razorpay": "assets/icons/payment/razorpay.png",
};

/// The product variant config
const ProductVariantLayout = {
  "color": "color",
  "size": "box",
  "height": "option",
};

const kAdvanceConfig = {
  "DefaultLanguage": "vi",
  "DefaultCurrency": {
    "symbol": "đ",
    "decimalDigits": 0,
    "symbolBeforeTheNumber": false,
    "currency": "VND",
    "multiplier": 19,
  },
  "IsRequiredLogin": false,
  "GuestCheckout": true,
  "EnableShipping": true,
  "EnableAddress": true,
  "EnableReview": true,
  "GridCount": 3,
  "DetailedBlogLayout": kBlogLayout.halfSizeImageType,
  "EnablePointReward": true,
  "DefaultPhoneISOCode": "+84",
  "DefaultCountryISOCode": "VN",
  "EnableRating": true,
  "EnableSmartChat": false,
  "hideOutOfStock": true,
  'allowSearchingAddress': true,
  "isCaching": false,
  "OnBoardOnlyShowFirstTime": true,
  "EnableConfigurableProduct": false, //for magento
  "EnableAttributesConfigurableProduct": ["color", "size"], //for magento
  "EnableAttributesLabelConfigurableProduct": ["color", "size"], //for magento,
  "Currencies": [
    {
      "symbol": "\$",
      "decimalDigits": 2,
      "symbolBeforeTheNumber": true,
      "currency": "USD"
    },
    {
      "symbol": "đ",
      "decimalDigits": 0,
      "symbolBeforeTheNumber": false,
      "currency": "VND",
      "multiplier": 20,
    }
  ]
};

/// The Google API Key to support Pick up the Address automatically
/// We recommend to generate both ios and android to restrict by bundle app id
/// The download package is remove these keys, please use your own key
const kGoogleAPIKey = {
  "android": "your-google-api-key",
  "ios": "your-google-api-key"
};

/// use to config the product image height for the product detail
/// height=(percent * width-screen)
/// isHero: support hero animate
const kProductDetail = {
  "height": 0.5,
  "marginTop": 0,
  "isHero": true,
  "safeArea": false,
  "showVideo": true,
  "showThumbnailAtLeast": 3,
  "layout": kProductLayout.simpleType
};

/// config for the chat app
const smartChat = [
  {
    'app': 'whatsapp://send?phone=84327433006',
    'iconData': FontAwesomeIcons.whatsapp
  },
  {'app': 'tel:8499999999', 'iconData': FontAwesomeIcons.phone},
  {'app': 'sms://8499999999', 'iconData': FontAwesomeIcons.sms}
];
const String adminEmail = "admininspireui@gmail.com";

/// the welcome screen data
List onBoardingData = [
  {
    "title": "Shop Genuine Korean Brands",
    "image": "assets/images/onboarding/onborading-illustration-1.png",
    "indicator": "assets/images/onboarding/logo1.png",
    "widthImage": "400",
    "heightImage": "395",
    "desc": "Guaranteed the quality of Korean standard products. "
  },
  {
    "title": "With Guaranteed Support",
    "image": "assets/images/onboarding/onborading-illustration-2.png",
    "indicator": "assets/images/onboarding/logo2.png",
    "widthImage": "400",
    "heightImage": "395",
    "desc": "Genuine security and 7 days after sales worry free."
  },
  {
    "title": "Into Ulzzang Fashion Trend",
    "image": "assets/images/onboarding/onborading-illustration-3.png",
    "indicator": "assets/images/onboarding/logo3.png",
    "widthImage": "400",
    "heightImage": "395",
    "desc": "Directly ship from Korea with a reasonable price!"
  },
];

const PaypalConfig = {
  "clientId":
      "ASlpjFreiGp3gggRKo6YzXMyGM6-NwndBAQ707k6z3-WkSSMTPDfEFmNmky6dBX00lik8wKdToWiJj5w",
  "secret":
      "ECbFREri7NFj64FI_9WzS6A0Az2DqNLrVokBo0ZBu4enHZKMKOvX45v9Y1NBPKFr6QJv2KaSp5vk5A1G",
  "production": false,
  "paymentMethodId": "paypal",
  "enabled": true,
  "returnUrl": "http://return.example.com",
  "cancelUrl": "http://cancel.example.com",
};

const TapConfig = {
  "SecretKey": "sk_test_XKokBfNWv6FIYuTMg5sLPjhJ",
  "RedirectUrl": "http://your_website.com/redirect_url",
  "paymentMethodId": "",
  "enabled": false
};

// Limit the country list from Billing Address
const List DefaultCountry = [];
//const List DefaultCountry = [
//  {
//    "name": "Vietnam",
//    "iosCode": "VN",
//    "icon": "https://cdn.britannica.com/41/4041-004-A06CBD63/Flag-Vietnam.jpg"
//  },
//  {
//    "name": "India",
//    "iosCode": "IN",
//    "icon":
//        "https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png"
//  },
//  {"name": "Austria", "iosCode": "AT", "icon": ""},
//];
