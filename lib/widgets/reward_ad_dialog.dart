import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/ad_service.dart';

class RewardAdDialog extends StatefulWidget {
  final AdPlacement placement;
  final String title;
  final String message;

  const RewardAdDialog({
    super.key,
    required this.placement,
    this.title = 'Reward download',
    this.message = 'Complete this short reward step to unlock your free download.',
  });

  @override
  State<RewardAdDialog> createState() => _RewardAdDialogState();
}

class _RewardAdDialogState extends State<RewardAdDialog> {
  Timer? timer;
  int remaining = 5;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (remaining <= 1) {
        timer?.cancel();
        setState(() => remaining = 0);
      } else {
        setState(() => remaining--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: PlayTvColors.surface,
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.ondemand_video_rounded, size: 46, color: PlayTvColors.green),
            const SizedBox(height: 14),
            Text(
              widget.placement.name,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: PlayTvColors.muted),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (5 - remaining) / 5,
              color: PlayTvColors.green,
              backgroundColor: PlayTvColors.line,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: remaining == 0 ? () => Navigator.pop(context, true) : null,
            child: Text(remaining == 0 ? 'CONTINUE' : 'WAIT $remaining'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
        ],
      );
}
