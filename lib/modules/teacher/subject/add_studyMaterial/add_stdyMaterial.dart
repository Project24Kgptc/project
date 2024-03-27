import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:student_analytics/data_models/study_materials.dart';
import 'package:student_analytics/widgets/snack_bar.dart';
import 'package:student_analytics/widgets/text_field.dart';

class AddStudyMaterials extends StatefulWidget {
  const AddStudyMaterials(
      {Key? key, required this.subject, required this.semester,required this.subId})
      : super(key: key);
      final subId;
  final subject;
  final semester;
  @override
  _AddStudyMaterialsState createState() => _AddStudyMaterialsState();
}

class _AddStudyMaterialsState extends State<AddStudyMaterials> {
  PlatformFile? _selectedFile;
  TextEditingController titleController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = result.files[0];
      });
    }
  }

  Future<void> _uploadFile(subId) async {
    if (_selectedFile == null) {
      // No file selected
      return;
    }

    try {
      final storage = FirebaseStorage.instance;
      final fileName = _selectedFile!.name;
      final storageRef = storage.ref().child('$subId/$fileName');

      final File filee = File(_selectedFile!.path!);

      print('Storage Reference Path: ${storageRef.fullPath}');
      // Upload file to Firebase Storage
      final uploadTask = await storageRef.putFile(filee);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Store data in Firestore
      final firestore = FirebaseFirestore.instance;
      StudyMaterialModel data = StudyMaterialModel(
          subject: widget.subject,
          semester: widget.semester,
          name: titleController.text,
          downloadUrl: downloadUrl);
      await firestore.collection('study_materials').add(data.toMap());

      // File uploaded successfully
      showSnackBar(
          context: context,
          message: 'File uploaded successfully',
          icon: const Icon(Icons.check));
      titleController.clear();
      setState(() {
        _selectedFile = null;
      });
    } catch (error) {
      // Handle upload error
      print('Error uploading file: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error uploading file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA95DE7),
        title: const Text('Add Study Materials'),
      ),
      body: Container(
        height: double.infinity,
          			width: double.infinity,
					decoration: const BoxDecoration(
						image: DecorationImage(
							image: AssetImage('assets/background_images/bg.jpeg'),
							fit: BoxFit.cover
						),
						
					),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  labelText: 'Document title',
                  prefixIcon: Icons.image,
                  controller: titleController,
                  validator: (s) => null,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the value for the desired curve
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickFile,
                      borderRadius: BorderRadius.circular(
                          15.0), // Use the same value as in the BoxDecoration
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          'Choose File',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                if (_selectedFile != null)
                  Container(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.file_present_rounded,
                          color: Colors.blue,
                          size: 60,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Selected File: ${_selectedFile!.name}'),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        _selectedFile != null) {
                      // perform action
                      await _uploadFile(widget.subId);
                    } else {
                      showSnackBar(
                          context: context,
                          message: 'invalid',
                          icon: const Icon(Icons.warning_rounded));
                    }
                  },
                  child: const Text('Upload File'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
