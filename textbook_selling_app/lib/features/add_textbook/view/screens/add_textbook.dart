import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textbook_selling_app/core/widgets/button.dart';
import 'package:textbook_selling_app/core/widgets/dropdown_menu.dart';
import 'package:textbook_selling_app/core/widgets/photo_gallery.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/add_textbook/view/widgets/switch.dart';
import 'package:textbook_selling_app/features/add_textbook/viewmodel/add_textbook_viewmodel.dart';

class AddTextbookScreen extends ConsumerStatefulWidget {
  const AddTextbookScreen({super.key});

  @override
  ConsumerState<AddTextbookScreen> createState() => _AddTextbookScreenState();
}

class _AddTextbookScreenState extends ConsumerState<AddTextbookScreen> {
  @override
  void deactivate() {
    // Reset state of the provider before dispose
    ref.invalidate(addTextbookViewModelProvider);

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addTextbookViewModelProvider.notifier);
    final universities = ref.watch(addTextbookViewModelProvider).universities;
    final institutions = ref.watch(addTextbookViewModelProvider).institutions;
    final degreeLevels = ref.watch(addTextbookViewModelProvider).degreeLevels;
    final majors = ref.watch(addTextbookViewModelProvider).majors;
    final used = ref.watch(addTextbookViewModelProvider).used;
    final damaged = ref.watch(addTextbookViewModelProvider).damaged;

    List<XFile> images = [];

    void onImageAdded(XFile image) {
      setState(() {
        images.add(image);
      });
    }

    void onImageRemoved(XFile image) {
      setState(() {
        images.remove(image);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Textbook'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: viewModel.formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // Wrap the educational institution fields in a Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const Text(
                              'Educational Institution Informations:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomDropdownMenu<String>(
                              labelText: 'Institution Type',
                              searchLabel: viewModel.setSearchLabel(
                                  viewModel.institutionTypes,
                                  'Search institution type'),
                              items: viewModel.institutionTypes,
                              defaultItem: 'Select institution type',
                              itemDisplayValue: (item) => item,
                              onSelectedItem: (item) {
                                viewModel.onSavedInstitutionType(item);
                                viewModel.getUniversities(context);
                              },
                              validator: viewModel.validateInstitutionType,
                            ),
                            const SizedBox(height: 10),
                            CustomDropdownMenu<String>(
                              labelText: 'University',
                              searchLabel: viewModel.setSearchLabel(
                                  universities, 'Search universities'),
                              enabled: universities != null &&
                                  universities.isNotEmpty,
                              items: universities ?? [],
                              shouldResetSeletion: true,
                              itemDisplayValue: (item) => item,
                              onSelectedItem: (item) {
                                viewModel.onSavedSelectedUniversity(item);
                                viewModel.getInstitutions();
                              },
                              validator: (value) {
                                return viewModel.validateDropdownField(
                                    value: value,
                                    options: universities,
                                    fieldName: 'University');
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomDropdownMenu<String>(
                              labelText: 'Edu. Institution',
                              searchLabel: viewModel.setSearchLabel(
                                  institutions, 'Search institution'),
                              enabled: institutions != null &&
                                  institutions.isNotEmpty,
                              items: institutions ?? [],
                              shouldResetSeletion: true,
                              itemDisplayValue: (item) => item,
                              itemSearchValue: (item) => item,
                              onSelectedItem: (item) {
                                viewModel.onSavedSelectedInstitution(item);
                                viewModel.getDegreeLevels();
                              },
                              validator: (value) {
                                return viewModel.validateDropdownField(
                                    value: value,
                                    options: institutions,
                                    fieldName: 'Edu. Institution');
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomDropdownMenu<String>(
                              labelText: 'Degree Level',
                              searchLabel: viewModel.setSearchLabel(
                                  degreeLevels, 'Search degree level'),
                              enabled: degreeLevels != null &&
                                  degreeLevels.isNotEmpty,
                              items: degreeLevels ?? [],
                              shouldResetSeletion: true,
                              itemDisplayValue: (item) => item,
                              onSelectedItem: (item) {
                                viewModel.onSavedSelectedDegreeLevel(item);
                                viewModel.getMajors();
                              },
                              validator: (value) {
                                return viewModel.validateDropdownField(
                                    value: value,
                                    options: degreeLevels,
                                    fieldName: 'Degree level');
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomDropdownMenu<String>(
                              labelText: 'Major',
                              searchLabel: viewModel.setSearchLabel(
                                  majors, 'Search institution'),
                              enabled: majors != null && majors.isNotEmpty,
                              items: majors ?? [],
                              shouldResetSeletion: true,
                              itemDisplayValue: (item) => item,
                              onSelectedItem: (item) {
                                viewModel.onSavedSelectedMajor(item);
                              },
                              validator: (value) {
                                return viewModel.validateDropdownField(
                                    value: value,
                                    options: majors,
                                    fieldName: 'Major');
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              labelText: 'Year of Study',
                              hintText: 'Year of Study of a textbook',
                              keyboardType: TextInputType.number,
                              validator: viewModel.validateYearOfStudy,
                              onSaved: viewModel.onSavedYearOfStudy,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const Text(
                              'Textbook Informations:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              labelText: 'Textbook name',
                              hintText: 'Enter textbook name',
                              validator: (value) {
                                return viewModel.validateText(
                                    value: value, fieldName: 'Texbook name');
                              },
                              onSaved: viewModel.onSavedName,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              labelText: 'Subject name',
                              hintText: 'Enter subject name',
                              validator: (value) {
                                return viewModel.validateText(
                                    value: value, fieldName: 'Subject name');
                              },
                              onSaved: viewModel.onSavedSubject,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              labelText: 'Publication year',
                              hintText: 'Enter publication year',
                              keyboardType: TextInputType.number,
                              validator: viewModel.validatePublicationYear,
                              onSaved: viewModel.onSavedSubject,
                            ),
                            const SizedBox(height: 10),
                            CustomSwitch(
                              labelText: 'Used',
                              value: used ?? false,
                              onChanged: viewModel.onSavedUsed,
                            ),
                            const SizedBox(height: 10),
                            if (used ?? false)
                              CustomSwitch(
                                labelText: 'Damaged',
                                value: damaged ?? false,
                                onChanged: viewModel.onSavedDamaged,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PhotoGallery(
                      onImageAdded: (image) {
                        onImageAdded(image);
                      },
                      onImageRemoved: (image) {
                        onImageRemoved(image);
                      },
                      images: images,
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          if (MediaQuery.of(context).viewInsets.bottom == 0.0)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surface.withOpacity(0.9),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: CustomButton(
          onPressed: () {
            viewModel.saveForm(context);
          },
          text: 'Add Textbook',
        ),
      ),
    );
  }
}
