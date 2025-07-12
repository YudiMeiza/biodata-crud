import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BiodataService.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final BiodataService service;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    service = BiodataService(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _addData() async {
    final name = nameController.text.trim();
    final age = ageController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty || age.isEmpty || address.isEmpty) {
      _showMessage('Please fill all the fields');
      return;
    }

    try {
      await service.add({'name': name, 'age': age, 'address': address});
      _showMessage('Data added successfully');
      _clearFields();
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _deleteData(String id) async {
    try {
      await service.delete(id);
      _showMessage('Data deleted successfully');
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _editData(String id, Map<String, dynamic> data) {
    nameController.text = data['name'] ?? '';
    ageController.text = data['age'] ?? '';
    addressController.text = data['address'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Biodata'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearFields();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedData = {
                'name': nameController.text.trim(),
                'age': ageController.text.trim(),
                'address': addressController.text.trim(),
              };

              try {
                await service.update(id, updatedData);
                _showMessage('Data updated successfully');
                Navigator.pop(context);
                _clearFields();
              } catch (e) {
                _showMessage('Error: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    nameController.clear();
    ageController.clear();
    addressController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biodata Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addData,
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: service.getBiodata(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data();
                      return ListTile(
                        title: Text(data['name'] ?? ''),
                        subtitle: Text(
                          'Age: ${data['age']}, Address: ${data['address']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editData(doc.id, data),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteData(doc.id),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
