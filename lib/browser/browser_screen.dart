import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:vexis_browser/core/constants.dart';
import 'package:vexis_browser/browser/tab_manager.dart';
import 'package:vexis_browser/browser/search_bar.dart';
import 'package:vexis_browser/browser/browser_navigation.dart';
import 'package:vexis_browser/browser/turbo_mode.dart';
import 'package:vexis_browser/browser/super_turbo_mode.dart';
import 'package:vexis_browser/core/web_engine.dart';
import 'package:vexis_browser/core/compression_service.dart';
import 'package:vexis_browser/ui/components/turbo_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late WebEngine _webEngine;
  CompressionService compressionService = CompressionService();
  String _currentUrl = VexisConstants.defaultHomePage;
  String _pageTitle = '';
  bool _isLoading = true;
  double _progress = 0;
  
  @override
  void initState() {
    super.initState();
    // Initialize web engine after providers are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final turboModeProvider = Provider.of<TurboModeProvider>(context, listen: false);
      final superTurboModeProvider = Provider.of<SuperTurboModeProvider>(context, listen: false);
      
      _webEngine = WebEngine(
        turboModeProvider: turboModeProvider,
        superTurboModeProvider: superTurboModeProvider,
        compressionService: compressionService,
      );
      
      // Initialize the tab manager with default tab
      final tabManager = Provider.of<TabManager>(context, listen: false);
      if (tabManager.tabs.isEmpty) {
        tabManager.addTab(VexisConstants.defaultHomePage);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation area
            _buildTopBar(),
            
            // Main browser content
            Expanded(
              child: _buildBrowserContent(),
            ),
            
            // Bottom navigation area
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: VexisColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: SearchBar(
              onSubmitted: (query) {
                final formattedUrl = _webEngine.formatUrl(query);
                _loadUrl(formattedUrl);
              },
              currentUrl: _currentUrl,
            ),
          ),
          const SizedBox(width: 8),
          // Turbo Mode button
          Consumer2<TurboModeProvider, SuperTurboModeProvider>(
            builder: (context, turboProvider, superTurboProvider, child) {
              return TurboButton(
                isTurboEnabled: turboProvider.isTurboModeEnabled,
                isSuperTurboEnabled: superTurboProvider.isSuperTurboModeEnabled,
                onTap: () => _toggleTurboMode(context),
                onLongPress: () => _showTurboModeDetails(context),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildBrowserContent() {
    return Consumer<TabManager>(
      builder: (context, tabManager, child) {
        if (tabManager.tabs.isEmpty) {
          return const Center(
            child: Text('No tabs open'),
          );
        }
        
        final currentTab = tabManager.currentTab;
        _currentUrl = currentTab.url;
        
        return Stack(
          children: [
            // Web content
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(currentTab.url),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  javaScriptEnabled: true,
                  cacheEnabled: true,
                ),
              ),
              onWebViewCreated: (controller) {
                currentTab.controller = controller;
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url?.toString() ?? '';
                _loadUrl(url);
                return NavigationActionPolicy.CANCEL;
              },
              onLoadStart: (controller, url) {
                if (url != null) {
                  setState(() {
                    _isLoading = true;
                    _currentUrl = url.toString();
                    tabManager.updateCurrentTab(url: _currentUrl);
                  });
                }
              },
              onLoadStop: (controller, url) async {
                if (url != null) {
                  final title = await controller.getTitle() ?? '';
                  setState(() {
                    _isLoading = false;
                    _pageTitle = title;
                    _currentUrl = url.toString();
                    tabManager.updateCurrentTab(
                      url: _currentUrl,
                      title: _pageTitle,
                    );
                  });
                }
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
            ),
            
            // Progress indicator
            if (_isLoading)
              LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                backgroundColor: Colors.transparent,
                color: VexisColors.primaryBlue,
                minHeight: 2,
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildBottomNavigation() {
    return Consumer<TabManager>(
      builder: (context, tabManager, child) {
        return BrowserNavigation(
          onBackPressed: _canGoBack ? _goBack : null,
          onForwardPressed: _canGoForward ? _goForward : null,
          onHomePressed: () => _loadUrl(VexisConstants.defaultHomePage),
          onTabsPressed: () => _showTabsDialog(context, tabManager),
          onMenuPressed: () => _showMenuDialog(context),
          tabCount: tabManager.tabs.length,
        );
      },
    );
  }
  
  // Helper methods for browser navigation
  bool get _canGoBack => 
      Provider.of<TabManager>(context, listen: false).currentTab.controller?.canGoBack() ?? Future.value(false) as bool;
  
  bool get _canGoForward => 
      Provider.of<TabManager>(context, listen: false).currentTab.controller?.canGoForward() ?? Future.value(false) as bool;
  
  void _goBack() async {
    final controller = Provider.of<TabManager>(context, listen: false).currentTab.controller;
    if (controller != null && await controller.canGoBack()) {
      controller.goBack();
    }
  }
  
  void _goForward() async {
    final controller = Provider.of<TabManager>(context, listen: false).currentTab.controller;
    if (controller != null && await controller.canGoForward()) {
      controller.goForward();
    }
  }
  
  void _loadUrl(String url) {
    final TabManager tabManager = Provider.of<TabManager>(context, listen: false);
    final formattedUrl = _webEngine.formatUrl(url);
    
    // Check if we should apply Turbo Mode
    final turboMode = Provider.of<TurboModeProvider>(context, listen: false);
    final superTurboMode = Provider.of<SuperTurboModeProvider>(context, listen: false);
    
    if (turboMode.isTurboModeEnabled || superTurboMode.isSuperTurboModeEnabled) {
      // Implement the proxy/compression logic here
      _loadWithTurboMode(formattedUrl);
    } else {
      // Normal loading without compression
      tabManager.currentTab.controller?.loadUrl(
        urlRequest: URLRequest(url: Uri.parse(formattedUrl)),
      );
    }
    
    setState(() {
      _currentUrl = formattedUrl;
      _isLoading = true;
    });
    
    tabManager.updateCurrentTab(url: formattedUrl);
  }
  
  void _loadWithTurboMode(String url) async {
    // In a real implementation, this would use a proper proxy server
    // For now, we'll simulate it by modifying the page content
    final webContent = await _webEngine.fetchWebPage(url);
    
    if (webContent != null) {
      final tabManager = Provider.of<TabManager>(context, listen: false);
      tabManager.currentTab.controller?.loadData(
        data: webContent,
        mimeType: 'text/html',
        encoding: 'utf-8',
        baseUrl: Uri.parse(url),
      );
    } else {
      // Fall back to normal loading if turbo compression fails
      final tabManager = Provider.of<TabManager>(context, listen: false);
      tabManager.currentTab.controller?.loadUrl(
        urlRequest: URLRequest(url: Uri.parse(url)),
      );
    }
  }
  
  void _toggleTurboMode(BuildContext context) {
    final turboProvider = Provider.of<TurboModeProvider>(context, listen: false);
    final superTurboProvider = Provider.of<SuperTurboModeProvider>(context, listen: false);
    
    // Count taps for Super Turbo activation
    turboProvider.incrementTapCount();
    
    // Check if we should enable Super Turbo Mode
    if (turboProvider.tapCount >= VexisConstants.superTurboTapCount && 
        turboProvider.isWithinTapWindow()) {
      superTurboProvider.toggleSuperTurboMode();
      // If Super Turbo is enabled, disable regular Turbo
      if (superTurboProvider.isSuperTurboModeEnabled) {
        turboProvider.setTurboMode(false);
      }
      // Reset tap counter
      turboProvider.resetTapCount();
      
      if (superTurboProvider.isSuperTurboModeEnabled) {
        // Show Super Turbo activated message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.rocket_launch, color: VexisColors.secondaryPurple),
                SizedBox(width: 10),
                Text('🔥 SUPER TURBO MODE ACTIVATED! 🔥'),
              ],
            ),
            backgroundColor: VexisColors.backgroundColor.withOpacity(0.9),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Regular toggle if not activating Super Turbo
      if (!superTurboProvider.isSuperTurboModeEnabled) {
        turboProvider.toggleTurboMode();
      } else {
        // Turn off Super Turbo if it's on
        superTurboProvider.setSuperTurboMode(false);
      }
    }
    
    // Reload the current page with the new turbo settings
    if (_currentUrl.isNotEmpty) {
      _loadUrl(_currentUrl);
    }
  }
  
  void _showTurboModeDetails(BuildContext context) {
    final turboProvider = Provider.of<TurboModeProvider>(context, listen: false);
    final superTurboProvider = Provider.of<SuperTurboModeProvider>(context, listen: false);
    
    final isTurboEnabled = turboProvider.isTurboModeEnabled;
    final isSuperTurboEnabled = superTurboProvider.isSuperTurboModeEnabled;
    
    final dataSaved = isSuperTurboEnabled 
        ? superTurboProvider.dataSavedBytes 
        : turboProvider.dataSavedBytes;
    
    final dataSavedMB = (dataSaved / (1024 * 1024)).toStringAsFixed(2);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: VexisColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSuperTurboEnabled
                    ? 'SUPER TURBO MODE'
                    : isTurboEnabled
                        ? 'TURBO MODE'
                        : 'TURBO MODE (DISABLED)',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: isSuperTurboEnabled
                      ? VexisColors.secondaryPurple
                      : isTurboEnabled
                          ? VexisColors.primaryBlue
                          : VexisColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FeatherIcons.save,
                    color: isSuperTurboEnabled
                        ? VexisColors.secondaryPurple
                        : VexisColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Data Saved: $dataSavedMB MB',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                isSuperTurboEnabled
                    ? 'Super Turbo Mode applies extreme compression for maximum speed and data savings.'
                    : 'Turbo Mode compresses web pages to save data and load faster on slow connections.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: VexisColors.textColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (isSuperTurboEnabled) {
                    superTurboProvider.setSuperTurboMode(false);
                  } else {
                    turboProvider.setTurboMode(!isTurboEnabled);
                  }
                  Navigator.pop(context);
                  
                  // Reload the current page with the new turbo settings
                  if (_currentUrl.isNotEmpty) {
                    _loadUrl(_currentUrl);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuperTurboEnabled || isTurboEnabled
                      ? Colors.redAccent
                      : VexisColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Text(
                  isSuperTurboEnabled || isTurboEnabled ? 'Turn Off' : 'Turn On',
                ),
              ),
              const SizedBox(height: 16),
              if (!isSuperTurboEnabled)
                Text(
                  'Psst! Tap the rocket 5 times quickly to unlock Super Turbo Mode...',
                  style: TextStyle(
                    color: VexisColors.textColor.withOpacity(0.5),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        );
      },
    );
  }
  
  void _showTabsDialog(BuildContext context, TabManager tabManager) {
    showModalBottomSheet(
      context: context,
      backgroundColor: VexisColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tabs (${tabManager.tabs.length})',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        tabManager.addTab(VexisConstants.defaultHomePage);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: tabManager.tabs.length,
                    itemBuilder: (context, index) {
                      final tab = tabManager.tabs[index];
                      final isActive = index == tabManager.currentIndex;
                      
                      return Dismissible(
                        key: ValueKey(tab.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          color: VexisColors.errorColor,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          tabManager.closeTab(index);
                          if (tabManager.tabs.isEmpty) {
                            tabManager.addTab(VexisConstants.defaultHomePage);
                          }
                        },
                        child: ListTile(
                          leading: const Icon(Icons.public),
                          title: Text(
                            tab.title.isNotEmpty ? tab.title : tab.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            tab.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: VexisColors.textColor.withOpacity(0.7),
                            ),
                          ),
                          trailing: isActive
                              ? const Icon(
                                  Icons.check_circle,
                                  color: VexisColors.primaryBlue,
                                )
                              : IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    tabManager.closeTab(index);
                                    if (tabManager.tabs.isEmpty) {
                                      tabManager.addTab(VexisConstants.defaultHomePage);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                          selected: isActive,
                          selectedTileColor: VexisColors.primaryBlue.withOpacity(0.1),
                          onTap: () {
                            tabManager.setCurrentIndex(index);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _showMenuDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: VexisColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(FeatherIcons.refreshCw),
                title: const Text('Reload'),
                onTap: () {
                  Navigator.pop(context);
                  _loadUrl(_currentUrl);
                },
              ),
              ListTile(
                leading: const Icon(FeatherIcons.share2),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              ListTile(
                leading: const Icon(FeatherIcons.download),
                title: const Text('Download Page'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement download functionality
                },
              ),
              ListTile(
                leading: const Icon(FeatherIcons.bookmark),
                title: const Text('Add Bookmark'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement bookmark functionality
                },
              ),
              ListTile(
                leading: const Icon(FeatherIcons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings
                },
              ),
              const Divider(),
              Text(
                'VEXIS Browser v${VexisConstants.appVersion}',
                style: TextStyle(
                  color: VexisColors.textColor.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
