import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/repository/image_repository.dart';
import 'package:textbook_selling_app/core/services/education_institution_service.dart';
import 'package:textbook_selling_app/core/services/textbook_service.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';
import 'package:textbook_selling_app/core/notifications/snack_bar.dart';
import 'package:textbook_selling_app/core/validation/validators.dart';

const List<String> _emptyStringList = [];
const String _emptyString = '';

class AddTextbookViewModel extends StateNotifier<AddTextbookState> {
  AddTextbookViewModel() : super(AddTextbookState()) {
    _initialState = state;
  }

  late AddTextbookState _initialState;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool hasStateChanged() => state != _initialState;

  get institutionTypes {
    return EducationInstitutionService.getInstitutionTypes();
  }

  void getUniversities(BuildContext context) async {
    List<String> universities =
        await EducationInstitutionService.getUniversities(
            context, state.institutionType);
    state = state.copyWith(universities: universities);
  }

  void getInstitutions() {
    List<String> institutions =
        EducationInstitutionService.getInstitutions(state.selectedUniversity);
    state = state.copyWith(institutions: institutions);
  }

  void getDegreeLevels() {
    List<String> degreeLevels =
        EducationInstitutionService.getDegreeLevels(state.selectedInstitution);
    state = state.copyWith(degreeLevels: degreeLevels);
  }

  void getMajors() {
    List<String> majors =
        EducationInstitutionService.getMajors(state.selectedDegreeLevel);
    state = state.copyWith(majors: majors);
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
      !institutionTypes.contains(value)
          ? AppLocalizations.getString(LocalKeys.validateEmptyInstitutionType)
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
                message: error.message ??
                    AppLocalizations.getString(LocalKeys.unknownErrorMessage),
                type: SnackBarType.error);
          } else {
            showSnackBar(
                context: context,
                message: AppLocalizations.getString(
                    LocalKeys.addTextbookErrorMessage),
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
