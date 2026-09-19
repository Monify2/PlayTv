import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../core/theme.dart';
import '../services/playback_service.dart';

class PlayerScreen extends StatefulWidget { final String titleId; final String title; final String? episodeId; const PlayerScreen({super.key, required this.titleId, required this.title, this.episodeId}); @override State<PlayerScreen> createState() => _PlayerScreenState(); }
class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? controller; bool loading = true; String? error;
  @override void initState() { super.initState(); open(); }
  Future<void> open() async { try { final r = await PlaybackService().getPlayback(titleId: widget.titleId, episodeId: widget.episodeId); final c = VideoPlayerController.networkUrl(Uri.parse(r.url)); await c.initialize(); await c.play(); if (mounted) setState(() { controller = c; loading = false; }); } catch (e) { if (mounted) setState(() { error = '$e'; loading = false; }); } }
  @override void dispose() { controller?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis)), body: Center(child: loading ? const CircularProgressIndicator(color: PlayTvColors.green) : error != null ? Padding(padding: const EdgeInsets.all(20), child: Text(error!, textAlign: TextAlign.center)) : Column(mainAxisAlignment: MainAxisAlignment.center, children: [AspectRatio(aspectRatio: controller!.value.aspectRatio, child: VideoPlayer(controller!)), VideoProgressIndicator(controller!, allowScrubbing: true, padding: const EdgeInsets.all(12), colors: const VideoProgressColors(playedColor: PlayTvColors.green, bufferedColor: PlayTvColors.greenDark, backgroundColor: PlayTvColors.line)), IconButton(onPressed: () { setState(() { controller!.value.isPlaying ? controller!.pause() : controller!.play(); }); }, iconSize: 42, icon: Icon(controller!.value.isPlaying ? Icons.pause_circle : Icons.play_circle, color: PlayTvColors.green))])));
}
