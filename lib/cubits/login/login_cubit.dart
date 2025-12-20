import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService = AuthService();

  LoginCubit() : super(LoginInitial());
  
  Future<void> login({
    required String email, 
    required String password
  }) async {
    // VALIDASI INPUT 
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure("Email dan Password harus diisi!"));
      return; 
    }

    // Loading
    emit(LoginLoading());

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        emit(LoginSuccess(result['message']));
      } else {
        emit(LoginFailure(result['message']));
      }
    } catch (e) {
      emit(LoginFailure("Terjadi kesalahan sistem: $e"));
    }
  }
}