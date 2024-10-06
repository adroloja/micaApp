import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/controller/auth/keycloak/CheckUserController.dart';
import 'package:mica/controller/house_images/get_ids_controller.dart';
import 'package:mica/controller/house_images/get_images_controller.dart';
import 'package:mica/controller/lottery/BuyLotteryNumberController.dart';
import 'package:mica/controller/lottery_date/get_lottery_date.dart';
import 'package:mica/dto/BuyLotteryDTO.dart';
import 'package:mica/dto/ImageHouseDTO.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar_gift.dart';
import 'package:mica/widget/custom_buy_button.dart';
import 'package:mica/widget/custom_round_buttom.dart';
import 'package:mica/widget/generated_numbers_dialog.dart';

class GiftNumberScreen extends StatefulWidget {
  const GiftNumberScreen({Key? key}) : super(key: key);

  @override
  _GiftNumberScreenState createState() => _GiftNumberScreenState();
}

class _GiftNumberScreenState extends State<GiftNumberScreen> {
  final TextEditingController counterController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  int currentValue = 1;
  bool buttonEnabled = false;
  bool isInPromo = false;
  bool isFinalCoutdown = false;
  int counterPromo = 0;
  double price = 2.99;
  double total = 2.99;

  List<ImageHouseDTO> imageList = [];
  static const String storedIdsKey = 'stored_image_ids';

  @override
  void initState() {
    checkCountdown();
    counterController.text = "1";
    checkPromo();
    super.initState();
    checkForNewImages();
  }

  checkPromo() async {
    String? promo = await SecureStorage.read(key: "promo");
    if (promo != null) {
      isInPromo = true;
      counterPromo = int.tryParse(promo)!;
      setState(() {});
    }
  }

  Future<void> checkForNewImages() async {
    GetIdsController getIdsController = GetIdsController();
    List<ImageHouseDTO> response = await getIdsController.getIds();
    List<int> newIds = response.map((e) => e.id).toList();

    String? storedIdsJson = await SecureStorage.read(key: storedIdsKey);
    List<int> storedIds =
        storedIdsJson != null ? List<int>.from(jsonDecode(storedIdsJson)) : [];

    bool isNewImage = false;

    for (var id in newIds) {
      if (!storedIds.contains(id)) {
        isNewImage = true;
        break;
      }
    }

    if (isNewImage || newIds.length != storedIds.length) {
      await clearOldImages(storedIds);
      await getImages(response);
      await SecureStorage.write(key: storedIdsKey, value: jsonEncode(newIds));
    } else {
      await loadStoredImages(response);
    }
  }

  Future<void> clearOldImages(List<int> storedIds) async {
    for (var id in storedIds) {
      await SecureStorage.delete(key: id.toString());
    }
  }

  Future<void> getImages(List<ImageHouseDTO> response) async {
    GetImagesController getImagesController = GetImagesController();
    List<ImageHouseDTO> images = await getImagesController.getImages();

    for (var image in images) {
      await SecureStorage.write(
          key: image.id.toString(), value: image.imageBase64!);
    }

    setState(() {
      imageList = images;
    });
  }

  Future<void> loadStoredImages(List<ImageHouseDTO> response) async {
    List<ImageHouseDTO> storedImages = [];

    for (var image in response) {
      String? imageBase64 = await SecureStorage.read(key: image.id.toString());
      if (imageBase64 != null) {
        storedImages.add(ImageHouseDTO(id: image.id, imageBase64: imageBase64));
      }
    }

    setState(() {
      imageList = storedImages;
    });
  }

  Future<void> handlePurchase() async {
    setState(() {
      buttonEnabled = false;
    });

    try {
      int amount = int.parse(counterController.value.text);
      BuyLotteryDTO buyLotteryDTO = BuyLotteryDTO(
        email: Credentials.email!.trim().toLowerCase(),
        amount: amount,
        isAGift: true,
        userGiftEmail: usernameController.value.text.trim().toLowerCase(),
      );
      Credentials.giftEmail =
          usernameController.value.text.trim().toLowerCase();

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
                  "\n Enhorabuena, acabas de recibir un ticket de regalo tú y el propietario del código, puedes ver el número regalado en tus tickets. Gracias. \n");
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
              isGift: true,
            );
          },
        );
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            msg:
                "\n Enhorabuena, la compra se ha efectuado exitosamente, puedes ver tus números en la ventana de Mis números. Gracias. \n");
      }
    } catch (e) {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          msg: "\n Ocurrió un error al realizar la compra. \n");
    } finally {
      setState(() {
        buttonEnabled = true;
      });
    }
  }

  checkCountdown() async {
    final now = DateTime.now();
    DateTime? countdown = await getDate();
    if (countdown != null) {
      final difference = countdown.difference(now);

      if (difference.inHours < 1) {
        if (mounted) {
          setState(() {
            isFinalCoutdown = true;
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

  void checkEmail(String email) async {
    if (email.toLowerCase() == Credentials.email!.toLowerCase()) {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          msg: "\n No puedes regalarte a ti mismo, gracias \n");
      return;
    }
    if (email.isNotEmpty) {
      CheckUserController userController = CheckUserController();
      bool response = await userController.check(email.toLowerCase());
      if (Credentials.isEnabled && !isFinalCoutdown) {
        buttonEnabled = response;
      } else {
        buttonEnabled = false;
      }

      if (!response) {
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            msg: "\n El usuario con email $email no existe \n");
      } else {
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            msg:
                "\n El usuario con email $email existe, el botón se ha habilitado, gracias \n");
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackBarGift(
        route: "main",
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            final buttonSize = screenWidth * 0.10;
            final textSize = screenWidth * 0.05;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  SizedBox(
                    height: screenHeight * 0.09,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          child: Icon(
                            Icons.person,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            onEditingComplete: () {
                              String email = usernameController.value.text
                                  .trim()
                                  .toLowerCase();
                              checkEmail(email);
                            },
                            onFieldSubmitted: (_) {
                              String email = usernameController.value.text
                                  .trim()
                                  .toLowerCase();
                              checkEmail(email);
                            },
                            onTapOutside: (event) {
                              String email = usernameController.value.text
                                  .trim()
                                  .toLowerCase();
                              checkEmail(email);
                            },
                            controller: usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Introduce el email',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            String email = usernameController.value.text;
                            if (email.isNotEmpty) {
                              checkEmail(email);
                            } else {
                              Fluttertoast.showToast(
                                  fontSize: 18,
                                  toastLength: Toast.LENGTH_LONG,
                                  msg:
                                      "\n Escriba el email antes de comprobar, gracias. \n");
                            }
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  if (imageList.isNotEmpty) ...[
                    CarouselSlider(
                      options: CarouselOptions(
                        height: screenHeight * 0.472,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                      ),
                      items: imageList.map((imageHouseDTO) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.memory(
                                  base64Decode(imageHouseDTO.imageBase64!),
                                  fit: BoxFit.cover,
                                  width: 1000.0,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ] else ...[
                    // Opcional: Puedes mostrar un texto o indicador de carga si no hay imágenes
                    const Text(
                      "Cargando imágenes...",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                  SizedBox(height: screenHeight * 0.01),
                  const AutoSizeText(
                    "Por tan solo 2.99 dólares, participa en nuestro sorteo. Para más información presion el botón 'Premio'",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        isInPromo
                            ? Text(
                                "Promoción activada: $counterPromo/10",
                                style: const TextStyle(color: Colors.green),
                              )
                            : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove,
                                      size: buttonSize * 0.8),
                                  onPressed: decrementValue,
                                ),
                                SizedBox(width: screenWidth * 0.025),
                                SizedBox(
                                  width: 50,
                                  height: 30,
                                  child: TextFormField(
                                    controller: counterController,
                                    onChanged: (value) {
                                      setState(() {
                                        currentValue = int.tryParse(
                                                counterController.text) ??
                                            1;
                                        total = price * currentValue;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(bottom: 5),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.025),
                                IconButton(
                                  icon: Icon(Icons.add, size: buttonSize * 0.8),
                                  onPressed: incrementValue,
                                )
                              ],
                            ),
                            Text(
                              "${total.toStringAsFixed(2)}\$",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomBuyButton(
                    onPressed: handlePurchase,
                    isEnabled: buttonEnabled,
                  ),
                  SizedBox(height: screenHeight * 0.035),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/list_gift');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_alt,
                          color: Colors.lightBlueAccent,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Números Regalados",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
