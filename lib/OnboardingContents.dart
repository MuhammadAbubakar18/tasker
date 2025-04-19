class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Track Your work and get the result",
    image: "assets/s1.PNG",
    desc: "Welcome!!! Do you want to clear task super fast with Mane.",
  ),
  OnboardingContents(
    title: "Stay organized with team",
    image: "assets/s2.PNG",
    desc:
    "Easily arrange work order for you to manage. Many fucntions to choose",
  ),
  OnboardingContents(
    title: "Get notified when work happens",
    image: "assets/s3.PNG",
    desc:
    "It has been easier to complete tasks. Get started  with us.",
  ),
];