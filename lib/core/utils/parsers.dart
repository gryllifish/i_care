/// A non-negative amount typed by a person, with either "," or "." as
/// the decimal separator ("1,5" and "1.5" both work); null otherwise.
double? parseUnits(String text) {
  final value = double.tryParse(text.trim().replaceAll(',', '.'));
  return value == null || value < 0 || !value.isFinite ? null : value;
}
