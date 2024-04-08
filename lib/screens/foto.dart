import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;



class Http {
  static String url = "https://foto-k2eq.onrender.com/proyecto";
  static postProyectos(Map proyecto) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'content-Type': 'application/json'},
        body: json.encode(proyecto),
      );
      print('Estado de la respuesta: ${res.statusCode}');
      print('Cuerpo de la respuesta: ${res.body}');
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print('Error en la inserción: ${res.reasonPhrase}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
  }
}

class RegistrarProyecto extends StatefulWidget {
  const RegistrarProyecto({super.key});

  @override
  State<RegistrarProyecto> createState() => _RegistrarProyectoState();
}

class _RegistrarProyectoState extends State<RegistrarProyecto> {
 
  Uint8List? fotoBytes; // Variable para almacenar la foto seleccionada
  final _formKey = GlobalKey<FormState>();

  // Método para abrir la cámara y tomar una foto
  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.readAsBytes();

        // Redimensionar la imagen antes de almacenarla
        final image = img.decodeImage(bytes);
        if (image == null) {
          throw Exception('Error al decodificar la imagen');
        }

        // Redimensionar la imagen a una resolución más baja
        final resizedImage = img.copyResize(image, width: 300);

        // Comprimir la imagen ajustando la calidad de compresión
        final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

        setState(() {
          fotoBytes = Uint8List.fromList(compressedBytes);
        });
      } catch (e) {
        print('Error al procesar la imagen: $e');
        // Manejar el error aquí
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Captura de Imagen',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 68, 68, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
             
              
            
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _tomarFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Capturar'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 13, 13, 13), backgroundColor:  const Color.fromARGB(255, 68, 68, 255),
                  ),
                ),
              ),
              // Visualización de la foto seleccionada
              if (fotoBytes != null)
                Image.memory(
                  fotoBytes!,
                  height: 500,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
             
            ],
          ),
        ),
      ),
    );
  }
}