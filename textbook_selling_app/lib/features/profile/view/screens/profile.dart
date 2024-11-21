import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/localization/language_notifier.dart';
import 'package:textbook_selling_app/core/utils/show_confirmation_dialog.dart';
import 'package:textbook_selling_app/core/widgets/loader.dart';
import 'package:textbook_selling_app/features/profile/view/widgets/language_switch.dart';
import 'package:textbook_selling_app/features/profile/view/widgets/profile_photo.dart';
import 'package:textbook_selling_app/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:textbook_selling_app/core/widgets/info_row.dart';
import 'package:textbook_selling_app/core/widgets/section_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(profileProvider).user == null) {
        ref.read(profileProvider.notifier).getUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(profileProvider.notifier);
    final user = ref.watch(profileProvider).user;
    final isLoading = ref.watch(profileProvider).isLoading;

    return Scaffold(
      appBar: user != null
          ? AppBar(
              title: Text(
                '${user.firstName} ${user.lastName}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
              ),
              actions: [
                TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () {
                    showConfirmationDialog(
                      context,
                      AppLocalizations.getString(LocalKeys.areYouSure),
                      AppLocalizations.getString(
                          LocalKeys.logoutConfirmationMessage),
                      viewModel.logout,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    AppLocalizations.getString(LocalKeys.logout),
                  ),
                )
              ],
            )
          : null,
      body: isLoading || user == null
          ? const Loader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfilePhoto(imageUrl: user.profilePhoto),
                  const SizedBox(height: 20),
                  SectionCard(
                    title: AppLocalizations.getString(LocalKeys.userDataTitle),
                    children: [
                      InfoRow(
                        icon: Icons.mail_outline_rounded,
                        label: AppLocalizations.getString(LocalKeys.email),
                        value: user.email,
                      ),
                      InfoRow(
                        icon: Icons.calendar_month_rounded,
                        label:
                            AppLocalizations.getString(LocalKeys.dateOfBirth),
                        value:
                            DateFormat('dd.MM.yyyy').format(user.dateOfBirth),
                      ),
                      InfoRow(
                        icon: Icons.phone_rounded,
                        label:
                            AppLocalizations.getString(LocalKeys.phoneNumber),
                        value: user.phoneNumber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LanguageSwitch(
                    leftLanguage: 'SR 🇷🇸',
                    rightLanguage: 'EN 🏴󠁧󠁢󠁥󠁮󠁧󠁿',
                    isLeftLanguageSelected:
                        ref.watch(languageProvider).languageCode == 'sr',
                    onLanguageChange: (bool isLeftSelected) async {
                      await ref
                          .read(languageProvider.notifier)
                          .toggleLanguage();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
