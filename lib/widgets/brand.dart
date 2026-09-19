import 'package:flutter/material.dart';
import '../core/theme.dart';

class PlayTvBrand extends StatelessWidget {
  final bool compact;
  const PlayTvBrand({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 28 : 34,
          height: compact ? 28 : 34,
          decoration: BoxDecoration(
            color: PlayTvColors.green,
            borderRadius: BorderRadius.circular(9),
            boxShadow: const [BoxShadow(color: Color(0x3318F58A), blurRadius: 12)],
          ),
          child: Icon(Icons.play_arrow_rounded, color: Colors.black, size: compact ? 20 : 25),
        ),
        const SizedBox(width: 9),
        Text('PLAYTV', style: TextStyle(fontSize: compact ? 17 : 22, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
      ],
    );
  }
}
