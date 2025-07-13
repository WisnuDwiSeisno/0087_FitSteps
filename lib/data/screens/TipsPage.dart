import 'package:fitsteps_app/data/blocs/tips/tips_bloc.dart';
import 'package:fitsteps_app/data/blocs/tips/tips_event.dart';
import 'package:fitsteps_app/data/blocs/tips/tips_state.dart';
import 'package:fitsteps_app/data/models/tip_model.dart';
import 'package:fitsteps_app/data/services/tip_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TipsPage extends StatelessWidget {
  final String token;
  final String role;

  const TipsPage({super.key, required this.token, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TipsBloc(TipService())..add(LoadTips(token)),
      child: TipsView(token: token, role: role),
    );
  }
}

class TipsView extends StatelessWidget {
  final String token;
  final String role;

  const TipsView({super.key, required this.token, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tips Harian')),
      body: BlocBuilder<TipsBloc, TipsState>(
        builder: (context, state) {
          if (state is TipsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TipsLoaded) {
            return ListView.builder(
              itemCount: state.tips.length,
              itemBuilder: (context, index) {
                final tip = state.tips[index];
                return Card(
                  child: ListTile(
                    title: Text(tip.title),
                    subtitle: Text(tip.content),
                    trailing: role == 'mentor'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditDialog(context, tip);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context.read<TipsBloc>().add(
                                    DeleteTip(token: token, id: tip.id),
                                  );
                                },
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            );
          } else if (state is TipsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: role == 'mentor'
          ? FloatingActionButton(
              onPressed: () => _showAddDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Tip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(labelText: 'Konten'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TipsBloc>().add(
                AddTip(
                  token: token,
                  title: titleCtrl.text,
                  content: contentCtrl.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, TipModel tip) {
    final titleCtrl = TextEditingController(text: tip.title);
    final contentCtrl = TextEditingController(text: tip.content);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Tip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(labelText: 'Konten'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TipsBloc>().add(
                UpdateTip(
                  token: token,
                  id: tip.id,
                  title: titleCtrl.text,
                  content: contentCtrl.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
