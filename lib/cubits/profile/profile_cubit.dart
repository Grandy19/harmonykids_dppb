import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/profile_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _service = ProfileService();

  ProfileCubit() : super(ProfileInitial());

  // Logic Update Profile dipindah kesini
  Future<void> updateProfile({
    required String name,
    required String email,
    required String alamat,
    required String noTelepon,
    required String gender,
    required String pekerjaan,
    required String hubungan,
    File? imageFile,
  }) async {
    emit(ProfileLoading());

    try {
      bool success = await _service.updateProfile(
        name: name,
        email: email,
        alamat: alamat,
        noTelepon: noTelepon,
        gender: gender,
        pekerjaan: pekerjaan,
        hubungan: hubungan,
        imageFile: imageFile,
      );

      if (success) {
        emit(ProfileSuccess("Data profil berhasil diperbarui!"));
      } else {
        emit(ProfileFailure("Gagal menyimpan profil. Silakan coba lagi."));
      }
    } catch (e) {
      emit(ProfileFailure("Terjadi kesalahan: $e"));
    }
  }
}