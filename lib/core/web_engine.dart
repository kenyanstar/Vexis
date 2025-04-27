import 'package:flutter/foundation.dart';
import 'package:vexis_browser/browser/turbo_mode.dart';
import 'package:vexis_browser/browser/super_turbo_mode.dart';
import 'package:vexis_browser/core/compression_service.dart';
import 'package:vexis_browser/core/constants.dart';

class WebEngine {
  final TurboModeProvider turboModeProvider;
  final SuperTurboModeProvider superTurboModeProvider;
  final CompressionService compressionService;
  
  WebEngine({
    required this.turboModeProvider,
    required this.superTurboModeProvider,
    required this.compressionService,
  });
  
  // Format URL (add https:// if missing, etc.)
  String formatUrl(String url) {
    if (url.isEmpty) {
      return VexisConstants.defaultHomePage;
    }
    
    // Check if URL is a search query
    if (!url.contains('.') || url.contains(' ')) {
      return '${VexisConstants.defaultSearchEngine}${Uri.encodeComponent(url)}';
    }
    
    // Add https:// if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    
    return url;
  }
  
  // Fetch and process web page content with compression
  Future<String?> fetchWebPage(String url) async {
    try {
      final htmlContent = await compressionService.fetchContent(url);
      
      if (htmlContent == null) {
        return null;
      }
      
      // Apply compression based on mode
      if (superTurboModeProvider.isSuperTurboModeEnabled) {
        // Super Turbo Mode: Apply extreme compression
        final compressedHtml = compressionService.compressHtml(
          htmlContent, 
          VexisConstants.superTurboCompressionLevel,
        );
        
        // Add Super Turbo Mode banner
        final modifiedHtml = _addTurboBanner(
          compressedHtml, 
          true, 
          VexisConstants.superTurboCompressionLevel,
        );
        
        // Record data saved
        int dataSaved = htmlContent.length - compressedHtml.length;
        superTurboModeProvider.addDataSaved(dataSaved);
        
        return modifiedHtml;
      } else if (turboModeProvider.isTurboModeEnabled) {
        // Regular Turbo Mode
        final compressedHtml = compressionService.compressHtml(
          htmlContent, 
          VexisConstants.turboCompressionLevel,
        );
        
        // Add Turbo Mode banner
        final modifiedHtml = _addTurboBanner(
          compressedHtml, 
          false, 
          VexisConstants.turboCompressionLevel,
        );
        
        // Record data saved
        int dataSaved = htmlContent.length - compressedHtml.length;
        turboModeProvider.addDataSaved(dataSaved);
        
        return modifiedHtml;
      }
      
      return htmlContent;
    } catch (e) {
      debugPrint('Error processing web page: $e');
      return null;
    }
  }
  
  // Add turbo mode banner to page
  String _addTurboBanner(String html, bool isSuperTurbo, int compressionLevel) {
    final bannerColor = isSuperTurbo 
        ? '#7F00FF' // purple for super turbo
        : '#005DFF'; // blue for regular turbo
    
    final bannerText = isSuperTurbo 
        ? 'SUPER TURBO MODE' 
        : 'TURBO MODE';
    
    final bannerHtml = '''
    <div style="position: fixed; top: 0; left: 0; right: 0; 
                background-color: $bannerColor; color: white; 
                text-align: center; padding: 5px; z-index: 9999; 
                font-family: sans-serif; font-size: 12px;">
      $bannerText: Saved ${compressionLevel}% data
    </div>
    ''';
    
    // Insert banner after <body> tag
    if (html.contains('<body')) {
      return html.replaceFirst(RegExp(r'<body.*?>'), '\$0$bannerHtml');
    } else {
      return bannerHtml + html;
    }
  }
}