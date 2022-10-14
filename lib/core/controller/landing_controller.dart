class LandingController {
  LandingController._pr();
  static final LandingController _instance = LandingController._pr();
  static LandingController get instance => _instance;

  int currentIndex = 0;
}
