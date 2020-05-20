import 'package:Dimodo/models/coupon.dart';
import 'package:Dimodo/models/order/cartItem.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../product/product.dart';
import '../product/product.dart';
import '../address/address.dart';
import '../user/userModel.dart';
import '../address/billing.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../services/index.dart';
import '../../common/config.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CartModel with ChangeNotifier {
  CartModel() {
    updateFees();
  }

  UserModel userModel;

  Address address;
  Billing billing;
  String currency;
  double shippingFeePerItem = 50000;
  double totalShippingFee = 0;
  double totalServiceFee = 0;
  double totalImportTax = 0;
  double subTotalFee = 0;
  double totalFee = 0;
  double subTotal = 0;
  double totalDiscounts = 0.0;
  Services _services = Services();

  // The productIDs and product Object currently in the cart.
  Map<int, CartItem> cartItems = {};
  //selected coupons
  List<Coupon> selectedCoupons = [];

  // The IDs and quantities of products currently in the cart.

  int get totalCartQuantity =>
      cartItems.values.fold(0, (v, e) => v + e.quantity);

  // ===========================================================================
  // CART Manipulation
  // ===========================================================================
  // Adds a product to the cart.
  void addProductToCart({CartItem cartItem, isSaveLocal = true}) async {
    var key = cartItem.optionId;
    print("Adding this product: ${cartItem.product.salePrice}");
    if (!cartItems.containsKey(key)) {
      cartItems[key] = cartItem;
      cartItems[key].quantity = 1;
      await _services.createCartItem(cartItem);
    } else {
      cartItems[key].quantity += cartItem.quantity;
      await _services.updateCartItem(cartItems[key]);
    }

    notifyListeners();
  }

  void addCartItems(Map<int, CartItem> cartItems) {
    this.cartItems = cartItems;
    updateFees();
  }

  void updateQuantity(int key, int quantity) async {
    if (cartItems.containsKey(key)) {
      cartItems[key].quantity = quantity;
      updateQuantityCartLocal(key: key, quantity: quantity);
      await _services.updateCartItem(cartItems[key]);
      updateFees();
      if (totalCartQuantity == 0) {
        selectedCoupons.clear();
        //if the subTotal is above 2 million VND, cancel the free ship coupon
      } else if (subTotal > 2000000) {
        selectedCoupons.forEach((coupon) {
          if (coupon.discountType == "FreeShip") {
            selectedCoupons.remove(coupon);
          }
        });
      }
      notifyListeners();
    }
  }

  // Removes an item from the cart.
  void removeItemFromCart(int key) async {
    if (cartItems.containsKey(key)) {
      removeProductLocal(key);
      if (cartItems[key].quantity == 1) {
        var count = await _services.deleteCartItem(cartItems[key]);

        cartItems.remove(key);
      } else {
        cartItems[key].quantity--;
      }
    }
    if (totalCartQuantity == 0) {
      selectedCoupons.clear();
      totalDiscounts = 0;
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  CartItem getCartItemById(int id) {
    return cartItems[id];
  }

  // Removes everything from the cart.
  void clearCart() {
    clearCartLocal();
    cartItems.clear();
    selectedCoupons.clear();
    totalDiscounts = 0;
    notifyListeners();
  }

  void updateFees() async {
    getShippingFee();
    getSubTotal();
    getServiceFee();
    getTotal();
  }

  Future<CartModel> getAllCartItems(UserModel userModel) async {
    print("get all carts");
    if (userModel.isLoggedIn) {
      print("loading");
      var items = await _services.allCartItems();
      if (items != null) {
        items.forEach((item) {
          cartItems[item.optionId] = item;
        });
      }
    } else {
      print("getAllCartItems failed because not logged in");
    }
    notifyListeners();

    return this;
  }

  void setCoupon(Coupon coupon) async {
    if (!selectedCoupons.contains(coupon)) {
      selectedCoupons.add(coupon);
    } else {
      selectedCoupons.remove(coupon);
    }

    notifyListeners();
  }

  Future<List<Coupon>> getAllCoupons(UserModel userModel) async {
    List<Coupon> coupons = [];
    if (userModel.isLoggedIn) {
      print("loading");
      var items = await _services.getCoupons();
      return items;
    } else {
      print("getAllCoupons failed because not logged in");
    }

    return coupons;
  }

  void saveCartToLocal(CartItem cartItem) async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        List items = await storage.getItem(kLocalKey["cart"]);
        if (items != null && items.isNotEmpty) {
          items.add(cartItem.toJson());
        } else {
          items = [cartItem.toJson()];
        }
        await storage.setItem(kLocalKey["cart"], items);
      }
    } catch (err) {
      print(err);
    }
  }

  void updateQuantityCartLocal({int key, int quantity = 1}) async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        List items = await storage.getItem(kLocalKey["cart"]);
        List results = [];
        if (items != null && items.isNotEmpty) {
          for (var item in items) {
            //update cartItem
            var cartItem = CartItem.fromJson(item);
            cartItem.quantity = quantity;

            results.add(cartItem.toJson());
          }
        }
        await storage.setItem(kLocalKey["cart"], results);
      }
    } catch (err) {
      print(err);
    }
  }

  void getCartDataFromLocal() async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        List items = await storage.getItem(kLocalKey["cart"]);
        if (items != null && items.isNotEmpty) {
          items.forEach((item) {
            addProductToCart(
                cartItem: CartItem.fromJson(item["cart"]), isSaveLocal: false);
          });
        }
      }
    } catch (err) {
      print(err);
    }
  }

  void clearCartLocal() async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        storage.deleteItem(kLocalKey["cart"]);
      }
    } catch (err) {
      print(err);
    }
  }

  void removeProductLocal(int key) async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        List items = await storage.getItem(kLocalKey["cart"]);
        if (items != null && items.isNotEmpty) {
          for (var item in items) {
            //update cartItem
            var cartItem = CartItem.fromJson(item);
            if (item != null) {
              if (item["quantity"] == 1) {
                items.remove(item);
              } else {
                item["quantity"]--;
              }
            }
          }
          await storage.setItem(kLocalKey["cart"], items);
        }
      }
    } catch (err) {
      print(err);
    }
  }

  void changeCurrency(value) {
    currency = value;
  }
  // ===========================================================================
  // FEEs
  // ===========================================================================

  double getSubTotal() {
    subTotal = cartItems.keys.fold(0.0, (sum, key) {
      String price = Tools.getPriceProductValue(
          cartItems[key].product, currency,
          onSale: true);
      // print("subtotal item price: $price");
      if (price.isNotEmpty) {
        subTotalFee = sum + double.parse(price) * cartItems[key].quantity;
        return subTotalFee;
      }
      return sum;
    });
    subTotalFee = subTotal;
    print("subtotal??? $subTotal");
    return subTotal;
  }

  double getServiceFee() {
    totalServiceFee = subTotalFee * 0.08;
    return totalServiceFee;
  }

  double getShippingFee() {
    if (subTotal > 2000000) {
      return 0;
    } else {
      var sum = cartItems.keys.fold(0, (value, i) {
        return value +
            calculateShippingFee(cartItems[i].product).toInt() *
                cartItems[i].quantity;
      });

      return sum.toDouble();
    }
  }

  double calculateShippingFee(Product item) {
    switch (item.categoryId) {
      case 1:
        return 30000;
      case 2:
        return 50000;
      case 3:
        return 50000;
      case 4:
        return 40000;
      case 5:
        return 50000;
      case 6:
        return 60000;
      case 7:
        return 40000;
      case 8:
        return 30000;
      case 9:
        return 30000;
      default:
        return 40000;
        break;
    }
  }

  double getTotal() {
    totalFee = getSubTotal() + getShippingFee() - getTotalDiscounts();
    return totalFee;
  }

  double getTotalDiscounts() {
    if (selectedCoupons.length > 0) {
      totalDiscounts = selectedCoupons.fold(0.0, (value, coupon) {
        if (coupon.discountType == "FreeShip") {
          return value + getShippingFee();
        } else {
          return value + coupon.discountAmount.toDouble();
        }
      });
    } else {
      totalDiscounts = 0;
    }
    print("getTotalDiscounts $totalDiscounts");
    return totalDiscounts;
  }

  double getImportTax() {
    double importTaxPerItem = 16000;
    totalImportTax = totalCartQuantity * importTaxPerItem;
    return totalImportTax;
  }
}
