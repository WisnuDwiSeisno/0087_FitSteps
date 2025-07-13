import 'package:flutter/material.dart';
import 'package:fitsteps_app/data/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  final String token;
  final String currentName;

  const EditProfilePage({
    super.key,
    required this.token,
    required this.currentName,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    _nameCtrl = TextEditingController(text: widget.currentName);
    super.initState();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService().updateProfile(widget.token, _nameCtrl.text.trim());
      if (context.mounted) {
        Navigator.pop(context, _nameCtrl.text.trim()); // kembali ke profil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
