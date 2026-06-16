import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getxtra/get.dart';
import '../services/api_service.dart';
import '../services/objectbox_service.dart';
import '../models/person_entity.dart';

class PersonController extends GetxController {
  final persons = <PersonEntity>[].obs;
  final isLoading = false.obs;

  bool _isAlreadyLoading = false;

  final ApiService _apiService = ApiService();

  @override
  void onReady() {
    super.onReady();
    loadPersons();
  }

  Future<void> loadPersons() async {
    if (_isAlreadyLoading) return;
    _isAlreadyLoading = true;

    isLoading(true);
    try {
      final localpersons = ObjectBoxService.personBox.getAll();
      if (localpersons.isNotEmpty) {
        persons.value = localpersons;
        return;
      }

      final remotePersons = await _apiService.fetchPersons();
      final List<PersonEntity> personsToSave = [];

      for (final json in remotePersons) {
        final name = (json['name'] ?? '').toString().trim();
        if (name.isEmpty) {
          continue;
        }
        personsToSave.add(PersonEntity(name: name));
      }

      if (personsToSave.isNotEmpty) {
        if (!ObjectBoxService.personBox.isEmpty()) {
          ObjectBoxService.personBox.removeAll();
        }

        ObjectBoxService.personBox.putMany(personsToSave);
      }

      persons.value = ObjectBoxService.personBox.getAll();
    } catch (e) {
      debugPrint('Erreur lors du chargement des personnes : $e');
    } finally {
      isLoading(false);
      _isAlreadyLoading = false;
    }
  }

  bool addPerson(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return false;

    final exists = persons.any(
      (p) => p.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (exists) return false;

    final newPerson = PersonEntity(name: trimmedName);
    final id = ObjectBoxService.personBox.put(newPerson);
    if (id == 0) return false;

    persons.value = ObjectBoxService.personBox.getAll();
    return true;
  }
}
