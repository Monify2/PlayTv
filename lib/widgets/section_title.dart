import 'package:flutter/material.dart';
import '../core/theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;
  const SectionTitle(this.title, {super.key, this.onMore});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
        child: Row(children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const Spacer(),
          if (onMore != null) TextButton(onPressed: onMore, child: const Text('SEE ALL', style: TextStyle(color: PlayTvColors.green, fontSize: 11, fontWeight: FontWeight.w800))),
        ]),
      );
}
