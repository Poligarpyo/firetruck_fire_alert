enum SGRoute {
  splash,
  home,
  login,
  register,
  forgotPassword,
  firetruckGPS,
  firetruckGPSLogin,
  reportHistory;

  String get route => '/${toString().replaceAll('SGRoute.', '')}';
  String get name => toString().replaceAll('SGRoute.', '');
}