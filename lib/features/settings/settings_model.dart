class SettingsModel {
  final bool darkTheme;
  SettingsModel({
    required this.darkTheme,
  });

  Map<String, dynamic> toMap() {
    return {
      'darkTheme': darkTheme,
    };
  }

  static SettingsModel? fromMap(Map<String, dynamic>? map) {
    return map == null
        ? null
        : SettingsModel(
            darkTheme: map['darkTheme'],
          );
  }
}
