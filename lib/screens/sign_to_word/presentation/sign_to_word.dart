import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SignToWordPage extends StatefulWidget {
  const SignToWordPage({super.key});

  @override
  State<SignToWordPage> createState() => _SignToWordPageState();
}

class _SignToWordPageState extends State<SignToWordPage> {
  late CameraController _cameraController;
  bool _isDetecting = false;
  final String _predictedLabel = "No sign detected";
  final double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeCamera();
    });
  }

  // Initialize Camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    await _cameraController.initialize();

    if (!mounted) return;
    setState(() {});

    _cameraController.startImageStream((image) {
      if (!_isDetecting) {
        _isDetecting = true;
      }
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ASL Real-Time Detection")),
      body: Column(
        children: [
          _cameraController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                )
              : const Center(child: CircularProgressIndicator()),

          // Display Predictions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Prediction: $_predictedLabel",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Confidence: ${(_confidence * 100).toStringAsFixed(2)}%",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
