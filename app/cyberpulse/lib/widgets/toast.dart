

import 'package:flutter/material.dart';

Widget showSuccessToast(String message) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, color: Colors.white),
        const SizedBox(width: 12.0),
        Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
  return toast;
}

Widget showErrorToast(String message) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.redAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 12.0),
        Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
  return toast;
}

