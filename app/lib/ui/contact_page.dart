import 'dart:io';

import 'package:app/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ContactPage extends StatefulWidget {
  final Contact? contact;

  ContactPage({this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact _editedContact;
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editedContact.name ?? "";
      _phoneController.text = _editedContact.phone ?? "";
      _emailController.text = _editedContact.email ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact.name ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.name!.isNotEmpty &&
                  _editedContact.name != null) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: const Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img!))
                              : const AssetImage("images/pngcont.png")
                                  as ImageProvider),
                    ),
                  ),
                  onTap: () async {
                    await ImagePicker().pickImage(source: ImageSource.camera).then((file){
                      if(file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(labelText: "Nome:"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: "Número:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        onWillPop: _reqPop);
  }

  Future<bool> _reqPop(){
    if(_userEdited){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: const Text("Descartar alteracoes?"),
          content: const Text("Ao sair as informacoes serao perdidas"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("Cancelar")),
            FlatButton(onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            }, child:const Text("Confirmar")),
          ],
        );
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
