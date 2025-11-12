import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class InlineAudioRecorder extends StatefulWidget {
  final ValueChanged<bool>? onRecordingComplete;

  const InlineAudioRecorder({Key? key, this.onRecordingComplete}) : super(key: key);

  @override
  State<InlineAudioRecorder> createState() => _InlineAudioRecorderState();
}

class _InlineAudioRecorderState extends State<InlineAudioRecorder> {
  bool _isRecording = true;
  bool _isRecorded = false;
  int _seconds = 0;
  Timer? _timer;
  Timer? _waveformTimer;
  List<double> _waveform = List.generate(25, (_) => 0.2);

  @override
  void initState() {
    super.initState();
    _startRecording();
  }

  void _startRecording() {
    _isRecording = true;
    _isRecorded = false;
    _seconds = 0;

    _timer?.cancel();
    _waveformTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });

    _waveformTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      setState(() {
        _waveform = _waveform.map((_) => Random().nextDouble()).toList();
      });
    });

    setState(() {});
  }

  void _stopRecording() {
    _isRecording = false;
    _isRecorded = true;
    _timer?.cancel();
    _waveformTimer?.cancel();
    widget.onRecordingComplete?.call(true);
    setState(() {});
  }

  void _deleteRecording() {
    _isRecorded = false;
    _seconds = 0;
    _startRecording();
    widget.onRecordingComplete?.call(false);
  }

  String _formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return "$m:$sec";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveformTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: _isRecorded ? _buildRecordedUI() : _buildRecordingUI(),
    );
  }

  Widget _buildRecordingUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 4),
          child: Text(
            "Recording Audio...",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: _stopRecording,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.mic_none_rounded, color: Colors.white, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: _buildWaveform(isAnimated: true)),
            const SizedBox(width: 14),
            Text(
              _formatTime(_seconds),
              style: const TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecordedUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Audio Recorded • ${_formatTime(_seconds)}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: _deleteRecording,
              child: const Icon(Icons.delete_outline_outlined,
                  color: Color(0xFF6C63FF), size: 20),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.play_arrow_outlined, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(child: _buildWaveform(isAnimated: false)),
          ],
        ),
      ],
    );
  }

  Widget _buildWaveform({bool isAnimated = false}) {
    final List<double> bars = List.generate(55, (i) => _waveform[i % _waveform.length]);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: bars.map((v) {
        final value = isAnimated ? v : (sin(v * 10) * 0.5 + 0.5);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0.6),
          height: (value * 26).clamp(4.0, 26.0),
          width: 3.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white,
          ),
        );
      }).toList(),
    );
  }
}