import 'package:flutter/material.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';

/// A medication's form as an icon in a soft circle.
class MedicationIcon extends StatelessWidget {
  const MedicationIcon({required this.form, this.size = 44, super.key});

  final MedicationForm form;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.tealSoft,
          shape: BoxShape.circle,
        ),
        child: Icon(
          switch (form) {
            MedicationForm.tablet || MedicationForm.capsule => Icons.medication,
            MedicationForm.liquid => Icons.medication_liquid,
            MedicationForm.drops => Icons.water_drop_outlined,
            MedicationForm.injection => Icons.vaccines_outlined,
            MedicationForm.patch => Icons.healing_outlined,
            MedicationForm.inhaler => Icons.air,
            MedicationForm.other => Icons.local_pharmacy_outlined,
          },
          color: AppColors.tealDark,
          size: size / 2,
        ),
      ),
    );
  }
}
