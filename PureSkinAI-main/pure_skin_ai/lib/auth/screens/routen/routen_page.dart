import 'package:flutter/material.dart';

class RoutinePage extends StatelessWidget {
  const RoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bac1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Your Routine",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    _buildRoutineSection(
                      title: "Morning Ritual",
                      icon: Icons.wb_sunny_outlined,
                      items: ["Cleanse", "Tone", "Serum", "Moisturize"],
                      subItems: ["Gentle Cleanser", "Hydrating Toner", "Vitamin C Essence", "Day Cream SPF 30"],
                    ),
                    const SizedBox(height: 20),
                    _buildRoutineSection(
                      title: "Evening Ritual",
                      icon: Icons.nightlight_round_outlined,
                      items: ["Double Cleanse", "Exfoliate", "Serum", "Moisturize"],
                      subItems: ["Oil + Foam Cleanser", "AHA/BHA Toner", "Hydrating Essence", "Nourishing Night Cream"],
                    ),
                    const SizedBox(height: 20),
                    _buildRoutineSection(
                      title: "Weekly Treatment",
                      icon: Icons.auto_awesome_outlined,
                      items: ["Exfoliate", "Mask", "Hydrate"],
                      subItems: ["Gentle Scrub", "Clay or Sheet Mask", "Overnight Mask"],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required List<String> subItems,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 236, 230).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF2E7D32), size: 28),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 30),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(items[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(subItems[index], style: const TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}