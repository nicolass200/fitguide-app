// lib/widgets/rest_timer_widget.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';

class RestTimerWidget extends StatefulWidget {
  const RestTimerWidget({super.key});

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> {
  int _totalSeconds = AppConstants.defaultRestTimeSeconds;
  int _remainingSeconds = AppConstants.defaultRestTimeSeconds;
  bool _isRunning = false;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        _onTimerComplete();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  Future<void> _onTimerComplete() async {
    setState(() {
      _isRunning = false;
      _remainingSeconds = 0;
    });

    // Toca o áudio de alerta ao terminar o descanso
    try {
      await _audioPlayer.play(AssetSource('audio/timer_end.mp3'));
    } catch (_) {
      // Se o áudio não carregar, apenas ignora silenciosamente
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.alarm, color: Colors.white),
              SizedBox(width: 8),
              Text('Descanso finalizado! Hora de voltar! 💪'),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _adjustTime(int deltaSeconds) {
    if (_isRunning) return;
    setState(() {
      _totalSeconds = (_totalSeconds + deltaSeconds).clamp(10, 300);
      _remainingSeconds = _totalSeconds;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (_totalSeconds == 0) return 0;
    return _remainingSeconds / _totalSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⏱ Timer de Descanso',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade200,
                      color: _remainingSeconds == 0
                          ? AppTheme.successColor
                          : AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Ajuste de tempo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimeAdjustButton(label: '-30s', onPressed: () => _adjustTime(-30)),
                const SizedBox(width: 8),
                _TimeAdjustButton(label: '-10s', onPressed: () => _adjustTime(-10)),
                const SizedBox(width: 8),
                _TimeAdjustButton(label: '+10s', onPressed: () => _adjustTime(10)),
                const SizedBox(width: 8),
                _TimeAdjustButton(label: '+30s', onPressed: () => _adjustTime(30)),
              ],
            ),
            const SizedBox(height: 12),
            // Controles do timer
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.replay),
                  tooltip: 'Reiniciar',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                  ),
                  onPressed: _resetTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeAdjustButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _TimeAdjustButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
