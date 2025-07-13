import 'dart:io';
import 'package:fitsteps_app/data/services/photoservice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'upload_photo_event.dart';
import 'upload_photo_state.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoBloc extends Bloc<UploadPhotoEvent, UploadPhotoState> {
  final PhotoService service;

  UploadPhotoBloc({required this.service}) : super(UploadPhotoInitial()) {
    on<PickPhoto>((event, emit) async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        emit(PhotoPicked(File(picked.path)));
      }
    });

    on<SubmitPhoto>((event, emit) async {
      emit(UploadPhotoUploading());
      try {
        await service.uploadPhoto(event.token, event.photo);
        emit(UploadPhotoSuccess());
      } catch (e) {
        emit(UploadPhotoFailure(e.toString()));
      }
    });
  }
}
