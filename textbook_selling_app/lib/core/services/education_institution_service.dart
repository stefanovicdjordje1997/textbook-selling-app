import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/notifications/snack_bar.dart';

final List<String> _institutionTypes = [
  AppLocalizations.getString(LocalKeys.faculty),
  AppLocalizations.getString(LocalKeys.higherSchool)
];

final _ref = FirebaseDatabase.instance.ref();

class EducationInstitutionService {
  static DataSnapshot? _institutionData;
  static List<Map<dynamic, dynamic>> _universitiesRaw = [];
  static List<Map<dynamic, dynamic>> _institutionsRaw = [];
  static Map<dynamic, dynamic> _degreeLevelsRaw = {};

  static List<String> getInstitutionTypes() {
    return _institutionTypes;
  }

  static Future<List<String>> getUniversities(
      BuildContext context, String? institutionType) async {
    _universitiesRaw = [];
    _institutionData = await _ref
        .child(institutionType == AppLocalizations.getString(LocalKeys.faculty)
            ? 'faculties'
            : 'higher_schools')
        .get();
    if (_institutionData != null && _institutionData!.exists) {
      List<String> universities = [];

      for (final universitySnapshot in _institutionData!.children) {
        final universityData =
            universitySnapshot.value as Map<dynamic, dynamic>;
        _universitiesRaw.add(universityData);

        universities.add(universityData['university']);
      }

      return universities;
    } else {
      if (context.mounted) {
        showSnackBar(
            context: context,
            message:
                AppLocalizations.getString(LocalKeys.gettingDataErrorMessage),
            type: SnackBarType.error);
      }
      return [];
    }
  }

  static List<String> getInstitutions(String? selectedUniversity) {
    _institutionsRaw = [];
    if (selectedUniversity != null &&
        selectedUniversity.isNotEmpty &&
        _universitiesRaw.isNotEmpty) {
      List<String> institutions = [];

      for (final university in _universitiesRaw) {
        if (university['university'] == selectedUniversity) {
          for (final institutionsData in university['edu_institutions']) {
            final institutionData = institutionsData as Map<dynamic, dynamic>;
            institutions.add(institutionData['name']);
            _institutionsRaw.add(institutionData);
          }
        }
      }
      return institutions;
    } else {
      print('No data available.');
      return [];
    }
  }

  static List<String> getDegreeLevels(String? selectedInstitution) {
    _degreeLevelsRaw = {};

    if (selectedInstitution != null &&
        selectedInstitution.isNotEmpty &&
        _universitiesRaw.isNotEmpty) {
      List<String> degreeLevels = [];

      for (final institution in _institutionsRaw) {
        if (institution['name'] == selectedInstitution) {
          final degreeLevelsData =
              institution['study_levels'] as Map<dynamic, dynamic>;
          _degreeLevelsRaw = degreeLevelsData;
          for (final degreeLevel in degreeLevelsData.keys) {
            degreeLevels.add(degreeLevel);
          }
        }
      }

      return degreeLevels;
    } else {
      print('No data available.');
      return [];
    }
  }

  static List<String> getMajors(String? selectedDegreeLevel) {
    if (selectedDegreeLevel != null &&
        selectedDegreeLevel.isNotEmpty &&
        _degreeLevelsRaw.isNotEmpty) {
      List<String> majors = [];
      for (final majorData in _degreeLevelsRaw.entries) {
        if (majorData.key == selectedDegreeLevel) {
          for (final major in majorData.value) {
            majors.add(major.toString());
          }
        }
      }
      return majors;
    } else {
      print('No data available.');
      return [];
    }
  }
}
