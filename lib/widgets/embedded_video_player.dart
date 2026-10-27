import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../theme/app_theme.dart';

class EmbeddedVideoPlayer extends StatefulWidget {
  final String videoId;
  final String? videoTitle;
  final int? durationMinutes;

  const EmbeddedVideoPlayer({
    super.key,
    required this.videoId,
    this.videoTitle,
    this.durationMinutes,
  });

  @override
  State<EmbeddedVideoPlayer> createState() => _EmbeddedVideoPlayerState();
}

class _EmbeddedVideoPlayerState extends State<EmbeddedVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _hasError = false;
  String _errorMessage = '';
  double _currentSpeed = 1.0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    try {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: widget.videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showFullscreenButton: true,
          showControls: true,
          mute: false,
          enableCaption: true,
        ),
      );
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    }
  }

  @override
  void didUpdateWidget(covariant EmbeddedVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      try {
        _controller.loadVideoById(videoId: widget.videoId);
      } catch (_) {
        _initController();
      }
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<void> _seekRelative(double deltaSeconds) async {
    try {
      final current = await _controller.currentTime;
      final target = (current + deltaSeconds).clamp(0.0, 7200.0);
      _controller.seekTo(seconds: target, allowSeekAhead: true);
    } catch (_) {}
  }

  Future<void> _toggleMute() async {
    try {
      if (_isMuted) {
        _controller.unMute();
        setState(() => _isMuted = false);
      } else {
        _controller.mute();
        setState(() => _isMuted = true);
      }
    } catch (_) {}
  }

  Future<void> _setSpeed(double speed) async {
    try {
      _controller.setPlaybackRate(speed);
      setState(() => _currentSpeed = speed);
    } catch (_) {}
  }

  void _openFullscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text(
              widget.videoTitle ?? 'Video Masterclass',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTranscriptSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patches = [
      {
        'time': '00:00 - 00:45',
        'startSec': 0.0,
        'title': 'Module Introduction & Architecture',
        'text':
            'Welcome to this PyPocket Masterclass. In this lesson, we examine the fundamental execution model of Python, memory allocation pointers, and clean architecture practices.',
      },
      {
        'time': '00:45 - 01:30',
        'startSec': 45.0,
        'title': 'Namespace Pointers & Memory Heap',
        'text':
            'In Python, variables are identifiers bound to heap objects rather than fixed memory cells. When you reassign a name, you bind a new address in the local symbol table.',
      },
      {
        'time': '01:30 - 02:20',
        'startSec': 90.0,
        'title': 'Mutability Mechanics & References',
        'text':
            'Notice the difference between mutable types (lists, dicts, sets) and immutable types (ints, floats, strings, tuples). Modifying a mutable object alters all referencing identifiers in place.',
      },
      {
        'time': '02:20 - 03:20',
        'startSec': 140.0,
        'title': 'Live Inspection with id() and hex()',
        'text':
            'By utilizing the built-in id() function, we observe direct memory references. Comparing identity with "is" checks memory address equality, while "==" evaluates value equivalence.',
      },
      {
        'time': '03:20 - 04:30',
        'startSec': 200.0,
        'title': 'Context Managers & Exception Safety',
        'text':
            'Ensure deterministic cleanup using "with" statements. Python automatically invokes __enter__ and __exit__ dunder protocols to prevent socket, file descriptor, or memory leaks.',
      },
      {
        'time': '04:30 - 05:45',
        'startSec': 270.0,
        'title': 'Performance Optimization & Sandbox Test',
        'text':
            'Switch directly to the PyPocket CPython IDE tab below to execute this pattern against the automated test suite and earn your certified XP.',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF101726) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (sheetCtx, scrollController) => Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A3448) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.subtitles_rounded, color: Color(0xFFC89B58), size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Synchronized Lesson Transcript',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF17191C),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    tooltip: 'Copy Full Transcript',
                    onPressed: () {
                      final fullText = patches.map((p) => "[${p['time']}] ${p['title']}\n${p['text']}").join('\n\n');
                      Clipboard.setData(ClipboardData(text: fullText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Full lesson transcript copied to clipboard!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: patches.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final patch = patches[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      final sec = patch['startSec'] as double;
                      _controller.seekTo(seconds: sec, allowSeekAhead: true);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Jumped video to ${patch['time']} mark')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161F33) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF23304B) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC89B58).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  patch['time'] as String,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFC89B58),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  patch['title'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF17191C),
                                  ),
                                ),
                              ),
                              const Icon(Icons.play_arrow_rounded, color: Color(0xFFC89B58), size: 18),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            patch['text'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppTheme.surfaceOf(context);
    final borderColor = AppTheme.borderOf(context);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              border: Border(bottom: BorderSide(color: borderColor, width: 1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Color(0xFFFF0000),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.videoTitle ?? 'Video Masterclass',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.durationMinutes != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.4)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: Color(0xFFC89B58),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.durationMinutes}m',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondaryOf(context),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Player Area
          if (_hasError)
            Container(
              height: 200,
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppTheme.errorRed, size: 36),
                  const SizedBox(height: 10),
                  Text(
                    'Unable to load video',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _errorMessage,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textMutedOf(context),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _initController()),
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            )
          else
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),

          // Multi-Option Control Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131926) : const Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: borderColor, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Rewind 10s
                IconButton(
                  icon: const Icon(Icons.replay_10_rounded, size: 20),
                  tooltip: 'Rewind 10s',
                  onPressed: () => _seekRelative(-10.0),
                ),

                // Fast Forward 10s
                IconButton(
                  icon: const Icon(Icons.forward_10_rounded, size: 20),
                  tooltip: 'Forward 10s',
                  onPressed: () => _seekRelative(10.0),
                ),

                // Speed Selector Menu
                PopupMenuButton<double>(
                  tooltip: 'Playback Speed',
                  initialValue: _currentSpeed,
                  onSelected: _setSpeed,
                  itemBuilder: (ctx) => [
                    0.75,
                    1.0,
                    1.25,
                    1.5,
                    2.0,
                  ].map((speed) => PopupMenuItem(
                    value: speed,
                    child: Text(
                      '${speed}x Speed',
                      style: GoogleFonts.jetBrainsMono(
                        fontWeight: _currentSpeed == speed ? FontWeight.bold : FontWeight.normal,
                        color: _currentSpeed == speed ? const Color(0xFFC89B58) : null,
                      ),
                    ),
                  )).toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E283C) : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_currentSpeed}x',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Mute / Unmute
                IconButton(
                  icon: Icon(
                    _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    size: 20,
                  ),
                  tooltip: _isMuted ? 'Unmute' : 'Mute',
                  onPressed: _toggleMute,
                ),

                // Transcript Sheet Button
                IconButton(
                  icon: const Icon(Icons.subtitles_rounded, size: 20, color: Color(0xFFC89B58)),
                  tooltip: 'View Interactive Transcript',
                  onPressed: _showTranscriptSheet,
                ),

                // Fullscreen
                IconButton(
                  icon: const Icon(Icons.fullscreen_rounded, size: 22),
                  tooltip: 'Fullscreen View',
                  onPressed: _openFullscreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
