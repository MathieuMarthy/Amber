import 'package:flutter/material.dart';

class AndroidToast extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const AndroidToast({
    super.key,
    required this.message,
    required this.onDismissed,
  });

  @override
  State<AndroidToast> createState() => _AndroidToastState();
}

class _AndroidToastState extends State<AndroidToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          _controller.reverse().then((_) {
            widget.onDismissed();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _opacity,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 48.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: colors.inverseSurface,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                color: colors.onInverseSurface,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

OverlayEntry? _currentToastEntry;

void showAndroidToast(BuildContext context, String message) {
  final overlay = Overlay.of(context, rootOverlay: true);

  if (_currentToastEntry != null) {
    _currentToastEntry!.remove();
    _currentToastEntry = null;
  }

  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 80.0,
      left: 0.0,
      right: 0.0,
      child: AndroidToast(
        message: message,
        onDismissed: () {
          if (_currentToastEntry == overlayEntry) {
            overlayEntry.remove();
            _currentToastEntry = null;
          }
        },
      ),
    ),
  );

  _currentToastEntry = overlayEntry;
  overlay.insert(overlayEntry);
}
