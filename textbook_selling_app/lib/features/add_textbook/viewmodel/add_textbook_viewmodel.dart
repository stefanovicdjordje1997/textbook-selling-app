import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textbook_selling_app/core/repository/image_repository.dart';
import 'package:textbook_selling_app/core/services/textbook_service.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';
import 'package:textbook_selling_app/core/utils/snack_bar.dart';
import 'package:textbook_selling_app/core/utils/validators.dart';

const List<String> _institutionTypes = ['Fakultet', 'Visoka skola'];
final _ref = FirebaseDatabase.instance.ref();
const List<String> _emptyStringList = [];
const String _emptyString = '';

class AddTextbookViewModel extends StateNotifier<AddTextbookState> {
  AddTextbookViewModel() : super(AddTextbookState()) {
    _initialState = state;
  }

  late AddTextbookState _initialState;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DataSnapshot? _institutionData;
  List<Map<dynamic, dynamic>> _universitiesRaw = [];
  List<Map<dynamic, dynamic>> _institutionsRaw = [];
  Map<dynamic, dynamic> _degreeLevelsRaw = {};

  bool hasStateChanged() => state != _initialState;

  get institutionTypes {
    return _institutionTypes;
  }

  void getUniversities(BuildContext context) async {
    _universitiesRaw = [];
    _institutionData = await _ref
        .child(state.institutionType == 'Fakultet'
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

      state = state.copyWith(universities: universities);
    } else {
      if (context.mounted) {
        showSnackBar(
            context: context,
            message: 'Error getting data. Try again later.',
            type: SnackBarType.error);
      }
    }
  }

  void getInstitutions() {
    _institutionsRaw = [];
    if (state.selectedUniversity != null &&
        state.selectedUniversity!.isNotEmpty &&
        _universitiesRaw.isNotEmpty) {
      List<String> institutions = [];

      for (final university in _universitiesRaw) {
        if (university['university'] == state.selectedUniversity) {
          for (final institutionsData in university['edu_institutions']) {
            final institutionData = institutionsData as Map<dynamic, dynamic>;
            institutions.add(institutionData['name']);
            _institutionsRaw.add(institutionData);
          }
        }
      }
      state = state.copyWith(institutions: institutions);
    } else {
      print('No data available.');
    }
  }

  void getDegreeLevels() {
    _degreeLevelsRaw = {};

    if (state.selectedInstitution != null &&
        state.selectedInstitution!.isNotEmpty &&
        _universitiesRaw.isNotEmpty) {
      List<String> degreeLevels = [];

      for (final institution in _institutionsRaw) {
        if (institution['name'] == state.selectedInstitution) {
          final degreeLevelsData =
              institution['study_levels'] as Map<dynamic, dynamic>;
          _degreeLevelsRaw = degreeLevelsData;
          for (final degreeLevel in degreeLevelsData.keys) {
            degreeLevels.add(degreeLevel);
          }
        }
      }

      state = state.copyWith(degreeLevels: degreeLevels);
    } else {
      print('No data available.');
    }
  }

  void getMajors() {
    if (state.selectedDegreeLevel != null &&
        state.selectedDegreeLevel!.isNotEmpty &&
        _degreeLevelsRaw.isNotEmpty) {
      List<String> majors = [];
      for (final majorData in _degreeLevelsRaw.entries) {
        if (majorData.key == state.selectedDegreeLevel) {
          for (final major in majorData.value) {
            majors.add(major.toString());
          }
        }
        state = state.copyWith(majors: majors);
      }
    } else {
      print('No data available.');
    }
  }

  String? setSearchLabel(List<String>? data, String? label) {
    return data != null
        ? data.length > 6
            ? label
            : null
        : null;
  }

  // Validators
  String? validateInstitutionType(String? value) =>
      !_institutionTypes.contains(value)
          ? 'Please select a Institution type'
          : null;

  String? validateDropdownField(
          {required String? value,
          required List<String>? options,
          required String fieldName}) =>
      Validators.validateDropdownField(value, options, fieldName);

  String? validateYearOfStudy(String? value) =>
      Validators.validateYearOfStudy(value);

  String? validateText({String? value, String? fieldName}) =>
      Validators.validateText(
          value: value, fieldName: fieldName, allowNumbers: true);

  String? validatePublicationYear(String? value) =>
      Validators.validateYear(value);

  String? validatePrice(String? value) => Validators.validatePrice(value);

  // On saved methods
  void onSavedInstitutionType(String? value) {
    state = state.copyWith(
      majors: _emptyStringList,
      selectedMajor: _emptyString,
      degreeLevels: _emptyStringList,
      selectedDegreeLevel: _emptyString,
      selectedInstitution: _emptyString,
      institutions: _emptyStringList,
      selectedUniversity: _emptyString,
      universities: _emptyStringList,
      institutionType: value,
    );
  }

  void onSavedSelectedUniversity(String? value) {
    state = state.copyWith(
      majors: _emptyStringList,
      selectedMajor: _emptyString,
      degreeLevels: _emptyStringList,
      selectedDegreeLevel: _emptyString,
      selectedInstitution: _emptyString,
      institutions: _emptyStringList,
      selectedUniversity: value,
    );
  }

  void onSavedSelectedInstitution(String? value) {
    state = state.copyWith(
      majors: _emptyStringList,
      selectedMajor: _emptyString,
      degreeLevels: _emptyStringList,
      selectedDegreeLevel: _emptyString,
      selectedInstitution: value,
    );
  }

  void onSavedSelectedDegreeLevel(String? value) {
    state = state.copyWith(
      majors: _emptyStringList,
      selectedMajor: _emptyString,
      selectedDegreeLevel: value,
    );
  }

  void onSavedSelectedMajor(String? value) {
    state = state.copyWith(selectedMajor: value);
  }

  void onSavedYearOfStudy(String? value) {
    state = state.copyWith(yearOfStudy: int.tryParse(value!));
  }

  void onSavedYearOfPublication(String? value) {
    state = state.copyWith(yearOfPublication: int.tryParse(value!));
  }

  void onSavedName(String? value) {
    state = state.copyWith(name: value);
  }

  void onSavedSubject(String? value) {
    state = state.copyWith(subject: value);
  }

  void onSavedDescription(String? value) {
    state = state.copyWith(description: value);
  }

  void onSavedUsed(bool? value) {
    state = state.copyWith(used: value);
    if (value == false) {
      state = state.copyWith(damaged: value);
    }
  }

  void onSavedDamaged(bool? value) {
    state = state.copyWith(damaged: value);
  }

  void onSavedPrice(String? value) {
    state = state.copyWith(price: double.tryParse(value!));
  }

  // Form validation
  bool validateForm() => formKey.currentState?.validate() ?? false;

  void saveForm(BuildContext context) async {
    if (validateForm()) {
      formKey.currentState?.save();

      showLoader(context);

      try {
        await TextbookService.addTextbook(
          university: state.selectedUniversity,
          institutionType: state.institutionType,
          institution: state.selectedInstitution,
          degreeLevel: state.selectedDegreeLevel,
          major: state.selectedMajor,
          yearOfStudy: state.yearOfStudy,
          yearOfPublication: state.yearOfPublication,
          name: state.name,
          subject: state.subject,
          description: state.description,
          used: state.used,
          damaged: state.damaged,
          price: state.price,
          images: ImageRepository.images,
        );

        if (context.mounted) {
          hideLoader(context);
          Navigator.of(context).pop();
        }
      } catch (error) {
        if (context.mounted) {
          hideLoader(context);

          if (error is FirebaseException) {
            showSnackBar(
                context: context,
                message: error.message ?? 'Unknown error.',
                type: SnackBarType.error);
          } else {
            showSnackBar(
                context: context,
                message: 'Error adding textbook. Try again.',
                type: SnackBarType.error);
          }
        }
      }
    }
  }
}

class AddTextbookState {
  final List<String>? universities;
  final String? selectedUniversity;
  final String? institutionType;
  final List<String>? institutions;
  final String? selectedInstitution;
  final List<String>? degreeLevels;
  final String? selectedDegreeLevel;
  final List<String>? majors;
  final String? selectedMajor;
  final int? yearOfStudy;
  final int? yearOfPublication;
  final String? name;
  final String? subject;
  final String? description;
  final bool? used;
  final bool? damaged;
  final double? price;
  final List<XFile>? pictures;

  // Constructor
  AddTextbookState({
    this.universities,
    this.selectedUniversity,
    this.institutionType,
    this.institutions,
    this.selectedInstitution,
    this.degreeLevels,
    this.selectedDegreeLevel,
    this.majors,
    this.selectedMajor,
    this.yearOfStudy,
    this.yearOfPublication,
    this.name,
    this.subject,
    this.description,
    this.used = false,
    this.damaged = false,
    this.price,
    this.pictures,
  });

  // Method to create a copy of the state with modified values
  AddTextbookState copyWith({
    List<String>? universities,
    String? selectedUniversity,
    String? institutionType,
    List<String>? institutions,
    String? selectedInstitution,
    List<String>? degreeLevels,
    String? selectedDegreeLevel,
    List<String>? majors,
    String? selectedMajor,
    int? yearOfStudy,
    int? yearOfPublication,
    String? name,
    String? subject,
    String? description,
    bool? used,
    bool? damaged,
    double? price,
    List<XFile>? pictures,
  }) {
    return AddTextbookState(
      universities: universities ?? this.universities,
      selectedUniversity: selectedUniversity ?? this.selectedUniversity,
      institutionType: institutionType ?? this.institutionType,
      institutions: institutions ?? this.institutions,
      selectedInstitution: selectedInstitution ?? this.selectedInstitution,
      degreeLevels: degreeLevels ?? this.degreeLevels,
      selectedDegreeLevel: selectedDegreeLevel ?? this.selectedDegreeLevel,
      majors: majors ?? this.majors,
      selectedMajor: selectedMajor ?? this.selectedMajor,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      yearOfPublication: yearOfPublication ?? this.yearOfPublication,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      used: used ?? this.used,
      damaged: damaged ?? this.damaged,
      price: price ?? this.price,
      pictures: pictures ?? this.pictures,
    );
  }
}

final addTextbookViewModelProvider =
    StateNotifierProvider<AddTextbookViewModel, AddTextbookState>(
  (ref) => AddTextbookViewModel(),
);
