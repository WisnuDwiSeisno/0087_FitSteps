abstract class RegisterEvent {}

class SubmitRegister extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  SubmitRegister({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });
}
