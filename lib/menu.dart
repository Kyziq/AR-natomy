// lib/menu.dart

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of available anatomy models
    final List<ModelData> models = [
      ModelData(
        name: 'Human Heart',
        path: 'assets/models/human_heart.glb',
        description: 'The heart pumps blood throughout the body.',
      ),
      ModelData(
        name: 'Skeleton',
        path: 'assets/models/skeleton.glb',
        description: 'The skeleton provides structure and protection.',
      ),
      ModelData(
        name: 'Muscle Anatomy',
        path: 'assets/models/muscle_anatomy.glb',
        description: 'Muscles enable movement and maintain posture.',
      ),
      ModelData(
        name: 'Lymphatic System',
        path: 'assets/models/lymphatic_system_overview.glb',
        description: 'The lymphatic system helps in immune responses.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AR-Natomy Menu',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: models.length,
        itemBuilder: (context, index) {
          final model = models[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                Icons.extension,
                color: Colors.blueAccent,
              ),
              title: Text(model.name),
              subtitle: Text(model.description),
              onTap: () {
                // Navigate to the ModelViewerScreen with the selected model
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModelViewerScreen(initialModelIndex: index, models: models),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ModelViewerScreen extends StatefulWidget {
  final int initialModelIndex;
  final List<ModelData> models;

  const ModelViewerScreen({
    super.key,
    required this.initialModelIndex,
    required this.models,
  });

  @override
  _ModelViewerScreenState createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  late int _currentModelIndex;

  @override
  void initState() {
    super.initState();
    _currentModelIndex = widget.initialModelIndex;
  }

  @override
  Widget build(BuildContext context) {
    ModelData currentModel = widget.models[_currentModelIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ar-Natomy',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              key: ValueKey(currentModel.path),
              src: currentModel.path,
              alt: "${currentModel.name} Model",
              ar: true,
              autoRotate: true,
              cameraControls: true,
              backgroundColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currentModel.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
