import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/controller/lottery/BuyLotteryNumberController.dart';
import 'package:mica/controller/lottery_date/get_lottery_date.dart';
import 'package:mica/dto/BuyLotteryDTO.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/custom_buy_button.dart';
import 'package:mica/widget/generated_numbers_dialog.dart';

class BuyButtomWidget extends StatefulWidget {
  final double buttonSize;
  final double screenWidth;
  final double screenHeight;

  const BuyButtomWidget({
    Key? key,
    required this.buttonSize,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  State<BuyButtomWidget> createState() => _BuyButtomWidgetState();
}

class _BuyButtomWidgetState extends State<BuyButtomWidget> {
  final TextEditingController counterController = TextEditingController();
  final FocusNode counterFocusNode = FocusNode();
  int currentValue = 1;
  bool buttonEnabled = true;
  bool isInPromo = false;
  int counterPromo = 0;
  double price = 2.99;
  double total = 2.99;

  @override
  void initState() {
    super.initState();
    checkCountdown();
    counterController.text = "1";
    checkPromo();

    counterFocusNode.addListener(() {
      if (!counterFocusNode.hasFocus) {
        updateTotal();
      }
    });
  }

  void updateTotal() {
    setState(() {
      currentValue = int.tryParse(counterController.text) ?? 1;
      total = price * currentValue;
    });
  }

  checkPromo() async {
    String? promo = await SecureStorage.read(key: "promo");
    if (promo != null) {
      isInPromo = true;
      counterPromo = int.tryParse(promo)!;
      setState(() {});
    }
  }

  void decrementValue() {
    setState(() {
      if (currentValue > 1) {
        currentValue--;
        total = price * currentValue;
        counterController.text = currentValue.toString();
      }
    });
  }

  void incrementValue() {
    setState(() {
      currentValue++;
      total = price * currentValue;
      counterController.text = currentValue.toString();
    });
  }

  checkCountdown() async {
    final now = DateTime.now();
    DateTime? countdown = await getDate();
    if (countdown != null) {
      final difference = countdown.difference(now);

      // Deshabilitar el botón si la diferencia es menor de una hora
      if (difference.inHours < 1) {
        if (mounted) {
          setState(() {
            buttonEnabled = false;
          });
        }
      }
    }
  }

  Future<DateTime?> getDate() async {
    try {
      GetLotteryDate getLotteryDate = GetLotteryDate();
      Response<dynamic> response = await getLotteryDate.getDate();

      // Verificar si la respuesta es exitosa
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        if (data.containsKey("dateTime")) {
          DateTime dateTime = DateTime.parse(data["dateTime"]);
          Credentials.countdown = dateTime;
          return dateTime;
        } else {
          throw Exception(
              "La clave 'dateTime' no está presente en la respuesta.");
        }
      } else {
        throw Exception(
            "Error en la respuesta del servidor: ${response.statusCode}");
      }
    } catch (e) {
      print('Error al obtener la fecha: $e');
    }
    return null;
  }

  @override
  void dispose() {
    counterController.dispose();
    counterFocusNode.dispose();
    super.dispose();
  }

  Future<void> handlePurchase() async {
    updateTotal();
    setState(() {
      buttonEnabled = false; // Deshabilitar el botón
    });

    try {
      print("Email ${Credentials.email!.trim().toLowerCase()}");
      int amount = int.parse(counterController.value.text);
      BuyLotteryDTO buyLotteryDTO = BuyLotteryDTO(
          email: Credentials.email!.trim().toLowerCase(),
          amount: amount,
          isAGift: false,
          userGiftEmail: "");

      if (amount > 0) {
        BuyLotteryNumberController buyLotteryController =
            BuyLotteryNumberController();
        Response response =
            await buyLotteryController.buyLotteryNumber(buyLotteryDTO);

        int numberToRemove = 10000001;
        List<dynamic> list = response.data;
        if (list.contains(numberToRemove)) {
          while (list.contains(numberToRemove)) {
            list.remove(numberToRemove);
          }
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              fontSize: 18,
              msg:
                  "\n Enhorabuena, acabas de recibir un ticket de regalo tú y el propietario del código, puedes ver el número regalado en tus tickets. Gracias.\n");
        }
        String? promo = await SecureStorage.read(key: "promo");
        if (promo != null) {
          counterPromo = int.parse(promo);
          counterPromo = counterPromo + amount;
          await SecureStorage.write(
              key: "promo", value: counterPromo.toString());
          if (counterPromo >= 10) {
            await SecureStorage.delete(key: "promo");
          }
        }
        counterController.text = "1";
        currentValue = 1;
        total = 2.99;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GeneratedNumbersDialog(
              generatedNumbers: list,
              isGift: false,
            );
          },
        );
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            msg:
                "\n Enhorabuena, la compra se ha efectuado exitosamente, puedes ver tus números en la ventana de Mis Tickets. Gracias. \n");
      }
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          msg: "\n Ocurrió un error al realizar la compra. \n");
    } finally {
      setState(() {
        buttonEnabled = true; // Habilitar el botón después de la operación
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              isInPromo
                  ? Text(
                      "Promoción activada: $counterPromo/10",
                      style: TextStyle(color: Colors.green),
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, size: widget.buttonSize * 0.8),
                        onPressed: decrementValue,
                      ),
                      SizedBox(width: widget.screenWidth * 0.025),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: TextFormField(
                          controller: counterController,
                          focusNode: counterFocusNode,
                          onChanged: (value) {
                            updateTotal();
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 5),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.lightBlueAccent,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.lightBlueAccent,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.lightBlueAccent,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: widget.screenWidth * 0.025),
                      IconButton(
                        icon: Icon(Icons.add, size: widget.buttonSize * 0.8),
                        onPressed: incrementValue,
                      )
                    ],
                  ),
                  Text(
                    "${total.toStringAsFixed(2)}\$",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: widget.screenWidth * 0.07,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: widget.screenHeight * 0.025),
        CustomBuyButton(
          onPressed: handlePurchase,
          isEnabled: buttonEnabled,
        ),
      ],
    );
  }
}
