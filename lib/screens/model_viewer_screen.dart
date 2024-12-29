import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../models/model_data.dart';

class ModelViewerScreen extends StatefulWidget {
  final int initialModelIndex;
  final List<ModelData> models;

  const ModelViewerScreen({
    super.key,
    required this.initialModelIndex,
    required this.models,
  });

  @override
  State<ModelViewerScreen> createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  late int _currentModelIndex;
  String? selectedPart;
  bool showInfo = false;

  // External asset contents for hotspots
  String? hotspotHtml;
  String? stylesContent;
  String? jsContent;

  @override
  void initState() {
    super.initState();
    _currentModelIndex = widget.initialModelIndex;
    if (widget.models[_currentModelIndex].hasHotspots) {
      _loadHotspotAssets();
    }
  }

  Future<void> _loadHotspotAssets() async {
    try {
      final html = await rootBundle.loadString('assets/heart_hotspots.html');
      final css = await rootBundle.loadString('assets/heart_styles.css');
      final js = await rootBundle.loadString('assets/heart_interactions.js');

      setState(() {
        hotspotHtml = html;
        stylesContent = css;
        jsContent = js;
      });
    } catch (e) {
      debugPrint('Error loading hotspot assets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ModelData currentModel = widget.models[_currentModelIndex];
    final bool isHotspotModel = currentModel.hasHotspots;

    // Wait for hotspot assets if needed
    if (isHotspotModel &&
        (hotspotHtml == null || stylesContent == null || jsContent == null)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentModel.name,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          ModelViewer(
            key: ValueKey(currentModel.path),
            src: currentModel.path,
            alt: "${currentModel.name} Model",
            ar: true,
            autoRotate: true,
            cameraControls: true,
            backgroundColor: Colors.transparent,
            innerModelViewerHtml: isHotspotModel ? hotspotHtml : null,
            relatedCss: isHotspotModel ? stylesContent : null,
            relatedJs: isHotspotModel ? jsContent : null,
            cameraTarget: '0 0 0',
            fieldOfView: '45deg',
            minFieldOfView: '25deg',
            maxFieldOfView: '60deg',
            interpolationDecay: 100,
            javascriptChannels: isHotspotModel
                ? {
                    JavascriptChannel(
                      'flutterChannel',
                      onMessageReceived: (JavaScriptMessage message) {
                        setState(() {
                          if (message.message.isEmpty) {
                            showInfo = false;
                            selectedPart = null;
                          } else {
                            selectedPart = message.message;
                            showInfo = true;
                          }
                        });
                      },
                    ),
                  }
                : null,
          ),
          if (showInfo && selectedPart != null && currentModel.partInfo != null)
            _buildInfoCard(currentModel),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ModelData model) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedPart!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          showInfo = false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  model.partInfo![selectedPart] ?? 'Information not available',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
