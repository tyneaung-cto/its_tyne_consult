import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/banned_home_controller.dart';

class BannedHomeView extends GetView<BannedHomeController> {
  const BannedHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BannedHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BannedHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
