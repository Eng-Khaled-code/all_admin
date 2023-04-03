// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'discount/discount_page.dart';
import 'ecommerce_dashboard.dart';
import 'operation_view/ecommerce_operations.dart';
import 'orders/orders_page.dart';
import 'products_page/products_page.dart';

class Ecommerce extends StatelessWidget {
  Ecommerce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentIndex == 2
        ? const EcommerceOperations()
        : currentIndex == 1
            ? const ProductPage()
            : currentIndex == 4
                ? DiscountPage()
                : currentIndex == 0
                    ? EcommerceDashboard()
                    : currentIndex == 3
                        ? OrdersPage()
                        : Container();
  }
}
