import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:student_analytics/data_models/study_materials.dart';
import 'package:student_analytics/widgets/snack_bar.dart';

class AddStudyMaterials extends StatefulWidget {
  const AddStudyMaterials(
      {Key? key, required this.subject, required this.semester})
      : super(key: key);
  final subject;
  final semester;
  @override
  _AddStudyMaterialsState createState() => _AddStudyMaterialsState();
}

class _AddStudyMaterialsState extends State<AddStudyMaterials> {
  File? _selectedFile;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();

  Future<void> _pickFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      // No file selected
      return;
    }

    try {
      final storage = FirebaseStorage.instance;
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = storage.ref().child('study_materials/$fileName');

      print('Storage Reference Path: ${storageRef.fullPath}');
      // Upload file to Firebase Storage
      final uploadTask = await storageRef.putFile(_selectedFile!);

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
          icon: Icon(Icons.check));
      titleController.clear();
      setState(() {
        _selectedFile = null;
      });
    } catch (error) {
      // Handle upload error
      print('Error uploading file: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Study Materials'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'enter Document Title',
                    border: OutlineInputBorder()),
              ),
              SizedBox(
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
                      offset: Offset(0, 3),
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
                      padding: EdgeInsets.all(16.0),
                      child: Text(
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
              SizedBox(height: 15),
              if (_selectedFile != null)
                Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.file_present_rounded,
                        color: Colors.blue,
                        size: 60,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Selected File: ${_selectedFile!.path}'.substring(
                          _selectedFile!.path.length - 10,
                          _selectedFile!.path.length)),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      _selectedFile!.path.isNotEmpty) {
                    // perform action
                    await _uploadFile();
                  } else {
                    showSnackBar(
                        context: context,
                        message: 'invalid',
                        icon: Icon(Icons.warning_rounded));
                  }
                },
                child: Text('Upload File'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
