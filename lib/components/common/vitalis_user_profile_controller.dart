import 'package:flutter/material.dart';

class VitalisUserProfileController extends ChangeNotifier {
  String _displayName = 'Vitalis';
  DateTime _memberSince = DateTime.now();
  String? _avatarImagePath;
  String? _bannerAssetPath;
  String? _bannerImagePath;
  static const String mockUserId = '0385128903456289734561';

  String get displayName => _displayName;

  DateTime get memberSince => _memberSince;

  String? get avatarImagePath => _avatarImagePath;

  String? get bannerAssetPath => _bannerAssetPath;

  String? get bannerImagePath => _bannerImagePath;

  String get userId => mockUserId;

  void initializeSession({
    required String displayName,
    DateTime? memberSince,
  }) {
    final normalizedName = displayName.trim();
    if (normalizedName.isEmpty) return;

    _displayName = normalizedName;
    _memberSince = memberSince ?? DateTime.now();
    notifyListeners();
  }

  void updateProfile({
    required String displayName,
    String? avatarImagePath,
    String? bannerAssetPath,
    String? bannerImagePath,
  }) {
    final normalizedName = displayName.trim();
    if (normalizedName.isEmpty) return;

    _displayName = normalizedName;
    _avatarImagePath = avatarImagePath;
    _bannerAssetPath = bannerAssetPath;
    _bannerImagePath = bannerImagePath;
    notifyListeners();
  }

  void resetSession() {
    _displayName = 'Vitalis';
    _memberSince = DateTime.now();
    _avatarImagePath = null;
    _bannerAssetPath = null;
    _bannerImagePath = null;
    notifyListeners();
  }
}

class VitalisUserProfileScope
    extends InheritedNotifier<VitalisUserProfileController> {
  const VitalisUserProfileScope({
    super.key,
    required VitalisUserProfileController controller,
    required super.child,
  }) : super(notifier: controller);

  static VitalisUserProfileController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<VitalisUserProfileScope>();
    if (scope == null) {
      throw FlutterError('VitalisUserProfileScope not found in widget tree.');
    }
    return scope.notifier!;
  }
}
