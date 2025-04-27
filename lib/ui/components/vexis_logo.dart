import 'package:flutter/material.dart';
import 'package:vexis_browser/core/constants.dart';

class VexisLogo extends StatefulWidget {
  final double width;
  final double height;
  final bool animated;
  final bool showText;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? backgroundColor;
  
  const VexisLogo({
    Key? key, 
    this.width = 200.0,
    this.height = 50.0,
    this.animated = true,
    this.showText = true,
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _VexisLogoState createState() => _VexisLogoState();
}

class _VexisLogoState extends State<VexisLogo> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    if (widget.animated) {
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
    final Color primaryColor = widget.primaryColor ?? VexisColors.primaryBlue;
    final Color secondaryColor = widget.secondaryColor ?? VexisColors.secondaryPurple;
    final Color backgroundColor = widget.backgroundColor ?? VexisColors.backgroundColor;
    
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo shield part
              Container(
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  boxShadow: widget.animated ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3 * _glowAnimation.value),
                      blurRadius: 10 * _glowAnimation.value,
                      spreadRadius: 1 * _glowAnimation.value,
                    ),
                  ] : null,
                ),
                child: CustomPaint(
                  size: Size(widget.height, widget.height),
                  painter: VexisLogoPainter(
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    backgroundColor: backgroundColor,
                    glowIntensity: widget.animated ? _glowAnimation.value : 0.5,
                  ),
                ),
              ),
              
              // Text part
              if (widget.showText) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          primaryColor,
                          secondaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'VEXIS',
                      style: TextStyle(
                        fontSize: widget.height * 0.6,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class VexisLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final double glowIntensity;
  
  VexisLogoPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.glowIntensity,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double padding = width * 0.1;
    
    // Draw shield background
    final Path shieldPath = Path();
    shieldPath.moveTo(width * 0.5, padding);
    shieldPath.quadraticBezierTo(padding, height * 0.3, padding, height * 0.5);
    shieldPath.quadraticBezierTo(padding, height * 0.75, width * 0.5, height - padding);
    shieldPath.quadraticBezierTo(width - padding, height * 0.75, width - padding, height * 0.5);
    shieldPath.quadraticBezierTo(width - padding, height * 0.3, width * 0.5, padding);
    
    // Shield gradient fill
    final Paint shieldFillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          backgroundColor,
          backgroundColor.withOpacity(0.8),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;
    
    // Shield border with gradient
    final Paint shieldBorderPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          primaryColor,
          secondaryColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.05
      ..strokeCap = StrokeCap.round;
    
    // Draw shield
    canvas.drawPath(shieldPath, shieldFillPaint);
    canvas.drawPath(shieldPath, shieldBorderPaint);
    
    // Draw 'V' inside shield
    final Path vPath = Path();
    final double vPadding = width * 0.25;
    vPath.moveTo(vPadding, height * 0.3);
    vPath.lineTo(width * 0.5, height * 0.7);
    vPath.lineTo(width - vPadding, height * 0.3);
    
    final Paint vPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          primaryColor,
          secondaryColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    canvas.drawPath(vPath, vPaint);
    
    // Draw circuit lines for tech effect
    final Paint circuitPaint = Paint()
      ..color = primaryColor.withOpacity(0.3 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.02;
    
    // Horizontal line
    final Path horizontalCircuit = Path();
    horizontalCircuit.moveTo(width * 0.3, height * 0.5);
    horizontalCircuit.lineTo(width * 0.7, height * 0.5);
    
    // Vertical line
    final Path verticalCircuit = Path();
    verticalCircuit.moveTo(width * 0.5, height * 0.35);
    verticalCircuit.lineTo(width * 0.5, height * 0.65);
    
    // Node dots
    final nodePaint = Paint()
      ..color = secondaryColor.withOpacity(0.7 * glowIntensity)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(horizontalCircuit, circuitPaint);
    canvas.drawPath(verticalCircuit, circuitPaint);
    
    canvas.drawCircle(Offset(width * 0.3, height * 0.5), width * 0.02, nodePaint);
    canvas.drawCircle(Offset(width * 0.5, height * 0.5), width * 0.02, nodePaint);
    canvas.drawCircle(Offset(width * 0.7, height * 0.5), width * 0.02, nodePaint);
  }
  
  @override
  bool shouldRepaint(covariant VexisLogoPainter oldDelegate) {
    return oldDelegate.glowIntensity != glowIntensity ||
           oldDelegate.primaryColor != primaryColor ||
           oldDelegate.secondaryColor != secondaryColor ||
           oldDelegate.backgroundColor != backgroundColor;
  }
}
