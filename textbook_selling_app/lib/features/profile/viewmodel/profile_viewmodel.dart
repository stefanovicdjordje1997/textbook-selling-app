import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/models/user.dart';
import 'package:textbook_selling_app/core/services/auth_service.dart';
import 'package:textbook_selling_app/core/services/user_service.dart';

class ProfileViewmodel extends StateNotifier<ProfileState> {
  ProfileViewmodel() : super(ProfileState());

  Future<void> getUserData() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await UserService.getUserData();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error fetching user textbooks: $e');
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await AuthService.logoutUser();
    state = state.copyWith(isLoading: false, user: null);
  }
}

class ProfileState {
  final User? user;
  final bool isLoading;

  ProfileState({
    this.user,
    this.isLoading = false,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
  }) {
    return ProfileState(
      user: user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileViewmodel, ProfileState>(
  (ref) => ProfileViewmodel(),
);
