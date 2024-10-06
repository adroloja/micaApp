import 'package:flutter/material.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/billing_data/credit_card_widget.dart';
import 'package:mica/widget/billing_data/edit_credit_card_widget.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';
import 'package:mica/widget/custom_drawer.dart';

class BillingDataScreen extends StatefulWidget {
  const BillingDataScreen({Key? key}) : super(key: key);

  @override
  _BillingDataScreenState createState() => _BillingDataScreenState();
}

class _BillingDataScreenState extends State<BillingDataScreen> {
  String cardNumber = '';
  String cardHolder = '';
  String expiryDate = '';
  bool isEditMode = false;

  @override
  void initState() {
    checkBillingData().then((value) {
      if (!value) {
        setState(() {
          isEditMode = true;
        });
      }
    });
    super.initState();
  }

  Future<bool> checkBillingData() async {
    String? cardNumberS = await SecureStorage.read(key: "card_number");
    String? cardHolderS = await SecureStorage.read(key: "card_holder");
    String? expiryDateS = await SecureStorage.read(key: "expiryDate");

    if (cardNumberS == null || cardHolderS == null || expiryDateS == null) {
      return false;
    } else {
      setState(() {
        cardNumber = cardNumberS;
        cardHolder = cardHolderS;
        expiryDate = expiryDateS;
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackBar(
        route: "profile",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CreditCardWidget(
                  cardNumber: cardNumber,
                  cardHolder: cardHolder,
                  expiryDate: expiryDate,
                ),
                const SizedBox(height: 20),
                isEditMode
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isEditMode = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 20,
                                  )),
                            ],
                          ),
                          EditCreditCardWidget(
                            initialCardNumber: cardNumber,
                            initialCardHolder: cardHolder,
                            initialExpiryDate: expiryDate,
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditMode = true;
                          });
                        },
                        child: const Text("Editar")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
