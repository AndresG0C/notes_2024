import 'package:get/get.dart';
// import 'package:notes_2024/screens/responsable.dart';
import 'package:notes_2024/models/responsable_model.dart';
import 'package:notes_2024/services/responsable_service.dart';

class ResponsableController extends GetxController {
  final ResponsableService _responsableService = ResponsableService();
  RxList<Responsable> responsables = <Responsable>[].obs;          // Todas las notas

  @override
  void onInit() {
    super.onInit();
    fetchResponsable();  // Obtener todas las notas al iniciar
  }

  // Obtener todas las notas desde Firestore a través del servicio
  void fetchResponsable() async {
    responsables.value = await _responsableService.getResponsable();
  }

  // Agregar una nota a través del servicio
  Future<void> addResponsable(Responsable responsable) async {
    await _responsableService.addResponsable(responsable);
    fetchResponsable();  // Refrescar la lista de notas después de agregar
  }

}
