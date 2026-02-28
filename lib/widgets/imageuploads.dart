import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
class ImageUploadWidget extends StatefulWidget {
  final String? initialImageUrl;
  final String storagePath;
  final Function(String url) onImageUploaded;
  final double height;

  const ImageUploadWidget({
    super.key,
    this.initialImageUrl,
    required this.storagePath,
    required this.onImageUploaded,
    this.height = 200,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  String? _imageUrl;
  bool _isUploading = false;
  double _uploadProgress = 0;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _uploadImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) async {
        setState(() => _isUploading = true);

        try {
          final bytes = reader.result as Uint8List;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final storageRef = FirebaseStorage.instance.ref().child(
            '${widget.storagePath}/${timestamp}_${file.name}',
          );

          final uploadTask = storageRef.putData(
            bytes,
            SettableMetadata(contentType: file.type),
          );

          uploadTask.snapshotEvents.listen((snapshot) {
            setState(() => _uploadProgress =
                snapshot.bytesTransferred / snapshot.totalBytes);
          });

          await uploadTask;
          final url = await storageRef.getDownloadURL();

          setState(() {
            _imageUrl = url;
            _isUploading = false;
            _uploadProgress = 0;
          });

          widget.onImageUploaded(url);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded!'), backgroundColor: Colors.green),
            );
          }
        } catch (e) {
          setState(() { _isUploading = false; _uploadProgress = 0; });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imageUrl != null)
          Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                _imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image, size: 48)),
              ),
            ),
          ),
        const SizedBox(height: 12),
        if (_isUploading)
          Column(
            children: [
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 8),
              Text('Uploading: ${(_uploadProgress * 100).toStringAsFixed(0)}%'),
            ],
          )
        else
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: const Icon(Icons.upload_file),
                label: Text(_imageUrl == null ? 'Upload Image' : 'Change Image'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              if (_imageUrl != null) ...[
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _imageUrl = null);
                    widget.onImageUploaded('');
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Remove'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ],
          ),
      ],
    );
  }
}
