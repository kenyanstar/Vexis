import 'package:flutter/material.dart';
import 'package:vexis_browser/core/constants.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class BrowserNavigation extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onForwardPressed;
  final VoidCallback? onHomePressed;
  final VoidCallback? onTabsPressed;
  final VoidCallback? onMenuPressed;
  final int tabCount;
  
  const BrowserNavigation({
    Key? key,
    this.onBackPressed,
    this.onForwardPressed,
    this.onHomePressed,
    this.onTabsPressed,
    this.onMenuPressed,
    this.tabCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: VexisColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(
            icon: FeatherIcons.chevronLeft,
            onPressed: onBackPressed,
            enabled: onBackPressed != null,
          ),
          _buildNavButton(
            icon: FeatherIcons.chevronRight,
            onPressed: onForwardPressed,
            enabled: onForwardPressed != null,
          ),
          _buildNavButton(
            icon: FeatherIcons.home,
            onPressed: onHomePressed,
          ),
          _buildTabButton(
            onPressed: onTabsPressed,
          ),
          _buildNavButton(
            icon: FeatherIcons.moreHorizontal,
            onPressed: onMenuPressed,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavButton({
    required IconData icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        color: enabled ? VexisColors.textColor : VexisColors.textColor.withOpacity(0.3),
      ),
      onPressed: enabled ? onPressed : null,
    );
  }
  
  Widget _buildTabButton({
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: VexisColors.textColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              FeatherIcons.layers,
              size: 20,
              color: VexisColors.textColor,
            ),
            const SizedBox(width: 4),
            Text(
              tabCount.toString(),
              style: const TextStyle(
                color: VexisColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
