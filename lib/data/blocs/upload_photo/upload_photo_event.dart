import 'dart:io';

abstract class UploadPhotoEvent {}

class PickPhoto extends UploadPhotoEvent {}

class SubmitPhoto extends UploadPhotoEvent {
  final String token;
  final File photo;

  SubmitPhoto({required this.token, required this.photo});
}
