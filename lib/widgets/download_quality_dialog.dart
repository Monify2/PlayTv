import 'package:flutter/material.dart';

import '../core/theme.dart';

class DownloadQualityOption {
  final String value;
  final String label;
  final String detail;
  final bool highQuality;

  const DownloadQualityOption({
    required this.value,
    required this.label,
    required this.detail,
    required this.highQuality,
  });
}

class DownloadQualityDialog extends StatefulWidget {
  final bool premium;

  const DownloadQualityDialog({super.key, required this.premium});

  @override
  State<DownloadQualityDialog> createState() => _DownloadQualityDialogState();
}

class _DownloadQualityDialogState extends State<DownloadQualityDialog> {
  static const options = <DownloadQualityOption>[
    DownloadQualityOption(
      value: 'DATA_SAVER',
      label: 'Data Saver',
      detail: '360p',
      highQuality: false,
    ),
    DownloadQualityOption(
      value: 'SD',
      label: 'Standard',
      detail: '480p',
      highQuality: false,
    ),
    DownloadQualityOption(
      value: 'HD',
      label: 'HD',
      detail: '720p',
      highQuality: true,
    ),
    DownloadQualityOption(
      value: 'Full HD',
      label: 'Full HD',
      detail: '1080p',
      highQuality: true,
    ),
    DownloadQualityOption(
      value: '4K',
      label: 'Ultra HD',
      detail: '4K',
      highQuality: true,
    ),
  ];

  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.premium ? 'HD' : 'SD';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: PlayTvColors.surface,
      title: const Text('Download quality'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose the quality for this offline download.',
                style: TextStyle(color: PlayTvColors.muted),
              ),
            ),
            const SizedBox(height: 12),
            ...options.map(_option),
            if (!widget.premium) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PlayTvColors.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: PlayTvColors.line),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.ondemand_video_rounded,
                      size: 18,
                      color: PlayTvColors.green,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Free users can unlock HD and higher quality by completing a rewarded ad. Lower-quality downloads remain available without the quality unlock.',
                        style: TextStyle(
                          color: PlayTvColors.muted,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selected),
          child: const Text('CONTINUE'),
        ),
      ],
    );
  }

  Widget _option(DownloadQualityOption option) {
    final selectedNow = selected == option.value;

    return RadioListTile<String>(
      value: option.value,
      groupValue: selected,
      dense: true,
      contentPadding: EdgeInsets.zero,
      activeColor: PlayTvColors.green,
      title: Row(
        children: [
          Expanded(
            child: Text(
              option.label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            option.detail,
            style: const TextStyle(color: PlayTvColors.muted, fontSize: 12),
          ),
          if (option.highQuality && !widget.premium) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.ondemand_video_rounded,
              size: 16,
              color: PlayTvColors.green,
            ),
          ],
        ],
      ),
      subtitle: option.highQuality && !widget.premium
          ? const Text(
              'Watch a rewarded ad to unlock',
              style: TextStyle(color: PlayTvColors.muted, fontSize: 11),
            )
          : null,
      onChanged: (_) {
        setState(() => selected = option.value);
      },
      selected: selectedNow,
    );
  }
}
