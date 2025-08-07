import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddHomepage extends StatefulWidget {
  const AddHomepage({super.key});

  @override
  State<AddHomepage> createState() => _AddHomepageState();
}

class _AddHomepageState extends State<AddHomepage> {
  final TextEditingController _channelNameController = TextEditingController();
  final TextEditingController _subscribersController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ownershipController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _monetizationController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _viewsController = TextEditingController();

  // New credential fields
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  File? _profileImageFile;
  List<File> _attachmentFiles = [];
  bool _isLoading = false;

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _profileImageFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _attachmentFiles = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  Future<String> _uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _submit() async {
    if (_channelNameController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      String? profileImageUrl;
      if (_profileImageFile != null) {
        profileImageUrl = await _uploadFile(
          _profileImageFile!,
          'homepage/profile_${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      List<String> attachmentUrls = [];
      if (_attachmentFiles.isNotEmpty) {
        for (int i = 0; i < _attachmentFiles.length; i++) {
          String url = await _uploadFile(
            _attachmentFiles[i],
            'homepage/attachment_${DateTime.now().millisecondsSinceEpoch}_$i',
          );
          attachmentUrls.add(url);
        }
      }

      await FirebaseFirestore.instance.collection('HomepageChannels').add({
        'channelName': _channelNameController.text,
        'subscribers': _subscribersController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'ownershipVerification': _ownershipController.text,
        'category': _categoryController.text,
        'monetization': _monetizationController.text,
        'country': _countryController.text,
        'channelAllTimeViews': _viewsController.text,
        'profileImage': profileImageUrl ?? '',
        'attachments': attachmentUrls,
        'channelGmail': _gmailController.text.trim(),
        'channelPassword': _passwordController.text.trim(),
        'whatsappNumber': _whatsappController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Channel added successfully')),
      );

      _channelNameController.clear();
      _subscribersController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _ownershipController.clear();
      _categoryController.clear();
      _monetizationController.clear();
      _countryController.clear();
      _viewsController.clear();
      _gmailController.clear();
      _passwordController.clear();
      _whatsappController.clear();
      setState(() {
        _profileImageFile = null;
        _attachmentFiles = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Homepage Channel')),


      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _channelNameController, decoration: const InputDecoration(labelText: 'Channel Name')),
            TextField(controller: _subscribersController, decoration: const InputDecoration(labelText: 'Subscribers')),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: _ownershipController, decoration: const InputDecoration(labelText: 'Ownership Verification')),
            TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category')),
            TextField(controller: _monetizationController, decoration: const InputDecoration(labelText: 'Monetization')),
            TextField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country')),
            TextField(controller: _viewsController, decoration: const InputDecoration(labelText: 'Channel All Time Views')),
            const SizedBox(height: 16),
            // New credential inputs
            TextField(controller: _gmailController, decoration: const InputDecoration(labelText: 'Channel Gmail')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Channel Password')),
            TextField(controller: _whatsappController, decoration: const InputDecoration(labelText: 'WhatsApp Number')),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Pick Profile Image'),
              onPressed: _pickProfileImage,
            ),
            if (_profileImageFile != null)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: const Text('Pick Attachments'),
              onPressed: _pickAttachments,
            ),
            if (_attachmentFiles.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
