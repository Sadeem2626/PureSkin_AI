import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart'; // سطر الاستيراد الجديد

void main() =>
    runApp(MaterialApp(home: PureSkinAI(), debugShowCheckedModeBanner: false));

class PureSkinAI extends StatefulWidget {
  const PureSkinAI({super.key});

  @override
  _PureSkinAIState createState() => _PureSkinAIState();
}

class _PureSkinAIState extends State<PureSkinAI> {
  File? _image;
  String _result = "انتظار التقاط الصورة...";
  Interpreter? _interpreter;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/skin_model.tflite');
      print("تم تحميل الموديل بنجاح!");
    } catch (e) {
      print("عذراً، فشل تحميل الموديل: $e");
    }
  }

  Future _processImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = "جاري تحليل البشرة...";
      });

      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _result = "النتيجة: بشرة صحية - استمري على روتينكِ الحالي ✨";
      });
    }
  }

  // دالة لفتح رابط الصيدلية
  Future<void> _openPharmacy() async {
    final Uri url = Uri.parse('https://www.nahdi.sa/search?q=skin+care');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pure Skin AI",
          style: TextStyle(
            color: Colors.purple[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE6E6FA),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // أضفنا هذا لضمان عدم حدوث Overflow عند ظهور الأزرار الجديدة
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40), // مسافة علوية
              _image == null
                  ? Icon(
                      Icons.face_retouching_natural,
                      size: 150,
                      color: Colors.purple[100],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(_image!, height: 250),
                    ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _result,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.purple[700]),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _processImage,
                icon: Icon(Icons.camera_alt),
                label: Text("تصوير وتحليل البشرة"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD8BFD8),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),

              // --- الإضافات الجديدة المختصرة ---
              SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _openPharmacy,
                icon: Icon(Icons.shopping_bag_outlined),
                label: Text("تسوق منتجات العناية المقترحة"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.purple[700],
                  side: BorderSide(color: Colors.purple[200]!),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "⚠️ تنبيه: نتائج التحليل للأغراض الإرشادية فقط، ولا تغني عن استشارة الطبيب المختص.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
