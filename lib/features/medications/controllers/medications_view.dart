import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medications_view.g.dart';

/// An active medication and its stock (null until someone counts it).
typedef MedicationRow = ({Medication medication, StockLevel? stock});

/// Active medications by name, each with its stock.
@riverpod
AsyncValue<List<MedicationRow>> medicationsView(Ref ref) => ref
    .watch(careLogProvider)
    .whenData(
      (log) => [
        for (final medication in log.medications)
          (medication: medication, stock: log.stockOf(medication.id)),
      ],
    );
