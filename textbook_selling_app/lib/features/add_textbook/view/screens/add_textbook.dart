import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/repository/image_repository.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/viewmodels/photo_gallery_viewmodel.dart';
import 'package:textbook_selling_app/core/widgets/button.dart';
import 'package:textbook_selling_app/features/add_textbook/view/widgets/education_institution_informations.dart';
import 'package:textbook_selling_app/features/add_textbook/view/widgets/textbook_informations.dart';
import 'package:textbook_selling_app/features/add_textbook/view/widgets/textbook_photos.dart';
import 'package:textbook_selling_app/features/add_textbook/viewmodel/add_textbook_viewmodel.dart';

enum TextbookMode {
  viewOnly,
  editing,
}

class AddTextbookScreen extends ConsumerStatefulWidget {
  const AddTextbookScreen({
    super.key,
    this.textbook,
    required this.mode,
  });

  final Textbook? textbook;
  final TextbookMode mode;

  @override
  ConsumerState<AddTextbookScreen> createState() => _AddTextbookScreenState();
}

class _AddTextbookScreenState extends ConsumerState<AddTextbookScreen> {
  @override
  void deactivate() {
    // Reset state of the provider before dispose
    ref.invalidate(addTextbookViewModelProvider);
    ref.invalidate(photoGalleryProvider);
    ImageRepository.clearImages();

    super.deactivate();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(addTextbookViewModelProvider.notifier)
          .setTextbook(widget.textbook, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addTextbookViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.getString(widget.textbook == null
              ? LocalKeys.addTextbook
              : LocalKeys.editTextbook),
        ),
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
                    EducationInstitutionInformations(viewModel: viewModel),
                    const SizedBox(height: 20),
                    TextbookInformations(viewModel: viewModel),
                    const SizedBox(height: 20),
                    TextbookPhotos(mode: widget.mode),
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
            viewModel.saveForm(
                context: context, isEditing: widget.textbook != null);
          },
          text: AppLocalizations.getString(widget.textbook == null
              ? LocalKeys.addTextbook
              : LocalKeys.saveTextbook),
        ),
      ),
    );
  }
}
