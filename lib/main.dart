import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore CRUD Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore CRUD Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              label: 'CREATE',
              onPressed: () {
                // Perform create operation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePage()),
                );
              },
            ),
            CustomButton(
              label: 'READ',
              onPressed: () {
                // Perform read operation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadPage()),
                );
              },
            ),
            CustomButton(
              label: 'UPDATE',
              onPressed: () {
                // Perform update operation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePage(documentId: 'UpdatePage',)),
                );
              },
            ),
            CustomButton(
              label: 'DELETE',
              onPressed: () {
                // Perform delete operation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeletePage(documentId: 'DeletePage',)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class CreatePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: subNameController,
              decoration: InputDecoration(labelText: 'SubName'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add data to Firestore
                FirebaseFirestore.instance.collection('PRODUCTS').add({
                  'Name': nameController.text,
                  'SubName': subNameController.text,
                  'Price': priceController.text,
                });
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('PRODUCTS').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['Name']),
                subtitle: Text(data['SubName']),
                trailing: Text('\$${data['Price']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
class UpdatePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final String documentId;

  UpdatePage({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: subNameController,
              decoration: InputDecoration(labelText: 'SubName'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update data in Firestore
                FirebaseFirestore.instance
                    .collection('PRODUCTS')
                    .doc(documentId)
                    .update({
                  'Name': nameController.text,
                  'SubName': subNameController.text,
                  'Price': priceController.text,
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeletePage extends StatelessWidget {
  final String documentId;

  DeletePage({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete this product?',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Delete data from Firestore
                    FirebaseFirestore.instance
                        .collection('PRODUCTS')
                        .doc(documentId)
                        .delete();
                    Navigator.pop(context);
                  },
                  child: Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

