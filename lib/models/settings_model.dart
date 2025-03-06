class SettingsModel {
  final bool isLoading;
  final String loadingText;
  SettingsModel({
    required this.isLoading,
    required this.loadingText,
  });

  Map<String, dynamic> toMap() {
    return {
      'isLoading': isLoading,
      'loadingText': loadingText,
    };
  }

  static SettingsModel? fromMap(Map<String, dynamic>? map) {
    return map == null
        ? null
        : SettingsModel(
            isLoading: map['isLoading'],
            loadingText: map['loadingText'],
          );
  }
}
