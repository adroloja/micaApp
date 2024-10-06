import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mica/controller/house_images/get_ids_controller.dart';
import 'package:mica/controller/house_images/get_images_controller.dart';
import 'package:mica/controller/location/LocationController.dart';
import 'package:mica/controller/lottery_date/get_lottery_date.dart';
import 'package:mica/dto/ImageHouseDTO.dart';
import 'package:mica/screens/house_details_screen.dart';
import 'package:mica/screens/menu/own_numers_screen.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/geolocation.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/buy_buttom.dart';
import 'package:mica/widget/custom_navigation_bars/custom_bottom_navigation_bar.dart';
import 'package:mica/widget/custom_app_bars/custom_app_bar.dart';
import 'package:mica/widget/custom_drawer.dart';
import 'package:path_provider/path_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController counterController = TextEditingController();
  int currentValue = 1;
  bool buttonEnabled = true;
  double price = 2.5;
  double total = 2.5;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainScreenContent(),
    const OwnNumersScreen(),
    const HouseDetailsScreen(),
  ];

  @override
  void initState() {
    counterController.text = "1";
    getDate();
    getGeolocation();
    SecureStorage.write(key: "counter", value: "1");
    getImage();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void getGeolocation() async {
    String? counterStr = await SecureStorage.read(key: "counter");
    try {
      if (int.parse(counterStr!) == 0) {
        Geolocation geolocation = Geolocation();
        Position? position = await geolocation.getCurrentLocation();
        LocationController locationController = LocationController();
        locationController.sendLocation(
            position!.latitude, position!.longitude);
      }
    } catch (err) {
      print(err);
    }
  }

  bool isButtonEnabled(DateTime countdown) {
    final now = DateTime.now();
    final difference = countdown.difference(now);
    return difference.inHours >= 1;
  }

  Future<void> getImage() async {
    String? selfieBase64 = await SecureStorage.read(key: "selfieImageBase64");

    if (selfieBase64 != null) {
      List<int> bytes = base64Decode(selfieBase64);
      File? selfie = File('${(await getTemporaryDirectory()).path}/selfie.jpg');
      Credentials.selfie = selfie;
      await selfie.writeAsBytes(bytes);
    }
  }

  Future<DateTime> getDate() async {
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

      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class MainScreenContent extends StatefulWidget {
  MainScreenContent() {}

  @override
  State<MainScreenContent> createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<MainScreenContent> {
  final TextEditingController counterController = TextEditingController();
  int currentValue = 1;
  bool buttonEnabled = true;
  double price = 2.99;
  double total = 2.99;

  List<ImageHouseDTO> imageList = [];
  static const String storedIdsKey = 'stored_image_ids';

  @override
  void initState() {
    counterController.text = "1";
    super.initState();
    checkForNewImages();
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

    if (mounted) {
      setState(() {});
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

    if (mounted) {
      setState(() {
        imageList = images;
      });
    }
  }

  Future<void> loadStoredImages(List<ImageHouseDTO> response) async {
    List<ImageHouseDTO> storedImages = [];

    for (var image in response) {
      String? imageBase64 = await SecureStorage.read(key: image.id.toString());
      if (imageBase64 != null) {
        storedImages.add(ImageHouseDTO(id: image.id, imageBase64: imageBase64));
      }
    }
    if (mounted) {
      setState(() {
        imageList = storedImages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final containerHeight = screenHeight *
              0.4; // Ajusta la altura del contenedor como un porcentaje de la pantalla
          final buttonSize =
              screenWidth * 0.10; // Tamaño dinámico para los botones
          final textSize =
              screenWidth * 0.05; // Tamaño dinámico para el texto del campo

          return SingleChildScrollView(
            padding:
                EdgeInsets.all(screenWidth * 0.05), // Añadir márgenes alrededor
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  height: screenHeight * 0.09,
                  child: const AutoSizeText(
                    "Tu futuro apartamento esta a un ticket de distancia",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                if (imageList.isNotEmpty) ...[
                  CarouselSlider(
                    options: CarouselOptions(
                      height: screenHeight * 0.475,
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
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                  SizedBox(height: screenHeight * 0.02),
                ] else ...[
                  // Opcional: Puedes mostrar un texto o indicador de carga si no hay imágenes
                  const Text(
                    "Cargando imágenes...",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
                SizedBox(height: screenHeight * 0.02),
                const AutoSizeText(
                  "Por tan solo 2.99 dólares, participa en nuestro sorteo. Para más información presion el botón 'Premio'",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                SizedBox(height: screenHeight * 0.02),
                BuyButtomWidget(
                  buttonSize: buttonSize,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          );
        },
      ),
    );
  }
}
