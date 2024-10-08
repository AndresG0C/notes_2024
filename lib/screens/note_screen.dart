import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_2024/screens/responsable.dart';
import 'package:notes_2024/screens/widget/custom_textfield.dart';
import 'package:notes_2024/screens/widget/note_dialog.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';


class NotesScreen extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas - P. Movil 2024'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNoteDialog(context),
          ),
          IconButton(
            onPressed: (){
            Get.to(() => ResponsableScreen());
          },
          icon: const Icon(Icons.person_add_alt)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              hintText: 'Buscar...',
              controller: searchController,
              isSearch: true,
              icon: Icons.search,
              // Aquí llamamos al método `filterNotes` del controlador
              onChanged: (value) => noteController.filterNotes(value),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (noteController.filteredNotes.isEmpty) {
                return const  Center(child: Text('No hay notas'));
              }
              return ListView.builder(
                itemCount: noteController.filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = noteController.filteredNotes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.content),
                        Text(
                          'Creada hace ${note.daysSinceCreation()} días',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmation(context, note.id),
                    ),
                    onTap: () => _showNoteDialog(context, note: note, isEdit: true),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Función para mostrar el diálogo de confirmación antes de eliminar
  void _showDeleteConfirmation(BuildContext context, String noteId) {
    Get.defaultDialog(
      title: "Confirmar eliminación",
      middleText: "¿Estás seguro de que deseas eliminar esta nota?",
      textCancel: "Cancelar",
      textConfirm: "Eliminar",
      confirmTextColor: Colors.white,
      onConfirm: () {
        noteController.deleteNote(noteId);
        Get.back(); // Cerrar el diálogo después de eliminar
        Get.snackbar("Nota eliminada", "La nota se ha eliminado correctamente.",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onCancel: () => Get.back(),
    );
  }

  // Función para mostrar el diálogo de agregar/editar notas
  void _showNoteDialog(BuildContext context, {Note? note, bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return NoteDialog(note: note, isEdit: isEdit);
      },
    );
  }
}
