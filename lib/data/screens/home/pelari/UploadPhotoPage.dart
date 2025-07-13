import 'dart:io';
import 'package:fitsteps_app/data/blocs/upload_photo/upload_photo_bloc.dart';
import 'package:fitsteps_app/data/blocs/upload_photo/upload_photo_event.dart';
import 'package:fitsteps_app/data/blocs/upload_photo/upload_photo_state.dart';
import 'package:fitsteps_app/data/services/photoservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadPhotoPage extends StatelessWidget {
  final String token;
  const UploadPhotoPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadPhotoBloc(service: PhotoService()),
      child: const _UploadPhotoView(),
    );
  }
}

class _UploadPhotoView extends StatelessWidget {
  const _UploadPhotoView();

  @override
  Widget build(BuildContext context) {
    File? selected;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Foto Bukti')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<UploadPhotoBloc, UploadPhotoState>(
          listener: (context, state) {
            if (state is UploadPhotoSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Foto berhasil diupload')),
              );
              Navigator.pop(context);
            } else if (state is UploadPhotoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<UploadPhotoBloc>();

            return Column(
              children: [
                if (state is PhotoPicked)
                  Image.file(state.photo, height: 200)
                else
                  const Placeholder(fallbackHeight: 200),

                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    bloc.add(PickPhoto());
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pilih Foto'),
                ),

                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: (state is PhotoPicked)
                      ? () {
                          bloc.add(
                            SubmitPhoto(
                              token: context
                                  .findAncestorWidgetOfExactType<
                                    UploadPhotoPage
                                  >()!
                                  .token,
                              photo: state.photo,
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.upload),
                  label: state is UploadPhotoUploading
                      ? const CircularProgressIndicator()
                      : const Text('Upload'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
