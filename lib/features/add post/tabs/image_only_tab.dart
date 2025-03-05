import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pixify/features/add%20post/tabs/add_caption_page.dart';

class ImageOnlyTab extends StatefulWidget {
  const ImageOnlyTab({super.key});

  @override
  State<ImageOnlyTab> createState() => _ImageOnlyTabState();
}

class _ImageOnlyTabState extends State<ImageOnlyTab> {
  List<Widget>? imageList;

  File? selectedImage;

  selectAndCropImage(File imageFile) async {
    final CroppedFile? croppedImage = (await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressQuality: 45,
        uiSettings: [
          AndroidUiSettings(aspectRatioPresets: [CropAspectRatioPreset.square])
        ],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1)));

    if (croppedImage == null) {
      return;
    }
    final File croppedImageFile = File(croppedImage.path);

    if (mounted) {
      setState(() {
        selectedImage = croppedImageFile;
      });
    }
  }

  fetchAllImages() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return PhotoManager.openSetting();

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: true,
    );

    List<AssetEntity> images = await albums[0].getAssetListPaged(
      page: 0,
      size: 100000,
    );

    List<Widget> temp = [];

    for (var asset in images) {
      temp.add(
        FutureBuilder(
          future: asset.file,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () async {
                    await selectAndCropImage(snapshot.data!);
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(
                          snapshot.data!,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return const Card(
                child: SizedBox(
              height: 200,
              width: 200,
            ));
          },
        ),
      );
    }

    if (mounted) {
      setState(() {
        imageList = temp;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: selectedImage == null
                      ? const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.amber,
                          size: 200,
                        )
                      : InteractiveViewer(
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Expanded(
                child: imageList == null
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.amber))
                    : GridView.builder(
                        itemCount: imageList!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, index) => imageList![index],
                      ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: selectedImage != null
          ? FloatingActionButton.extended(
              splashColor: Colors.white30,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddCaptionPage(
                      selectedImageFile: selectedImage!,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              shape: const StadiumBorder(),
              label: const SizedBox(
                height: 65,
                width: 200,
                child: Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
