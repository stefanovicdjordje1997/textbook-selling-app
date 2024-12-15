import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/notifications/snack_bar.dart';
import 'package:textbook_selling_app/core/services/chat_service.dart';
import 'package:textbook_selling_app/core/services/education_institution_service.dart';
import 'package:textbook_selling_app/core/services/textbook_service.dart';
import 'package:textbook_selling_app/core/services/user_service.dart';
import 'package:textbook_selling_app/core/validation/validators.dart';

const List<String> _emptyStringList = [];
const String _emptyString = '';

class AllTextbooksViewModel extends StateNotifier<AllTextbooksState> {
  AllTextbooksViewModel() : super(AllTextbooksState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    state = state.copyWith(
        yearOfStudy: value == null || value.isEmpty ? 0 : int.tryParse(value));
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

  void onSavedPriceRange(RangeValues? value) {
    state = state.copyWith(priceRange: value);
  }

  String? validateYearOfStudy(String? value) =>
      Validators.validateYearOfStudy(value, canBeEmpty: true);

  bool validateForm() => formKey.currentState?.validate() ?? false;

  String? setSearchLabel(List<String>? data, String? label) {
    return data != null
        ? data.length > 6
            ? label
            : null
        : null;
  }

  String setDefaultItem(String? opt, String def) {
    if (opt == null || opt.isEmpty) {
      return def;
    }
    return opt;
  }

  Future<void> fetchTextbooks({
    required BuildContext context,
    int page = 0,
    int limit = 5,
  }) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);

    try {
      final response = await TextbookService.getAllTextbooks(
          page: page,
          limit: limit,
          institutionType: state.institutionType,
          university: state.selectedUniversity,
          institution: state.selectedInstitution,
          degreeLevel: state.selectedDegreeLevel,
          major: state.selectedMajor,
          yearOfStudy: state.yearOfStudy);

      state = state.copyWith(
        textbooks: [...?state.textbooks, ...response.textbooks],
        totalItems: response.totalItems,
        totalPages: response.totalPages,
        currentPage: page,
        isLoading: false,
      );

      if (response.totalPages == page) return;
    } catch (error) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: error is FirebaseException
              ? error.message ??
                  AppLocalizations.getString(LocalKeys.unknownErrorMessage)
              : AppLocalizations.getString(LocalKeys.anErrorOccuredMessage),
          type: SnackBarType.error,
        );
      }
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshTextbooks(BuildContext context) async {
    // state = AllTextbooksState(); // Resetuje stanje
    state = state.copyWith(
      textbooks: [],
      currentPage: 0,
      totalItems: 0,
      totalPages: 0,
      isLoading: false,
    );

    await fetchTextbooks(context: context); // Ponovno učitavanje
  }

  Future<bool> filterTextbooks(BuildContext context) async {
    if (validateForm()) {
      formKey.currentState?.save();

      state = state.copyWith(
        textbooks: [],
        currentPage: 0,
        totalItems: 0,
        totalPages: 0,
        isLoading: false,
      );

      await fetchTextbooks(context: context); // Ponovno učitavanje
      return true;
    }
    return false;
  }

  Stream<int> streamTotalUnreadMessages() {
    return ChatService.streamTotalUnreadMessages(UserService.getUserId());
  }

  void resetFilters(BuildContext context) {
    state = state.copyWith(
      institutionType: _emptyString,
      selectedUniversity: _emptyString,
      universities: _emptyStringList,
      selectedInstitution: _emptyString,
      institutions: _emptyStringList,
      selectedDegreeLevel: _emptyString,
      degreeLevels: _emptyStringList,
      selectedMajor: _emptyString,
      majors: _emptyStringList,
      yearOfStudy: 0,
    );
    refreshTextbooks(context);
  }
}

class AllTextbooksState {
  final List<Textbook>? textbooks;
  final int currentPage;
  final int totalItems;
  final int totalPages;
  final bool isLoading;

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
  final bool? used;
  final bool? damaged;
  final RangeValues? priceRange;

  AllTextbooksState({
    this.textbooks,
    this.currentPage = 0,
    this.totalItems = 0,
    this.totalPages = 0,
    this.isLoading = false,
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
    this.used = false,
    this.damaged = false,
    this.priceRange = const RangeValues(0.0, 5000.0),
  });

  AllTextbooksState copyWith({
    List<Textbook>? textbooks,
    int? currentPage,
    int? totalItems,
    int? totalPages,
    bool? isLoading,
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
    bool? used,
    bool? damaged,
    RangeValues? priceRange,
  }) {
    return AllTextbooksState(
      textbooks: textbooks ?? this.textbooks,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
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
      used: used ?? this.used,
      damaged: damaged ?? this.damaged,
      priceRange: priceRange ?? this.priceRange,
    );
  }
}

final allTextbooksProvider =
    StateNotifierProvider<AllTextbooksViewModel, AllTextbooksState>(
  (ref) => AllTextbooksViewModel(),
);
