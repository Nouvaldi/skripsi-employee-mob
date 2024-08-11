import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function(File) onPictureTaken;

  const CameraPreviewPage({
    super.key,
    required this.cameras,
    required this.onPictureTaken,
  });

  @override
  State<CameraPreviewPage> createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    _cameraController = CameraController(
      widget.cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front),
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  void _takePhoto() async {
    if (_cameraController!.value.isInitialized) {
      XFile photo = await _cameraController!.takePicture();
      widget.onPictureTaken(File(photo.path));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Attendance'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isCameraInitialized
          ? CameraPreview(_cameraController!)
          : const Center(child: CircularProgressIndicator()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: _takePhoto,
        child: Icon(
          Icons.camera_alt,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
