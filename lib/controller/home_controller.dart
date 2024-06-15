
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping/product/product.dart';

class HomeController extends GetxController {
  final TextEditingController productNameCtrl = TextEditingController();
  final TextEditingController productDescriptionCtrl = TextEditingController();
  final TextEditingController productPriceCtrl = TextEditingController();
  File? selectedImage;
  final RxBool isAdding = false.obs;
  final ImagePicker picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference productCollection;
  final FirebaseStorage storage = FirebaseStorage.instance;

  RxList<Product> product = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    productCollection = firestore.collection('products');
    fetchProducts();
  }

  Future<void> pickAndUploadImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update();
    }
  }

  Future<void> addProduct() async {
    if (productNameCtrl.text.isEmpty ||
        productDescriptionCtrl.text.isEmpty ||
        productPriceCtrl.text.isEmpty ||
        selectedImage == null) {
      Get.snackbar('Error', 'Please fill in all fields and select an image');
      return;
    }

    isAdding.value = true;

    try {
      DocumentReference doc = productCollection.doc();

      // Upload image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('product_images/$fileName');
      UploadTask uploadTask = reference.putFile(selectedImage!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      Map<String, dynamic> productData = {
        'id': doc.id,
        'name': productNameCtrl.text,
        'description': productDescriptionCtrl.text,
        'price': double.tryParse(productPriceCtrl.text) ?? 0,
        'imageUrl': downloadUrl, // Save image URL
      };
      await doc.set(productData);

      Get.snackbar('Success', 'Product added successfully');
      resetFields();
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } finally {
      isAdding.value = false;
    }
  }

  void resetFields() {
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productPriceCtrl.clear();
    selectedImage = null;
    update();
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      product.assignAll(retrievedProducts);
      Get.snackbar("Success", "Products fetched successfully",
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar("Error", e.toString(), colorText: Colors.red);
    } finally {
      update();
    }
  }

  deleteProduct(String id) async {
    try {
      await productCollection.doc(id).delete();
      fetchProducts();
    } catch (e) {
      Get.snackbar("Error", e.toString(), colorText: Colors.red);
    }
  }
}
