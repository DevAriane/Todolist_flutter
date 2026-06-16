// import 'package:flutter/material.dart';
// import 'package:todolist_flutter/core/app_color.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:getxtra/get.dart';
// import '../../controller/person_controller.dart';
// import '../../global_widget/create_person.dart';

// class Attribuer extends StatelessWidget {
//   final int _selectedPersonId;
//   final VoidCallback change;
//   final VoidCallback changed;
//   Attribuer({super.key, required this._selectedPersonId, required this.change, required this.changed});

//   final PersonController personController = Get.find<PersonController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final persons = personController.persons;

//       if (persons.isEmpty) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Aucune personne disponible',
//               style: TextStyle(color: AppColor.blanc),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () async {
//                   await Get.bottomSheet(
//                     const CreatePerson(),
//                     isScrollControlled: true,
//                     backgroundColor: Colors.transparent,
//                     enableDrag: true,
//                   );

//                   if (personController.persons.isNotEmpty) {
//                     change();
//                   }
//                 },
//                 icon: const Icon(Icons.person_add, color: AppColor.noir),
//                 label: const Text('Créer une personne'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.blanc,
//                   foregroundColor: AppColor.noir,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       }

//       return DropdownButtonFormField<int>(
//         initialValue: _selectedPersonId,
//         hint: const Text(
//           'Sélectionner une personne',
//           style: TextStyle(color: AppColor.blanc),
//         ),
//         isExpanded: true,
//         dropdownColor: Colors.grey[900],
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.grey[900],
//           focusedBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//             borderSide: BorderSide(color: Colors.white60),
//           ),
//           enabledBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//             borderSide: BorderSide(color: AppColor.bordure),
//           ),
//         ),
//         items: persons.map((person) {
//           return DropdownMenuItem<int>(
//             value: person.id,
//             child: Text(person.name),
//           );
//         }).toList(),
//         onChanged: (newId) {
//           setState(() {
//             _selectedPersonId = newId;
//           });
//         },
//       );
//     });
//   }
// }
