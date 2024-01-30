import 'dart:ffi';

import 'package:address_form/address_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import '../../globals.dart';
import '../../extensions.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import 'orders_screen.dart';

import 'orders_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  static const routeName = '/place-order';

  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool loading = false;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  late Cart cart;
  late Orders orders;

  @override
  void initState() {
    cart = Provider.of<Cart>(context, listen: false);
    orders = Provider.of<Orders>(context, listen: false);
    super.initState();
  }

  OutlineInputBorder? border;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<AddressFormState> mainKey = GlobalKey<AddressFormState>();

  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("Place Order")),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tr("Address"),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    AddressForm(
                      apiKey: "AIzaSyAe6gIQpu5YJjnhvu4SXFK6zRhHACjBQQ8",
                      mainKey: mainKey,
                      key: mainKey,
                      addressController: address1Controller,
                      address2Controller: address2Controller,
                      zipController: postcodeController,
                      cityController: cityController,
                      streetAddressLabel: tr("Street address"),
                      secondaryAddressLabel: tr("Apt, suite, etc."),
                      cityLabel: tr("City"),
                      zipLabel: tr("Postcode"),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tr('Payment'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    CreditCardWidget(
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView: false,
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                    ),
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      themeColor: Globals.configuration.primaryColor,
                      textColor: Colors.black,
                      cardNumberDecoration: InputDecoration(
                        labelText: tr('Cart Number'),
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: const TextStyle(color: Colors.black87),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        border: const OutlineInputBorder(),
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black87),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        border: const OutlineInputBorder(),
                        labelText: tr('Expired Date'),
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black87),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        border: const OutlineInputBorder(),
                        labelText: tr('CVV'),
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black87),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        border: const OutlineInputBorder(),
                        labelText: tr('Cart Holder'),
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    GestureDetector(
                      onTap: _onValidate,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          tr('Place Order'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'halter',
                            fontSize: 14,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          loading
              ? Positioned.fill(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Globals.configuration.loadingScreenModel.color,
                    )),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  void _onValidate() async {
    if (formKey.currentState!.validate() &&
        address1Controller.text.isNotEmpty &&
        address2Controller.text.isNotEmpty &&
        postcodeController.text.isNotEmpty &&
        cityController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });
      final address = Address(
        address: address1Controller.text,
        address2: address2Controller.text,
        postcode: postcodeController.text,
        city: cityController.text,
      );
      orders.addOder(
          cart.items.values.toList(), double.parse(cart.totalAmount), address);
      await Future.delayed(const Duration(seconds: 3));
      cart.empty();
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Payment is success',
              style: TextStyle(color: Colors.green),
            ),
            content: const Text(
                'You ordered the products successfuly. Please go to the orders page to check details'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text(
                  'Orders',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(this.context)
                    ..pop()
                    ..pop()
                    ..pushNamed(OrdersScreen.routeName);
                },
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please check that all fields(Address & Payment) is filled!",
            textAlign: TextAlign.center,
          ),
        ).toStandart,
      );
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
    });
  }
}
