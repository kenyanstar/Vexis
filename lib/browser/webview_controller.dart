import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VexisWebViewController {
  InAppWebViewController? _controller;
  
  // Set the controller
  void setController(InAppWebViewController controller) {
    _controller = controller;
  }
  
  // Get controller
  InAppWebViewController? get controller => _controller;
  
  // Load URL
  Future<void> loadUrl(String url) async {
    if (_controller == null) return;
    
    try {
      await _controller!.loadUrl(
        urlRequest: URLRequest(url: Uri.parse(url)),
      );
    } catch (e) {
      debugPrint('Error loading URL: $e');
    }
  }
  
  // Load content
  Future<void> loadContent(String content, {String baseUrl = 'about:blank'}) async {
    if (_controller == null) return;
    
    try {
      await _controller!.loadData(
        data: content,
        mimeType: 'text/html',
        encoding: 'utf-8',
        baseUrl: Uri.parse(baseUrl),
      );
    } catch (e) {
      debugPrint('Error loading content: $e');
    }
  }
  
  // Can go back
  Future<bool> canGoBack() async {
    if (_controller == null) return false;
    
    try {
      return await _controller!.canGoBack();
    } catch (e) {
      debugPrint('Error checking canGoBack: $e');
      return false;
    }
  }
  
  // Can go forward
  Future<bool> canGoForward() async {
    if (_controller == null) return false;
    
    try {
      return await _controller!.canGoForward();
    } catch (e) {
      debugPrint('Error checking canGoForward: $e');
      return false;
    }
  }
  
  // Go back
  Future<void> goBack() async {
    if (_controller == null) return;
    
    try {
      if (await canGoBack()) {
        await _controller!.goBack();
      }
    } catch (e) {
      debugPrint('Error going back: $e');
    }
  }
  
  // Go forward
  Future<void> goForward() async {
    if (_controller == null) return;
    
    try {
      if (await canGoForward()) {
        await _controller!.goForward();
      }
    } catch (e) {
      debugPrint('Error going forward: $e');
    }
  }
  
  // Reload
  Future<void> reload() async {
    if (_controller == null) return;
    
    try {
      await _controller!.reload();
    } catch (e) {
      debugPrint('Error reloading: $e');
    }
  }
  
  // Stop loading
  Future<void> stopLoading() async {
    if (_controller == null) return;
    
    try {
      await _controller!.stopLoading();
    } catch (e) {
      debugPrint('Error stopping loading: $e');
    }
  }
  
  // Get current URL
  Future<String?> getCurrentUrl() async {
    if (_controller == null) return null;
    
    try {
      final url = await _controller!.getUrl();
      return url?.toString();
    } catch (e) {
      debugPrint('Error getting current URL: $e');
      return null;
    }
  }
  
  // Get page title
  Future<String?> getTitle() async {
    if (_controller == null) return null;
    
    try {
      return await _controller!.getTitle();
    } catch (e) {
      debugPrint('Error getting title: $e');
      return null;
    }
  }
  
  // Execute JavaScript
  Future<dynamic> evaluateJavascript(String javascript) async {
    if (_controller == null) return null;
    
    try {
      return await _controller!.evaluateJavascript(source: javascript);
    } catch (e) {
      debugPrint('Error executing JavaScript: $e');
      return null;
    }
  }
  
  // Take screenshot
  Future<Uint8List?> takeScreenshot() async {
    if (_controller == null) return null;
    
    try {
      return await _controller!.takeScreenshot();
    } catch (e) {
      debugPrint('Error taking screenshot: $e');
      return null;
    }
  }
  
  // Get content height
  Future<int?> getContentHeight() async {
    if (_controller == null) return null;
    
    try {
      return await _controller!.getContentHeight();
    } catch (e) {
      debugPrint('Error getting content height: $e');
      return null;
    }
  }
  
  // Clear cache
  Future<void> clearCache() async {
    if (_controller == null) return;
    
    try {
      await _controller!.clearCache();
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
  
  // Find text on page
  Future<void> findText(String text, {int? matchCase}) async {
    if (_controller == null) return;
    
    try {
      await _controller!.findAllAsync(find: text);
    } catch (e) {
      debugPrint('Error finding text: $e');
    }
  }
  
  // Enable dark mode for web content
  Future<void> enableDarkMode() async {
    if (_controller == null) return;
    
    try {
      await _controller!.evaluateJavascript(source: '''
        (function() {
          document.documentElement.style.filter = 'invert(100%) hue-rotate(180deg)';
          document.body.style.backgroundColor = '#000';
          
          // Fix inverted images and videos
          var images = document.querySelectorAll('img, video');
          for (var i = 0; i < images.length; i++) {
            images[i].style.filter = 'invert(100%) hue-rotate(180deg)';
          }
        })();
      ''');
    } catch (e) {
      debugPrint('Error enabling dark mode: $e');
    }
  }
  
  // Set text zoom
  Future<void> setTextZoom(int zoom) async {
    if (_controller == null) return;
    
    try {
      await _controller!.evaluateJavascript(source: '''
        document.body.style.zoom = "$zoom%";
      ''');
    } catch (e) {
      debugPrint('Error setting text zoom: $e');
    }
  }
}
