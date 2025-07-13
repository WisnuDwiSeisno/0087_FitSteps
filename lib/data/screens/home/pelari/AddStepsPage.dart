import 'package:fitsteps_app/data/blocs/steps_log/steps_log_bloc.dart';
import 'package:fitsteps_app/data/blocs/steps_log/steps_log_event.dart';
import 'package:fitsteps_app/data/blocs/steps_log/steps_log_state.dart';
import 'package:fitsteps_app/data/services/steps_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStepsPage extends StatefulWidget {
  final String token;
  const AddStepsPage({super.key, required this.token});

  @override
  State<AddStepsPage> createState() => _AddStepsPageState();
}

class _AddStepsPageState extends State<AddStepsPage> {
  final _formKey = GlobalKey<FormState>();
  final _stepsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StepsLogBloc(service: StepsService()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Langkah')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<StepsLogBloc, StepsLogState>(
            listener: (context, state) {
              if (state is StepsSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Langkah berhasil ditambahkan')),
                );
                Navigator.pop(context);
              } else if (state is StepsFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final bloc = context.read<StepsLogBloc>();
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _stepsCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Langkah',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Tidak boleh kosong';
                        }
                        final n = int.tryParse(val);
                        if (n == null || n <= 0) {
                          return 'Masukkan angka yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: state is StepsSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final now = DateTime.now();
                                final today =
                                    "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

                                bloc.add(
                                  SubmitSteps(
                                    token: widget.token,
                                    steps: int.parse(_stepsCtrl.text),
                                    date: today, // ✅ Dikirim dengan benar
                                  ),
                                );
                              }
                            },
                      child: state is StepsSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Kirim'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
