/// How the demo shows its simulated phones, chosen by the page's address:
/// `?single` opens one caregiver's phone alone.
enum DemoLayout {
  /// An admin's and a helper's phone side by side when there is room.
  twoPhones,

  /// One caregiver's phone, on a simulated server of its own.
  onePhone;

  /// The query parameter that asks for [onePhone].
  static const singleParameter = 'single';

  static DemoLayout fromUri(Uri uri) =>
      uri.queryParameters.containsKey(singleParameter) ? onePhone : twoPhones;
}
