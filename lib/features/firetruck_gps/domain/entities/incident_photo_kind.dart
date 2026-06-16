enum IncidentPhotoKind {
  before,
  after;

  int get wireValue => switch (this) {
    IncidentPhotoKind.before => 0,
    IncidentPhotoKind.after => 1,
  };

  static IncidentPhotoKind fromWire(int value) => switch (value) {
    0 => IncidentPhotoKind.before,
    1 => IncidentPhotoKind.after,
    _ => IncidentPhotoKind.before,
  };

  String get storageFolder => switch (this) {
    IncidentPhotoKind.before => 'before',
    IncidentPhotoKind.after => 'after',
  };

  String get rtdbUrlField => switch (this) {
    IncidentPhotoKind.before => 'officer_before_photo_url',
    IncidentPhotoKind.after => 'officer_after_photo_url',
  };

  String get rtdbAtField => switch (this) {
    IncidentPhotoKind.before => 'officer_before_photo_at',
    IncidentPhotoKind.after => 'officer_after_photo_at',
  };

  String get label => switch (this) {
    IncidentPhotoKind.before => 'Before Scene Photo',
    IncidentPhotoKind.after => 'After Response Photo',
  };

  String get helperText => switch (this) {
    IncidentPhotoKind.before =>
      'Upload a photo of the scene when you arrive. Required before completing the response.',
    IncidentPhotoKind.after =>
      'Capture the scene after the incident is resolved.',
  };
}
