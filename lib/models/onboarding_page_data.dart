class OnboardingPageData {
  final String image;
  final String title;
  final String description;
  const OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnboardingPageData> onboardingPages = [
  const OnboardingPageData(
    image: 'assets/images/logo2.png',
    title: 'Welcome to PassRight',
    description: 'Your all-in-one exam and skills companion',
  ),
  const OnboardingPageData(
    image: 'assets/images/success.png',
    title: 'Practice Smart',
    description: 'Past questions in CBT style with real-time timer',
  ),
  const OnboardingPageData(
    image: 'assets/images/success.png',
    title: 'Learn Your Way',
    description: 'Switch to your preferred language and learn without borders.',
  ),
  const OnboardingPageData(
    image: 'assets/images/connect.png',
    title: 'Connect & Grow',
    description:
        'Get guidance from our AI helper, join bootcamps, or volunteer to tutor.',
  ),
  const OnboardingPageData(
    image: 'assets/images/tools.png',
    title: 'Beyond Exams',
    description: 'Learn valuable skills to prepare for life after school.',
  ),
];
