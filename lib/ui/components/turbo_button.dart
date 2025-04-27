import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vexis_browser/core/constants.dart';

class TurboButton extends StatefulWidget {
  final bool isTurboEnabled;
  final bool isSuperTurboEnabled;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const TurboButton({
    Key? key,
    required this.isTurboEnabled,
    required this.isSuperTurboEnabled,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  _TurboButtonState createState() => _TurboButtonState();
}

class _TurboButtonState extends State<TurboButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    if (widget.isTurboEnabled || widget.isSuperTurboEnabled) {
      _animationController.repeat(reverse: true);
    }
  }
  
  @override
  void didUpdateWidget(TurboButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if ((widget.isTurboEnabled || widget.isSuperTurboEnabled) && 
        !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isTurboEnabled && !widget.isSuperTurboEnabled && 
        _animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = widget.isSuperTurboEnabled 
        ? VexisColors.secondaryPurple 
        : (widget.isTurboEnabled ? VexisColors.primaryBlue : Colors.white.withOpacity(0.6));
    
    return GestureDetector(
      onTap: () {
        widget.onTap();
        // Add haptic feedback for button tap
        HapticFeedback.lightImpact();
      },
      onLongPress: () {
        widget.onLongPress();
        // Add haptic feedback for long press
        HapticFeedback.mediumImpact();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isTurboEnabled || widget.isSuperTurboEnabled
                ? _scaleAnimation.value 
                : 1.0,
            child: Transform.rotate(
              angle: widget.isTurboEnabled || widget.isSuperTurboEnabled
                  ? _rotateAnimation.value
                  : 0.0,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: widget.isTurboEnabled || widget.isSuperTurboEnabled
                      ? [
                          BoxShadow(
                            color: buttonColor.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rocket icon
                    Icon(
                      Icons.rocket,
                      color: buttonColor,
                      size: 24,
                    ),
                    
                    // Super Turbo Badge (only visible in Super Turbo mode)
                    if (widget.isSuperTurboEnabled)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: VexisColors.superTurboGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: VexisColors.secondaryPurple.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'X',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
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
    );
  }
}
