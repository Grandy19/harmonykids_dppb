import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService = AuthService();

  RegisterCubit() : super(RegisterInitial());

  Future<void> registerWali({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required bool isAgreed, 
  }) async {
    // VALIDASI INPUT (Semua logika pindah ke sini)
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      emit(RegisterFailure("Harap isi semua data!"));
      return;
    }

    if (password != confirmPassword) {
      emit(RegisterFailure("Password tidak sama!"));
      return;
    }

    if (!isAgreed) {
      emit(RegisterFailure("Harap setujui syarat & ketentuan"));
      return;
    }

    // Loading
    emit(RegisterLoading());

    try {
      // Panggil API
      final result = await _authService.registerWali(
        name: name,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
      );

      // Cek Hasil
      if (result['success'] == true) {
        emit(RegisterSuccess(result['message']));
      } else {
        emit(RegisterFailure(result['message']));
      }
    } catch (e) {
      emit(RegisterFailure("Terjadi kesalahan sistem: $e"));
    }
  }
}