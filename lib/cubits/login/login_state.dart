abstract class LoginState {}

// Kondisi Awal (Saat halaman baru dibuka)
class LoginInitial extends LoginState {}

// Kondisi Loading (Saat tombol ditekan & spinner berputar)
class LoginLoading extends LoginState {}

// Kondisi Sukses (Login berhasil)
class LoginSuccess extends LoginState {
  final String message;
  LoginSuccess(this.message);
}

// Kondisi Gagal (Password salah / Koneksi error)
class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}