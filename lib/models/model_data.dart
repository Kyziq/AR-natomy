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
        path: 'assets/models/human_heart.glb',
        description:
            'Main organ of human cardiovascular system, a network of blood vessels that pumps blood throughout your body.',
        hasHotspots: true,
        partInfo: {
          'Left Ventricle':
              'The main pumping chamber of the heart that supplies blood to the rest of the body.',
          'Right Ventricle':
              'Pumps blood to the lungs where it picks up oxygen.',
          'Left Atrium':
              'Receives oxygenated blood from the lungs.',
          'Right Atrium':
              'Receives deoxygenated blood from the body.',
          'Aorta':
              'Largest artery that carries oxygenated blood from the left ventricle to the rest of the body.',
        },
      ),
      ModelData(
        name: 'Skeletal System',
        path: 'assets/models/skeletal_system.glb',
        description:
            'Your body\'s support structure. Its parts include your bones, muscles, cartilage and connective tissue like ligaments and tendons.',
      ),
      ModelData(
        name: 'Muscular System',
        path: 'assets/models/muscular_system.glb',
        description: 'An organ system consisting of skeletal, smooth, and cardiac muscle.',
      ),
      ModelData(
        name: 'Lymphatic System',
        path: 'assets/models/lymphatic_system.glb',
        description: 'A group of organs, vessels and tissues that protect you from infection and keep a healthy balance of fluids throughout your body..',
      ),
    ];
  }
}
