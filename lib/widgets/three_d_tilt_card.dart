import 'package:flutter/material.dart';

/// A premium 3D perspective tilt card that responds to hover and touch.
/// Gives cards an executive, tactile depth without feeling cartoonish.
class ThreeDTiltCard extends StatefulWidget {
  final Widget child;
  final double maxTilt;
  final double elevation;
  final BorderRadius? borderRadius;
  final Color? glowColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const ThreeDTiltCard({
    super.key,
    required this.child,
    this.maxTilt = 0.08,
    this.elevation = 8,
    this.borderRadius,
    this.glowColor,
    this.onTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<ThreeDTiltCard> createState() => _ThreeDTiltCardState();
}

class _ThreeDTiltCardState extends State<ThreeDTiltCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _tiltXAnim;
  late Animation<double> _tiltYAnim;

  double _rotX = 0;
  double _rotY = 0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _tiltXAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _tiltYAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerEvent event, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final dx = (event.localPosition.dx / size.width) - 0.5;
    final dy = (event.localPosition.dy / size.height) - 0.5;

    setState(() {
      _rotX = -dy * widget.maxTilt;
      _rotY = dx * widget.maxTilt;
      _isHovered = true;
    });
  }

  void _resetTilt() {
    _tiltXAnim = Tween<double>(begin: _rotX, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _tiltYAnim = Tween<double>(begin: _rotY, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _rotX = 0;
          _rotY = 0;
          _isHovered = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final br = widget.borderRadius ?? BorderRadius.circular(20);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return MouseRegion(
          onEnter: (e) => setState(() => _isHovered = true),
          onExit: (e) => _resetTilt(),
          onHover: (e) => _onPointerMove(e, size),
          child: GestureDetector(
            onTap: widget.onTap,
            onPanUpdate: (e) {
              final dx = (e.localPosition.dx / size.width) - 0.5;
              final dy = (e.localPosition.dy / size.height) - 0.5;
              setState(() {
                _rotX = -dy * widget.maxTilt;
                _rotY = dx * widget.maxTilt;
                _isHovered = true;
              });
            },
            onPanEnd: (_) => _resetTilt(),
            onPanCancel: () => _resetTilt(),
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final currentRotX =
                    _animController.isAnimating ? _tiltXAnim.value : _rotX;
                final currentRotY =
                    _animController.isAnimating ? _tiltYAnim.value : _rotY;

                final scaleFactor = _isHovered ? 1.015 : 1.0;
                final matrix = Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(currentRotX)
                  ..rotateY(currentRotY)
                  ..scaleByDouble(scaleFactor, scaleFactor, 1.0, 1.0);

                return Transform(
                  transform: matrix,
                  alignment: FractionalOffset.center,
                  child: Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      borderRadius: br,
                      boxShadow: [
                        BoxShadow(
                          color: (widget.glowColor ?? Colors.black).withValues(
                            alpha: _isHovered ? 0.18 : 0.07,
                          ),
                          blurRadius: _isHovered ? widget.elevation * 2.5 : widget.elevation,
                          offset: Offset(
                            _isHovered ? currentRotY * 40 : 0,
                            _isHovered ? -currentRotX * 40 + 6 : 4,
                          ),
                          spreadRadius: _isHovered ? 1 : 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: br,
                      child: Stack(
                        children: [
                          widget.child,
                          if (_isHovered)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(
                                        -currentRotY * 10 - 0.5,
                                        -currentRotX * 10 - 0.5,
                                      ),
                                      end: Alignment(
                                        currentRotY * 10 + 0.5,
                                        currentRotX * 10 + 0.5,
                                      ),
                                      colors: [
                                        Colors.white.withValues(alpha: 0.08),
                                        Colors.transparent,
                                        Colors.white.withValues(alpha: 0.03),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
