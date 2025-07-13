abstract class TipsEvent {}

class LoadTips extends TipsEvent {
  final String token;
  LoadTips(this.token);
}

class AddTip extends TipsEvent {
  final String token;
  final String title;
  final String content;

  AddTip({required this.token, required this.title, required this.content});
}

class UpdateTip extends TipsEvent {
  final String token;
  final int id;
  final String title;
  final String content;

  UpdateTip({
    required this.token,
    required this.id,
    required this.title,
    required this.content,
  });
}

class DeleteTip extends TipsEvent {
  final String token;
  final int id;

  DeleteTip({required this.token, required this.id});
}
