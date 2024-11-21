import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/widgets/photo_gallery.dart';
import 'package:textbook_selling_app/features/add_textbook/view/screens/add_textbook.dart';
import 'package:textbook_selling_app/features/textbook_details/view/widgets/favorite_button.dart';
import 'package:textbook_selling_app/core/widgets/info_row.dart';
import 'package:textbook_selling_app/core/widgets/section_card.dart';
import 'package:textbook_selling_app/features/textbook_details/view/widgets/user_info_card.dart';
import 'package:textbook_selling_app/features/textbook_details/viewmodel/textbook_details_viewmodel.dart';

enum TextbookDetailsContext {
  favorites,
  myTextbooks,
  general,
}

class TextbookDetailsScreen extends ConsumerStatefulWidget {
  const TextbookDetailsScreen({
    super.key,
    required this.textbook,
    this.context = TextbookDetailsContext.general,
    this.onEdit,
    this.onDelete,
  });

  final Textbook textbook;
  final TextbookDetailsContext context;
  final void Function(Textbook textbook)? onEdit;
  final void Function(Textbook textbook)? onDelete;

  @override
  ConsumerState createState() => _TextbookDetailsScreenState();
}

class _TextbookDetailsScreenState extends ConsumerState<TextbookDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = ref.read(textbookDetailsProvider.notifier);
      viewModel.loadFavoriteStatus(widget.textbook);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(textbookDetailsProvider.notifier);
    final isFavorite = ref.watch(textbookDetailsProvider).isFavorite;
    final textbook = widget.textbook;
    final user = textbook.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          textbook.name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
          maxLines: 3,
        ),
        centerTitle: true,
        actions: [
          if (widget.context == TextbookDetailsContext.favorites)
            FavoriteButton(
              isFavorite: isFavorite,
              onPressed: () => viewModel.toggleFavorite(textbook),
            ),
          if (widget.context == TextbookDetailsContext.myTextbooks) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => widget.onEdit?.call(textbook),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => widget.onDelete?.call(textbook),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserInfoCard(user: user!),
            const SizedBox(height: 20),
            PhotoGallery(
              images: textbook.imageUrls,
              onImageAdded: (image) {},
              onImageRemoved: (image) {},
              mode: TextbookMode.viewOnly,
            ),
            const SizedBox(height: 20),
            SectionCard(
              title: AppLocalizations.getString(
                  LocalKeys.educationInstitutionInformationsTitle),
              children: [
                InfoRow(
                  icon: Icons.account_balance,
                  label: AppLocalizations.getString(
                      LocalKeys.institutionTypeLabel),
                  value: textbook.institutionType,
                ),
                InfoRow(
                  icon: Icons.school,
                  label: AppLocalizations.getString(LocalKeys.universityLabel),
                  value: textbook.university,
                ),
                InfoRow(
                  icon: Icons.location_city,
                  label:
                      AppLocalizations.getString(LocalKeys.eduInstitutionLabel),
                  value: textbook.institution,
                ),
                InfoRow(
                  icon: Icons.book,
                  label: AppLocalizations.getString(LocalKeys.degreeLevelLabel),
                  value: textbook.degreeLevel,
                ),
                InfoRow(
                  icon: Icons.merge_type,
                  label: AppLocalizations.getString(LocalKeys.majorLabel),
                  value: textbook.major,
                ),
                InfoRow(
                  icon: Icons.calendar_today,
                  label: AppLocalizations.getString(LocalKeys.yearOfStudyLabel),
                  value: textbook.yearOfStudy.toString(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SectionCard(
              title: AppLocalizations.getString(
                  LocalKeys.textbookInformationsTitle),
              children: [
                InfoRow(
                    icon: Icons.subject,
                    label:
                        AppLocalizations.getString(LocalKeys.subjectNameLabel),
                    value: textbook.subject),
                InfoRow(
                    icon: Icons.calendar_today,
                    label: AppLocalizations.getString(
                        LocalKeys.publicationYearLabel),
                    value: textbook.yearOfPublication.toString()),
                InfoRow(
                  icon: Icons.check_circle_outline,
                  label: AppLocalizations.getString(LocalKeys.usedLabel),
                  value: textbook.used
                      ? AppLocalizations.getString(LocalKeys.yesText)
                      : AppLocalizations.getString(LocalKeys.noText),
                ),
                if (textbook.used)
                  InfoRow(
                    icon: Icons.warning_amber_outlined,
                    label: AppLocalizations.getString(LocalKeys.damagedLabel),
                    value: textbook.damaged
                        ? AppLocalizations.getString(LocalKeys.yesText)
                        : AppLocalizations.getString(LocalKeys.noText),
                  ),
                if (textbook.description.isNotEmpty)
                  InfoRow(
                      icon: Icons.description_outlined,
                      label: AppLocalizations.getString(
                          LocalKeys.descriptionLabel),
                      value: textbook.description),
                InfoRow(
                    icon: Icons.attach_money,
                    label: AppLocalizations.getString(LocalKeys.priceLabel),
                    value: "${textbook.price.toStringAsFixed(0)} RSD"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
