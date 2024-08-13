import 'dart:io';
import 'package:cam_app/file_path.dart';
import 'package:cam_app/preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imageBytesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    List<String> list = await FileDirectoryAdapter.getImages();
    setState(() {
      imageBytesList = list;
      isLoading = false;
    });
  }

  Future<File?> pickimage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return File(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.black54,
        
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : imageBytesList.isEmpty
              ? const Center(
                  child: Text(
                    'Click on camera icon to caputre images',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: imageBytesList.length,
                  itemBuilder: (context, index) {
                    final imagePath = imageBytesList[index];
                    final image = Image.file(File(imagePath), fit: BoxFit.cover);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreviewPage(imagePath: imagePath),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("You Want To Delete?"),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  FileDirectoryAdapter.deleteElementByPath(imagePath);
                                  setState(() {
                                    imageBytesList.remove(imagePath);
                                  });
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: GridTile(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: image,
                        ),
                      ),
                    );
                  },
                ),
      backgroundColor: Color.fromARGB(255, 45, 44, 44), // Background color
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image = await pickimage();
          if (image != null) {
            await FileDirectoryAdapter.saveImage(image);
            setState(() {
              imageBytesList.add(image.path);
            });
          }
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}
