import 'package:flutter/foundation.dart';
import 'package:vexis_browser/core/constants.dart';

class Tab {
  final String id;
  String title;
  String url;
  bool isActive;
  
  Tab({
    required this.id,
    required this.title,
    required this.url,
    this.isActive = false,
  });
}

class TabManager extends ChangeNotifier {
  final List<Tab> _tabs = [];
  Tab? _activeTab;
  
  // Getters
  List<Tab> get tabs => _tabs;
  Tab? get activeTab => _activeTab;
  bool get hasTabs => _tabs.isNotEmpty;
  
  // Constructor
  TabManager() {
    _initializeDefaultTab();
  }
  
  // Initialize with a default tab
  void _initializeDefaultTab() {
    final defaultTab = Tab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Tab',
      url: VexisConstants.defaultHomePage,
      isActive: true,
    );
    
    _tabs.add(defaultTab);
    _activeTab = defaultTab;
  }
  
  // Add a new tab
  void addTab({String? url}) {
    // Set all existing tabs to inactive
    for (var tab in _tabs) {
      tab.isActive = false;
    }
    
    // Create new tab
    final newTab = Tab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Tab',
      url: url ?? VexisConstants.defaultHomePage,
      isActive: true,
    );
    
    _tabs.add(newTab);
    _activeTab = newTab;
    notifyListeners();
  }
  
  // Switch to a specific tab
  void switchTab(String tabId) {
    // Set all tabs to inactive
    for (var tab in _tabs) {
      tab.isActive = false;
    }
    
    // Set selected tab to active
    final selectedTab = _tabs.firstWhere((tab) => tab.id == tabId);
    selectedTab.isActive = true;
    _activeTab = selectedTab;
    notifyListeners();
  }
  
  // Close a tab
  void closeTab(String tabId) {
    final index = _tabs.indexWhere((tab) => tab.id == tabId);
    
    if (index == -1) return;
    
    final isActive = _tabs[index].isActive;
    
    // Remove the tab
    _tabs.removeAt(index);
    
    // If we closed the active tab, make another tab active
    if (isActive && _tabs.isNotEmpty) {
      // Try to activate the tab to the right, or fallback to the last tab
      final newIndex = index < _tabs.length ? index : _tabs.length - 1;
      _tabs[newIndex].isActive = true;
      _activeTab = _tabs[newIndex];
    } else if (_tabs.isEmpty) {
      // If no tabs left, add a new default tab
      _initializeDefaultTab();
    }
    
    notifyListeners();
  }
  
  // Update current tab's title
  void updateActiveTabTitle(String title) {
    if (_activeTab != null) {
      _activeTab!.title = title;
      notifyListeners();
    }
  }
  
  // Update current tab's URL
  void updateActiveTabUrl(String url) {
    if (_activeTab != null) {
      _activeTab!.url = url;
      notifyListeners();
    }
  }
}