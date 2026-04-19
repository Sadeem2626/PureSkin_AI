import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart'; // هذا هو السطر الناقص اللي سبب الخطأ

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: PureSkinAI()),
);

class PureSkinAI extends StatefulWidget {
  const PureSkinAI({super.key});

  @override
  State<PureSkinAI> createState() => _PureSkinAIState();
}

class _PureSkinAIState extends State<PureSkinAI> {
  File? _image;
  String _analysisResult = "Waiting for analysis...";
  String _skinType = "-";
  String _recommendation = "-";
  int _confidence = 0;
  bool _isAnalyzing = false;
  Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/skin_model.tflite');
    } catch (e) {
      debugPrint("Model Load Error: $e");
    }
  }

  void _getDiagnosis(int index, double score) {
    _confidence = (score * 100).toInt();

    // قائمة التصنيفات الخمسة مثل صديقتك
    List<String> labels = ["Oily", "Dry", "Normal", "Acne", "Eczema"];

    // اختيار النوع بناءً على الرقم اللي عطاه الذكاء الاصطناعي
    _skinType = labels[index];

    // الحين نحدد الكلام اللي يطلع للمستخدم بناءً على التصنيف
    switch (_skinType) {
      case "Oily":
        _analysisResult = "Bout of Excess Oil";
        _recommendation = "Foaming Cleanser & Oil-free Moisturizer";
        break;
      case "Dry":
        _analysisResult = "Dryness Detected";
        _recommendation = "Rich Hydrating Cream & Gentle Wash";
        break;
      case "Normal":
        _analysisResult = "Healthy Skin Balance";
        _recommendation = "Maintain with Daily Sunscreen";
        break;
      case "Acne":
        _analysisResult = "Acne / Pimples Present";
        _recommendation = "Salicylic Acid & Spot Treatment";
        break;
      case "Eczema":
        _analysisResult = "Eczema / Redness Detected";
        _recommendation = "Soothing Eczema Relief Cream";
        break;
      default:
        _analysisResult = "Analysis Complete";
        _recommendation = "Consult a dermatologist if needed";
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    if (_interpreter == null) return;
    setState(() => _isAnalyzing = true);
    try {
      final imageData = imageFile.readAsBytesSync();
      img.Image? originalImage = img.decodeImage(imageData);
      img.Image resizedImage = img.copyResize(
        originalImage!,
        width: 224,
        height: 224,
      );
      var input = imageToByteListFloat32(resizedImage, 224);
      var output = List.filled(1 * 5, 0.0).reshape([1, 5]);
      _interpreter!.run(input, output);
      double maxScore = -1.0;
      int highestIndex = 0;
      for (int i = 0; i < 5; i++) {
        if (output[0][i] > maxScore) {
          maxScore = output[0][i];
          highestIndex = i;
        }
      }
      setState(() {
        _getDiagnosis(highestIndex, maxScore);
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _analysisResult = "Analysis Error";
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _shopForProduct() async {
    final String query = _recommendation.replaceAll(' ', '+');
    final Uri url = Uri.parse("https://www.nahdi.sa/search?q=$query");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text(
          "Pure Skin AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.green.shade300, width: 4),
                  boxShadow: [
                    const BoxShadow(color: Colors.black12, blurRadius: 15),
                  ],
                ),
                child: _image == null
                    ? Icon(
                        Icons.face_retouching_natural,
                        size: 80,
                        color: Colors.green.shade100,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 25),
            if (_image != null && !_isAnalyzing)
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      _analysisResult,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Skin Type: $_skinType",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Accuracy: $_confidence%",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 25),
                    Text(
                      "Top Recommendation:",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _recommendation,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            if (_isAnalyzing)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Colors.green),
              ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Note: This analysis is AI-generated and does not replace professional medical advice.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture & Analyze"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
            ),
            if (_image != null && !_isAnalyzing) ...[
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _shopForProduct,
                icon: const Icon(Icons.shopping_cart),
                label: const Text("View Suitable Products"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 15,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      _analyzeImage(_image!);
    }
  }

  List imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = List.filled(
      1 * inputSize * inputSize * 3,
      0.0,
    ).reshape([1, inputSize, inputSize, 3]);
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        convertedBytes[0][i][j][0] = (pixel.r - 127.5) / 127.5;
        convertedBytes[0][i][j][1] = (pixel.g - 127.5) / 127.5;
        convertedBytes[0][i][j][2] = (pixel.b - 127.5) / 127.5;
      }
    }
    return convertedBytes;
  }
}
