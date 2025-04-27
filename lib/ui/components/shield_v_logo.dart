import 'package:flutter/material.dart';
import 'package:vexis_browser/core/constants.dart';

class ShieldVLogo extends StatefulWidget {
  final double size;
  final Color? glowColor;
  final bool animate;
  final double strokeWidth;

  const ShieldVLogo({
    Key? key, 
    this.size = 100.0, 
    this.glowColor,
    this.animate = false,
    this.strokeWidth = 3.0,
  }) : super(key: key);

  @override
  _ShieldVLogoState createState() => _ShieldVLogoState();
}

class _ShieldVLogoState extends State<ShieldVLogo> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _glowAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    if (widget.animate) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color glowColor = widget.glowColor ?? VexisColors.primaryBlue;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: widget.animate ? [
              BoxShadow(
                color: glowColor.withOpacity(0.3),
                blurRadius: 20 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ] : [],
          ),
          child: Transform.scale(
            scale: widget.animate ? _pulseAnimation.value : 1.0,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: ShieldVPainter(
                strokeWidth: widget.strokeWidth,
                shieldOutlineColor: VexisColors.shieldOutline,
                shieldFillColor: VexisColors.shieldFill,
                vColor: VexisColors.shieldHighlight,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShieldVPainter extends CustomPainter {
  final double strokeWidth;
  final Color shieldOutlineColor;
  final Color shieldFillColor;
  final Color vColor;

  ShieldVPainter({
    required this.strokeWidth,
    required this.shieldOutlineColor,
    required this.shieldFillColor,
    required this.vColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    // Shield path
    final Path shieldPath = Path();
    shieldPath.moveTo(width * 0.5, height * 0.05); // Top center
    shieldPath.quadraticBezierTo(width * 0.1, height * 0.25, width * 0.1, height * 0.5); // Left curve
    shieldPath.quadraticBezierTo(width * 0.1, height * 0.8, width * 0.5, height * 0.95); // Bottom left curve
    shieldPath.quadraticBezierTo(width * 0.9, height * 0.8, width * 0.9, height * 0.5); // Bottom right curve
    shieldPath.quadraticBezierTo(width * 0.9, height * 0.25, width * 0.5, height * 0.05); // Right curve
    
    // Shield fill paint
    final Paint shieldFillPaint = Paint()
      ..color = shieldFillColor
      ..style = PaintingStyle.fill;
    
    // Shield outline paint
    final Paint shieldOutlinePaint = Paint()
      ..color = shieldOutlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    // Draw shield
    canvas.drawPath(shieldPath, shieldFillPaint);
    canvas.drawPath(shieldPath, shieldOutlinePaint);
    
    // Draw 'V' inside shield
    final Paint vPaint = Paint()
      ..color = vColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    final Path vPath = Path();
    vPath.moveTo(width * 0.3, height * 0.3);  // Top left of V
    vPath.lineTo(width * 0.5, height * 0.7);  // Bottom center of V
    vPath.lineTo(width * 0.7, height * 0.3);  // Top right of V
    
    canvas.drawPath(vPath, vPaint);
    
    // Add circuit-like lines in the background to hint at tech/speed
    final Paint circuitPaint = Paint()
      ..color = shieldOutlineColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.4;
    
    // Draw horizontal circuit line
    final Path horizontalCircuit = Path();
    horizontalCircuit.moveTo(width * 0.25, height * 0.5);
    horizontalCircuit.lineTo(width * 0.75, height * 0.5);
    
    // Draw diagonal circuit lines
    final Path diagonalCircuit1 = Path();
    diagonalCircuit1.moveTo(width * 0.3, height * 0.3);
    diagonalCircuit1.lineTo(width * 0.4, height * 0.6);
    
    final Path diagonalCircuit2 = Path();
    diagonalCircuit2.moveTo(width * 0.7, height * 0.3);
    diagonalCircuit2.lineTo(width * 0.6, height * 0.6);
    
    // Draw additional circuit element (node)
    final Path nodeCircuit = Path();
    nodeCircuit.addOval(Rect.fromCircle(
      center: Offset(width * 0.5, height * 0.4),
      radius: width * 0.03,
    ));
    
    canvas.drawPath(horizontalCircuit, circuitPaint);
    canvas.drawPath(diagonalCircuit1, circuitPaint);
    canvas.drawPath(diagonalCircuit2, circuitPaint);
    canvas.drawPath(nodeCircuit, circuitPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
