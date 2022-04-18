import 'dart:async';
import 'dart:typed_data';

import 'package:coviapremise/components/widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'version_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qrcode_Screen extends StatefulWidget {
  const Qrcode_Screen(
      {Key? key, required this.storeemail, required this.storename})
      : super(key: key);
  final String storeemail;
  final String storename;
  @override
  State<Qrcode_Screen> createState() => _Qrcode_ScreenState();
}

class _Qrcode_ScreenState extends State<Qrcode_Screen> {
  final controller = TextEditingController();
  GlobalKey globalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          child: const Text('Qr Generator'),
          onTap: () {
            Get.to(const Version_Screen());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Screenshot(
                controller: screenshotController,
                child: QrImage(
                  data: widget.storename,
                  size: 300,
                  backgroundColor: Colors.white,
                ),
              ),
              Text('${widget.storename}'),
              const SizedBox(
                height: 40,
              ),
              // InputField(
              //     label1: 'Enter Store Name',
              //     label2: '',
              //     hint: 'Store Name',
              //     inputType: TextInputType.text,
              //     read: false,
              //     controller: controller,
              //     isPassword: false,
              //     textCapitalization: TextCapitalization.none),
              const SizedBox(
                height: 20,
              ),
              RoundedButton(
                label: 'Save',
                icon: Icons.save,
                onPressed: () async {
                  final image = await screenshotController.capture();
                  if (image == null) return;
                  await saveImage(image);
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  }
}
