import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mica/controller/description/description_controller.dart';
import 'package:mica/controller/house_images/get_ids_controller.dart';
import 'package:mica/controller/house_images/get_images_controller.dart';
import 'package:mica/dto/ImageHouseDTO.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';

class HouseDetailsScreen extends StatefulWidget {
  const HouseDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HouseDetailsScreen> createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<HouseDetailsScreen> {
  List<ImageHouseDTO> imageList = [];
  static const String storedIdsKey = 'stored_image_ids';
  String? text;

  @override
  void initState() {
    getDescription();
    super.initState();
    checkForNewImages();
  }

  Future<void> getDescription() async {
    DescriptionController descriptionController = DescriptionController();
    String? description = await descriptionController.getDescription();
    setState(() {
      if (description != null) {
        text = description;
      } else {
        text = 'No hay descripción disponible.';
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                ListView.builder(
                  itemCount: imageList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ImageHouseDTO image = imageList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity * 0.8,
                            height: 300,
                            decoration: BoxDecoration(
                              image: image.imageBase64 != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                          base64Decode(image.imageBase64!)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: image.imageBase64 == null
                                ? Center(child: Text('No Image'))
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
