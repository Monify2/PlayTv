import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});
  @override State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool loading = true;
  List<dynamic> plans = const [];

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    try {
      final data = await ApiService().plans();
      if (mounted) setState(() { plans = data; loading = false; });
    } catch (e) {
      if (mounted) setState(() { plans = const []; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Premium', style: TextStyle(fontWeight: FontWeight.w900))),
    body: loading ? const Center(child: CircularProgressIndicator(color: PlayTvColors.green)) : ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: PlayTvColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: PlayTvColors.line)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('PLAY WITHOUT LIMITS', style: TextStyle(color: PlayTvColors.green, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          SizedBox(height: 8), Text('Premium', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          SizedBox(height: 8), Text('No ads, higher quality and offline playback across your devices.', style: TextStyle(color: PlayTvColors.muted, height: 1.4)),
        ])),
        const SizedBox(height: 14),
        for (final p in plans) _PlanCard(plan: Map<String, dynamic>.from(p as Map)),
      ],
    ),
  );
}

class _PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  const _PlanCard({required this.plan});
  @override
  Widget build(BuildContext context) {
    final name = '${plan['name'] ?? plan['interval'] ?? 'Premium'}';
    final price = '${plan['price'] ?? plan['amount'] ?? '—'}';
    return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: PlayTvColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: PlayTvColors.line)), child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text('${plan['description'] ?? 'Premium PlayTv access'}', style: const TextStyle(color: PlayTvColors.muted, fontSize: 11))])),
      const SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('\$$price', style: const TextStyle(color: PlayTvColors.green, fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 7), FilledButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout will be connected to the payment provider.'))), child: const Text('SELECT'))]),
    ]));
  }
}
