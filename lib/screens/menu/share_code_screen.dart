import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mica/controller/code/code_controller.dart';
import 'package:mica/controller/promotion/promotion_controller.dart';
import 'package:mica/dto/CreatePromotionDTO.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar_doc.dart';
import 'package:flutter/services.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({Key? key}) : super(key: key);

  @override
  _ShareCodeScreenState createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  TextEditingController codeController = TextEditingController();
  TextEditingController newCodeController = TextEditingController();
  TextEditingController repeatCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCode();
  }

  getCode() async {
    try {
      CodeController codeControllerHttp = CodeController();
      String? code = await codeControllerHttp.getCode();
      codeController.text = code!;
      print(code);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Scaffold(
            appBar: const CustomBackBarDoc(
              text: "Comparte y gana",
              route: "main",
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.95,
                      height: screenHeight * 0.28,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15),
                            child: AutoSizeText(
                              "¡Comparte tu código con tus amigos y gana tickets gratis! ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.7,
                                child: TextFormField(
                                  controller: codeController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    Clipboard.setData(ClipboardData(
                                            text: codeController.text))
                                        .then((_) {
                                      Fluttertoast.showToast(
                                          fontSize: 18,
                                          toastLength: Toast.LENGTH_LONG,
                                          msg:
                                              "\n Código copiado al portapapeles \n");
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.content_copy_rounded,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    const AutoSizeText(
                      "¿Te han compartido un código?",
                      style: TextStyle(fontSize: 18),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Container(
                      width: screenWidth * 0.95,
                      height: screenHeight * 0.48,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          const AutoSizeText(
                            "¡Canjéalo aquí!",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          SizedBox(
                            width: screenWidth * 0.77,
                            child: TextFormField(
                              controller: newCodeController,
                              decoration: InputDecoration(
                                hintText: "Código de usuario",
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          // SizedBox(
                          //   width: screenWidth * 0.77,
                          //   child: TextFormField(
                          //     controller: repeatCodeController,
                          //     decoration: InputDecoration(
                          //       hintText: "Repite el código de usuario",
                          //       filled: true,
                          //       fillColor: Colors.grey.withOpacity(0.6),
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(12.0),
                          //         borderSide: BorderSide.none,
                          //       ),
                          //       enabledBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(12.0),
                          //         borderSide: BorderSide.none,
                          //       ),
                          //       focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(12.0),
                          //         borderSide: BorderSide.none,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const AutoSizeText(
                            "* Código válido durante todo el sorteo.",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey),
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          const AutoSizeText(
                            "Por cada 10 tickets que compres usando este código, obtendrán 1 ticket gratis cada uno",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          SizedBox(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.65,
                            child: ElevatedButton(
                              onPressed: () async {
                                String code = newCodeController.value.text;

                                if (code == "") {
                                  Fluttertoast.showToast(
                                      fontSize: 18,
                                      toastLength: Toast.LENGTH_LONG,
                                      msg:
                                          "\n Debe rellenar todos los campos, gracias! \n");
                                  return;
                                }
                                CreatePromotionDTO createPromotionDTO =
                                    CreatePromotionDTO(
                                        code: code, email: Credentials.email!);

                                print(createPromotionDTO.toJson());
                                PromotionController promotionController =
                                    PromotionController();
                                String? message = await promotionController
                                    .createPromotion(createPromotionDTO);
                                Fluttertoast.showToast(
                                  msg: '\n ${message!} \n',
                                  fontSize: 18,
                                  toastLength: Toast.LENGTH_LONG,
                                );
                                newCodeController.clear();
                                repeatCodeController.clear();
                                if (message == "Promoción activada") {
                                  print("Creo promo");
                                  SecureStorage.write(key: "promo", value: "0");
                                  Navigator.of(context).pushNamed("/main");
                                }
                              },
                              child: const AutoSizeText(
                                "Aceptar",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
