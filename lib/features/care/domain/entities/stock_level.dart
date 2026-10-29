import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_level.freezed.dart';

/// Units left of a medication, derived from counts, refills and doses.
@freezed
abstract class StockLevel with _$StockLevel {
  const factory StockLevel({
    required double units,

    /// Whole days the stock lasts on the current schedule; null when it
    /// depends on need.
    int? daysLeft,
    @Default(false) bool isLow,
  }) = _StockLevel;
}
