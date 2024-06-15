import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/controller/home_controller.dart';
import 'package:shopping/pages/add_product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Master Admin"),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.shopping_bag)),
            ],
          ),
          body: ListView.builder(
            itemCount: ctrl.product.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  title: Text((ctrl.product[index].name ?? '')),
                  subtitle: Text((ctrl.product[index].price ?? '').toString()),
                  //Delete btn of HomePage
                  trailing: IconButton(
                    onPressed: () {
                      ctrl.deleteProduct(ctrl.product[index].id ?? '');
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(const AddProductPage());
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
