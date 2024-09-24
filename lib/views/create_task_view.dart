import 'package:fam_works/constants/app_colors.dart';
import 'package:fam_works/feature/utils/app_box.dart';
import 'package:fam_works/viewmodels/task_vmodel.dart';
import 'package:flutter/material.dart';

class CreateTaskView extends StatefulWidget {
  @override
  _CreateTaskViewState createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends TaskViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Başlık'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen başlık giriniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Açıklama'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen açıklama giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ['Temizlik', 'Bahçe', 'Yemek', 'Özel']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 20),
                image == null
                    ? const Text('Fotoğraf seçilmedi')
                    : Image.file(image!, height: 100),
                ElevatedButton(
                  onPressed: getImage,
                  child: const Text('Fotoğraf Yükle'),
                ),
                const AppHeightBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      createTask(
                        titleController.text,
                        descriptionController.text,
                        selectedCategory,
                      );
                    }
                  },
                  child: Text(createTaskString),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
