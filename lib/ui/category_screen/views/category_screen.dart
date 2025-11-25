// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../customs.dart';
//
// class CategoryScreen extends StatelessWidget {
//   const CategoryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final categoryViewModel = Get.put(CategoryViewModel());
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 25),
//             const Text(
//               'Tell us who you are?',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//             ),
//             const SizedBox(height: 5),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.0),
//               child: Text(
//                 'Choose a category so we can personalize your experience',
//                 style: TextStyle(fontSize: 13.5),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 35),
//             Obx(
//                   () => DropdownButtonFormField<String>(
//                 value: categoryViewModel.selectedCategory.value,
//                 dropdownColor: Colors.white,
//                 items: const [
//                   DropdownMenuItem(
//                     value: 'student',
//                     child: Text('Student', style: TextStyle(fontSize: 13.5)),
//                   ),
//                   DropdownMenuItem(
//                     value: 'job_seeker',
//                     child: Text('Job Seeker', style: TextStyle(fontSize: 13.5)),
//                   ),
//                   DropdownMenuItem(
//                     value: 'professional',
//                     child: Text('Professional', style: TextStyle(fontSize: 13.5)),
//                   ),
//                 ],
//                 onChanged: (val) {
//                   categoryViewModel.selectedCategory.value = val;
//                   if (val != 'student') {
//                     categoryViewModel.selectedStudentLevel.value = null;
//                   }
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Category',
//                   hintStyle: const TextStyle(fontSize: 13.5),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Obx(
//                   () => categoryViewModel.selectedCategory.value == 'student'
//                   ? DropdownButtonFormField<String>(
//                 value: categoryViewModel.selectedStudentLevel.value,
//                 dropdownColor: Colors.white,
//                 items: const [
//                   DropdownMenuItem(
//                     value: 'matric',
//                     child: Text('Matric', style: TextStyle(fontSize: 13.5)),
//                   ),
//                   DropdownMenuItem(
//                     value: 'intermediate',
//                     child: Text('Intermediate', style: TextStyle(fontSize: 13.5)),
//                   ),
//                   DropdownMenuItem(
//                     value: 'university',
//                     child: Text('University Student', style: TextStyle(fontSize: 13.5)),
//                   ),
//                 ],
//                 onChanged: (val) => categoryViewModel.selectedStudentLevel.value = val,
//                 decoration: InputDecoration(
//                   hintText: 'Select student level',
//                   hintStyle: const TextStyle(fontSize: 13.5),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               )
//                   : const SizedBox.shrink(),
//             ),
//             const SizedBox(height: 65),
//             Obx(
//                   () => ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 3,
//                   minimumSize: const Size(double.infinity, 54),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   backgroundColor: AppColors.primaryGreen,
//                 ),
//                 onPressed: categoryViewModel.isLoading.value ? null : categoryViewModel.saveCategory,
//                 child: categoryViewModel.isLoading.value
//                     ? const SizedBox(
//                   width: 22,
//                   height: 22,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     color: Colors.white,
//                   ),
//                 )
//                     : const Text(
//                   'Continue',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
