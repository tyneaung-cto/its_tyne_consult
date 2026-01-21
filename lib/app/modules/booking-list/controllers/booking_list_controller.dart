import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:its_tyne_consult/app/data/models/consultation_model.dart';
import '../../../core/services/firestore_service.dart';

class BookingListController extends GetxController {
  final isLoading = true.obs;
  final consultations = <Consultation>[].obs;

  StreamSubscription<List<Consultation>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _listenUserBookings();
  }

  void _listenUserBookings() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    _subscription = FirestoreService.instance
        .streamUserConsultations(user.uid)
        .listen(
      (data) {
        consultations.assignAll(data);
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        debugPrint('❌ BookingList stream error: $error');
      },
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
