import 'package:Dimodo/common/constants.dart';
import 'package:flutter/material.dart';
import '../../generated/i18n.dart';
import '../../models/address/address.dart';
import '../../models/address/province.dart';
import '../../models/address/ward.dart';
import '../../models/address/district.dart';
import '../../models/address/addressModel.dart';

import '../../models/user/user.dart';
import '../../models/user/userModel.dart';

import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'customTextFormField.dart';
import 'package:Dimodo/widgets/circular_checkbox.dart';

class AddShippingAddress extends StatefulWidget {
  final Address address;

  AddShippingAddress({this.address});
  @override
  _AddShippingAddressState createState() => _AddShippingAddressState();
}

class _AddShippingAddressState extends State<AddShippingAddress>
    with TickerProviderStateMixin {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();
  TextEditingController _districtWardController = TextEditingController();
  AnimationController _loginButtonController;

  Address address = Address(
      ward: Ward(district: District(), province: Province()), isDefault: false);
  int currentPage = 0;
  AddressModel addressModel = AddressModel();
  bool isLoading = false;
  bool isEditing = false;
  User user;

  List<District> districts = [];
  List<Ward> wards = [];

  @override
  void initState() {
    super.initState();
    isEditing = widget.address != null ? true : false;
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);

    if (widget.address != null) {
      address = widget.address;
      WidgetsBinding.instance.addPostFrameCallback((_) => updateState());
    }
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    user = Provider.of<UserModel>(context, listen: false).user;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: kSecondaryWhite,
          width: screenSize.width,
          height: screenSize.height,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                brightness: Brightness.light,
                leading: IconButton(
                  icon: CommonIcons.arrowBackward,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                      widget.address != null
                          ? S.of(context).editShippingAddress
                          : S.of(context).addAddress,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 15,
                          color: kDarkAccent,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      color: Colors.transparent,
                      width: screenSize.width,
                      child: Container(
                        color: Colors.transparent,
                        width: screenSize.width,
                        height: screenSize.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                        child: Stack(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomTextFormField(
                                    nameController: _nameController,
                                    labelText: S.of(context).fullName,
                                    address: address),
                                Container(
                                  height: 10,
                                  color: kDefaultBackground,
                                ),
                                CustomTextFormField(
                                    isNumber: true,
                                    nameController: _phoneNumberController,
                                    labelText: S.of(context).phoneNumber,
                                    hintText:
                                        S.of(context).intputReceiverPhoneNumber,
                                    address: address),
                                Container(
                                  height: 10,
                                  color: kDefaultBackground,
                                ),
                                GestureDetector(
                                  onTap: () => showAreas(context),
                                  child: Container(
                                    color: Colors.white,
                                    width: screenSize.width,
                                    child: CustomTextFormField(
                                        nameController: _provinceController,
                                        isEnabled: false,
                                        labelText: S.of(context).province,
                                        address: address),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => showAreas(context),
                                  child: Container(
                                    color: Colors.white,
                                    width: screenSize.width,
                                    child: CustomTextFormField(
                                        nameController: _districtWardController,
                                        isEnabled: false,
                                        labelText: S.of(context).district +
                                            " / " +
                                            S.of(context).ward,
                                        address: address),
                                  ),
                                ),
                                CustomTextFormField(
                                    nameController: _streetNameController,
                                    labelText: S.of(context).streetName,
                                    isBorderNeeded: false,
                                    isMaxLineOne: true,
                                    address: address),
                                Container(
                                  height: 10,
                                  color: kDefaultBackground,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 16, left: 16),
                                  color: Colors.white,
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      address.isDefault = !address.isDefault;
                                    }),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: SizedBox(
                                            width: Checkbox.width,
                                            height: Checkbox.width,
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                border: Border.all(
                                                  color: kSecondaryGrey,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5),
                                              ),
                                              child: Theme(
                                                data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.transparent,
                                                ),
                                                child: Checkbox(
                                                  activeColor: kPinkAccent,
                                                  value: address.isDefault,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      address.isDefault = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          "Set as default",
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: kDarkAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    color: Colors.white,
                                    height: 48,
                                    width: screenSize.width),
                                Expanded(
                                  child: Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 40.0,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          StaggerAnimation(
                                            height: 48,
                                            buttonTitle: S.of(context).save,
                                            buttonController:
                                                _loginButtonController.view,
                                            onTap: () {
                                              if (!isLoading) {
                                                widget.address != null
                                                    ? _updateAddress(
                                                        address, context)
                                                    : _createAddress(
                                                        address, context);
                                              }
                                            },
                                          ),
                                          SizedBox(height: 27),
                                          isEditing
                                              ? GestureDetector(
                                                  onTap: () => _deleteAddress(
                                                      address, context),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                          "assets/icons/address/trash.svg"),
                                                      Text(
                                                        S.of(context).cancel,
                                                        style: kBaseTextStyle
                                                            .copyWith(
                                                                color:
                                                                    kSecondaryGrey,
                                                                fontSize: 13),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {}
  }

  void _failMessage(message, context) {
    FocusScope.of(context).requestFocus(FocusNode());

    final snackBar = SnackBar(
      content: Text(
        'Warning: $message',
        style: kBaseTextStyle.copyWith(color: Colors.white),
      ),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {},
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  _updateAddress(Address address, context) async {
    print("address to update:${address.toJson()}");
    _playAnimation();
    Provider.of<UserModel>(context, listen: false).updateAddress(
      address: address,
      token: user.accessToken,
      success: (isSuccess) {
        _stopAnimation();
        // address.saveAddress();

        Navigator.of(context).pop();
      },
      fail: (message) {
        print("msg: $message");
        _stopAnimation();
        // _failMessage(message, context);
      },
    );
  }

  _createAddress(Address address, context) async {
    print("address to create:${address.toJson()}");
    _playAnimation();
    Provider.of<UserModel>(context, listen: false).createAddress(
      address: address,
      success: (isSuccess) {
        _stopAnimation();
        Navigator.of(context).pop();
      },
      fail: (message) {
        print("msg: $message");
        _stopAnimation();
        // _failMessage(message, context);
      },
    );
  }

  _deleteAddress(Address address, context) async {
    print("address to delete:${address.toJson()}");
    _playAnimation();
    Provider.of<UserModel>(context, listen: false).deleteAddress(
      address: address,
      success: (isSuccess) {
        _stopAnimation();
        Navigator.of(context).pop();
      },
      fail: (message) {
        print("msg: $message");
        _stopAnimation();
      },
    );
  }

  void updateState() async {
    setState(() {
      _nameController.text = address.recipientName;
      _phoneNumberController.text = address.phoneNumber.toString();
      _provinceController.text = address.ward.province.name;
      _districtWardController.text =
          address.ward.district.name + "   " + address.ward.name;
      _streetNameController.text = address.street;
    });
  }

  List<Widget> renderTabbar() {
    List<String> tabList = ["Province", "District", "Ward"];
    List<Widget> list = [];

    tabList.asMap().forEach((index, item) {
      list.add(Container(
        child: Tab(
            child: Text(item,
                style: kBaseTextStyle.copyWith(
                    fontSize: 13,
                    color: currentPage == index ? kPinkAccent : kSecondaryGrey,
                    fontWeight: FontWeight.w600))),
      ));
    });
    return list;
  }

  renderAreas({StateSetter onTap}) {
    switch (currentPage) {
      case 0:
        return Expanded(
          child: ListView.builder(
            itemCount: addressModel.provinces.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  address.ward.province.name =
                      addressModel.provinces[index].name;
                  addressModel.districts = await addressModel.getDistricts(
                      provinceId: addressModel.provinces[index].id);
                  print("chosen province name: ${address.ward.province.name}");
                  DefaultTabController.of(context).animateTo(1);
                  onTap(() => currentPage = 1);
                },
                title: Text(
                  '${addressModel.provinces[index].name}',
                  style: kBaseTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        );
        break;
      case 1:
        return Expanded(
          child: ListView.builder(
            itemCount: addressModel.districts.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  addressModel.wards = await addressModel.getWards(
                      districtId: addressModel.districts[index].id);
                  address.ward.district.name =
                      addressModel.districts[index].name;
                  print("chosen district name: ${address.ward.district.name}");

                  DefaultTabController.of(context).animateTo(2);
                  onTap(() => currentPage = 2);
                },
                title: Text(
                  '${addressModel.districts[index].name}',
                  style: kBaseTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        );
        break;
      case 2:
        return Expanded(
          child: ListView.builder(
            itemCount: addressModel.wards.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  address.ward.name = addressModel.wards[index].name;
                  address.ward.id = addressModel.wards[index].id;
                  address.wardId = addressModel.wards[index].id;
                  print("chosen ward: ${address.ward.name}");

                  updateState();

                  onTap(() => Navigator.of(context).pop());
                },
                title: Text(
                  '${addressModel.wards[index].name}',
                  style: kBaseTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        );
    }
  }

  void showAreas(context) {
    currentPage = 0;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: 1 -
                    (AppBar().preferredSize.height +
                            MediaQuery.of(context).padding.bottom) /
                        kScreenSizeHeight,
                child: DefaultTabController(
                  length: 3,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      width: kScreenSizeWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Container(
                                color: Colors.transparent,
                                height: AppBar().preferredSize.height,
                                width: kScreenSizeWidth,
                                child: Center(
                                  child: Text(S.of(context).deliveryArea,
                                      style: kBaseTextStyle.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                )),
                            Positioned(
                              top: 6,
                              right: 0,
                              child: IconButton(
                                  icon: SvgPicture.asset(
                                      'assets/icons/address/close-popup.svg'),
                                  onPressed: () {
                                    currentPage = 0;
                                    Navigator.pop(context);
                                  }),
                            )
                          ]),
                          IgnorePointer(
                            ignoring: true,
                            child: TabBar(
                              isScrollable: true,
                              indicatorColor: kPinkAccent,
                              onTap: (index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              tabs: renderTabbar(),
                            ),
                          ),
                          renderAreas(onTap: setState)
                        ],
                      )),
                ),
              );
            },
          );
        });
  }

  bool get wantKeepAlive => true;
}
