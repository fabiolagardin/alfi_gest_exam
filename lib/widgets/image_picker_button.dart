import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerTextField extends StatefulWidget {
  final String labelText;
  final Function(String) onImageSelected;
  final String? imageUrl;

  ImagePickerTextField({
    required this.labelText,
    required this.onImageSelected,
    this.imageUrl,
  });

  @override
  _ImagePickerTextFieldState createState() => _ImagePickerTextFieldState();
}

class _ImagePickerTextFieldState extends State<ImagePickerTextField> {
  late ImagePicker _picker;
  XFile? _imageFile;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = selectedImage;
    });
    _controller.text = _imageFile != null
        ? "${widget.labelText} selezionato"
        : "Aggiungi ${widget.labelText}";
    // Passa il percorso del file all'esterno del widget
    widget.onImageSelected(_imageFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
            filled: true,
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
          keyboardType: TextInputType.streetAddress,
          autocorrect: false,
          readOnly: true,
          onTap: () {
            _controller.text =
                "Aggiungi ${widget.labelText} cliccando sull'icona";
          },
        ),
        IconButton(
          icon: Icon(Icons.photo),
          onPressed: _pickImage,
        ),
        if (_imageFile != null)
          GestureDetector(
            onTap: _pickImage,
            child: Image.file(
              File(_imageFile!.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        if (widget.imageUrl != null && _imageFile == null)
          GestureDetector(
            onTap: _pickImage,
            child: Image.network(
              (widget.imageUrl ?? ''),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
