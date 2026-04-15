import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد المكتبة مباشرة هنا
import 'package:pure_skin_ai/auth/login_page.dart'; 

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // ignore: unused_field
  String? _selectedSkinType;
  // ignore: unused_field
  final List<String> _skinTypes = [
    'Oily',
    'Dry',
    'Combination',
    'Sensitive'
  ];


  @override
  void initState() {
    super.initState();
    // تنفيذ التحقق بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkGuestStatus();
    });
  }

  // الدالة المعدلة لتعمل بدون الاعتماد على ملف main
  Future<void> _checkGuestStatus() async {
    // نفتح ملف التخزين محلياً داخل الدالة
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // جلب القيمة (إذا كانت فارغة نعتبرها false أي أنه ضيف)
    bool isLogin = prefs.getBool('isLogin') ?? false; 

    if (!isLogin) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("يجب أن يكون لديك حساب في التطبيق للدخول"),
            backgroundColor: Colors.redAccent,
          ),
        );
        // نقله لصفحة التسجيل
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      }
    }
  }

  Future<void> _launchURL(String urlString) async {
    if (urlString.isEmpty || !urlString.startsWith('http')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("عذراً، الرابط غير متوفر حالياً")),
        );
      }
      return;
    }
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تعذر فتح الرابط")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFF5F8063);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Products',
          style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/bac1.jpeg', fit: BoxFit.cover),
          ),
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 40),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('pure skin').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: mainColor));
                    }
                    if (snapshot.hasError) return const Center(child: Text("Error"));
                    if (!snapshot.hasData) return const Center(child: Text("No Data"));

                    var docs = snapshot.data!.docs;

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.48,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var product = docs[index].data() as Map<String, dynamic>;
                        
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(product['Image_URL'] ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  product['Product_Name'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  maxLines: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    _buildShopButton("Amazon", Colors.orange, product['Amazon_Link'] ?? ''),
                                    const SizedBox(height: 5),
                                    _buildShopButton("Nahdi", Colors.blue, product['Nahdi_Link'] ?? ''),
                                    const SizedBox(height: 5),
                                    _buildShopButton("Nice One", mainColor, product['Nice_One_Link (EN)'] ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopButton(String label, Color color, String url) {
    return SizedBox(
      width: double.infinity,
      height: 32,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => _launchURL(url),
        child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }
}