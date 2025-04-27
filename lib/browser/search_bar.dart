import 'package:flutter/material.dart';
import 'package:vexis_browser/core/constants.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSubmitted;
  final String currentUrl;
  
  const SearchBar({
    Key? key,
    required this.onSubmitted,
    required this.currentUrl,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showClearButton = false;
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.text = widget.currentUrl;
        setState(() {
          _isEditing = true;
          _showClearButton = _controller.text.isNotEmpty;
        });
      } else {
        setState(() {
          _isEditing = false;
        });
      }
    });
    
    _controller.addListener(() {
      setState(() {
        _showClearButton = _controller.text.isNotEmpty;
      });
    });
  }
  
  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.currentUrl != widget.currentUrl) {
      _controller.text = '';
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: VexisColors.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _focusNode.hasFocus
              ? VexisColors.primaryBlue
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: _displaySearchBarText(),
          hintStyle: TextStyle(
            color: VexisColors.textColor.withOpacity(0.5),
          ),
          prefixIcon: const Icon(
            FeatherIcons.search,
            size: 18,
          ),
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: const Icon(
                    FeatherIcons.x,
                    size: 18,
                  ),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _showClearButton = false;
                    });
                  },
                )
              : null,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: VexisColors.textColor,
        ),
        onSubmitted: (value) {
          widget.onSubmitted(value);
          _focusNode.unfocus();
        },
      ),
    );
  }
  
  String _displaySearchBarText() {
    if (_isEditing) {
      return 'Search or enter URL';
    }
    
    if (widget.currentUrl.isEmpty) {
      return 'Search or enter URL';
    }
    
    // Show truncated URL in the search bar when not editing
    String displayUrl = widget.currentUrl;
    
    // Remove https:// and http:// for display
    if (displayUrl.startsWith('https://')) {
      displayUrl = displayUrl.substring(8);
    } else if (displayUrl.startsWith('http://')) {
      displayUrl = displayUrl.substring(7);
    }
    
    // Remove trailing slash
    if (displayUrl.endsWith('/')) {
      displayUrl = displayUrl.substring(0, displayUrl.length - 1);
    }
    
    return displayUrl;
  }
}
