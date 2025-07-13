import 'dart:io';

abstract class UploadPhotoState {}

class UploadPhotoInitial extends UploadPhotoState {}

class PhotoPicked extends UploadPhotoState {
  final File photo;

  PhotoPicked(this.photo);
}

class UploadPhotoUploading extends UploadPhotoState {}

class UploadPhotoSuccess extends UploadPhotoState {}

class UploadPhotoFailure extends UploadPhotoState {
  final String message;

  UploadPhotoFailure(this.message);
}
