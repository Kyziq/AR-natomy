class ModelData {
  final String name;
  final String path;
  final String description;
  final bool hasHotspots;
  final Map<String, String>? partInfo;

  ModelData({
    required this.name,
    required this.path,
    required this.description,
    this.hasHotspots = false,
    this.partInfo,
  });

  // Sample data factory
  static List<ModelData> getSampleModels() {
    return [
      ModelData(
        name: 'Human Heart',
        path: 'assets/models/realistic_human_heart.glb',
        description:
            'Interactive 3D model of the human heart with detailed annotations.',
        hasHotspots: true,
        partInfo: {
          'Left Ventricle':
              'The left ventricle is the main pumping chamber of the heart that supplies blood to the rest of the body.',
          'Right Ventricle':
              'The right ventricle pumps blood to the lungs where it picks up oxygen.',
          'Left Atrium':
              'The left atrium receives oxygenated blood from the lungs.',
          'Right Atrium':
              'The right atrium receives deoxygenated blood from the body.',
          'Aorta':
              'The aorta is the largest artery that carries oxygenated blood from the left ventricle to the rest of the body.',
        },
      ),
      ModelData(
        name: 'Skeleton',
        path: 'assets/models/skeleton.glb',
        description:
            'The skeleton provides structure and protection to the body.',
      ),
      ModelData(
        name: 'Muscle Anatomy',
        path: 'assets/models/muscle_anatomy.glb',
        description: 'Detailed view of human muscular system.',
      ),
      ModelData(
        name: 'Lymphatic System',
        path: 'assets/models/lymphatic_system_overview.glb',
        description: 'Overview of the lymphatic system and immune responses.',
      ),
    ];
  }
}
