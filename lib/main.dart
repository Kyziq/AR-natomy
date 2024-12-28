// lib/main.dart

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'menu.dart';

void main() {
  runApp(const ARnatomyApp());
}

class ARnatomyApp extends StatelessWidget {
  const ARnatomyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AR-NATOMY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        ),
      ),
      home: const MenuPage(),
    );
  }
}

class ModelViewerScreen extends StatefulWidget {
  const ModelViewerScreen({super.key});

  @override
  _ModelViewerScreenState createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  // Define the list of models
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

  // Current selected model index
  int _currentModelIndex = 0;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return AnatomyBottomSheet(
          models: models,
          onModelSelected: (index) {
            setState(() {
              _currentModelIndex = index;
            });
            Navigator.pop(context); // Close bottom sheet
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ModelData currentModel = models[_currentModelIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ar-Natomy',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => _showBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              key: ValueKey(currentModel.path), // Unique key to force rebuild
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
            child: Column(
              children: [
                Text(
                  currentModel.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _currentModelIndex.toDouble(),
                  min: 0,
                  max: (models.length - 1).toDouble(),
                  divisions: models.length - 1,
                  label: models[_currentModelIndex].name,
                  onChanged: (double value) {
                    setState(() {
                      _currentModelIndex = value.round();
                      debugPrint('Selected Model Index: $_currentModelIndex');
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: models.map((model) {
                    int index = models.indexOf(model);
                    return Text(
                      model.name,
                      style: TextStyle(
                        color: _currentModelIndex == index
                            ? Colors.blueAccent
                            : Colors.grey,
                        fontWeight: _currentModelIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnatomyBottomSheet extends StatelessWidget {
  final List<ModelData> models;
  final Function(int) onModelSelected;

  const AnatomyBottomSheet({
    super.key,
    required this.models,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      // height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Anatomy Model',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose a model to explore in 3D!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Divider(),
          ...models.asMap().entries.map((entry) {
            int index = entry.key;
            ModelData model = entry.value;
            return ListTile(
              leading: Icon(
                Icons.extension,
                color: Colors.blueAccent,
              ),
              title: Text(model.name),
              subtitle: Text(model.description),
              onTap: () => onModelSelected(index),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class ModelData {
  final String name;
  final String path;
  final String description;

  ModelData({
    required this.name,
    required this.path,
    required this.description,
  });
}
