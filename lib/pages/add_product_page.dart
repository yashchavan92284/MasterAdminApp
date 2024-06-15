import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/controller/home_controller.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Product Master Screen"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Show selected image preview or placeholder
                ctrl.selectedImage != null
                    ? SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.file(
                          ctrl.selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Text('No image selected'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ctrl.pickAndUploadImage();
                  },
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: ctrl.productNameCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Product Name',
                    hintText: 'Enter Your Product Name',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ctrl.productDescriptionCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Product Description',
                    hintText: 'Enter Your Product Description',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ctrl.productPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Product Price',
                    hintText: 'Enter Your Product Price',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ctrl.addProduct();
                  },
                  child: Obx(() {
                    return ctrl.isAdding.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Add Product');
                  }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }
}
