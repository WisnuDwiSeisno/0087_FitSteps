abstract class ProfileEvent {}
class LoadProfile extends ProfileEvent {
  final String token;

  LoadProfile(this.token);
}

