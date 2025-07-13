abstract class UserEvent {}

class LoadUserProfile extends UserEvent {
  final String token;

  LoadUserProfile(this.token);
}
