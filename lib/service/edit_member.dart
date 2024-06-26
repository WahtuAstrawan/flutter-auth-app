import 'package:flutter/material.dart';
import "package:auth_app/components/show_alert_dialog.dart";
import "package:dio/dio.dart";
import "package:get_storage/get_storage.dart";

bool isValidDate(String dateString) {
  RegExp datePattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
  if (!datePattern.hasMatch(dateString)) {
    return false;
  }

  Match match = datePattern.firstMatch(dateString)!;
  int year = int.parse(match.group(1)!);
  int month = int.parse(match.group(2)!);
  int day = int.parse(match.group(3)!);

  if (month >= 1 &&
      month <= 12 &&
      day >= 1 &&
      day <= daysInMonth(year, month)) {
    return true;
  } else {
    return false;
  }
}

int daysInMonth(int year, int month) {
  if (month == 2) {
    if (isLeapYear(year)) {
      return 29;
    } else {
      return 28;
    }
  } else if (month == 4 || month == 6 || month == 9 || month == 11) {
    return 30;
  } else {
    return 31;
  }
}

bool isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
}

Future<void> editMember(
    BuildContext context,
    TextEditingController formRegNum,
    TextEditingController formName,
    TextEditingController formAddress,
    TextEditingController formBirthday,
    TextEditingController formPhoneNum,
    String formStatus,
    int memberId) async {
  final localStorage = GetStorage();
  final dio = Dio();
  const baseUrl = 'https://mobileapis.manpits.xyz/api';

  if (formName.text.isEmpty ||
      formRegNum.text.isEmpty ||
      formAddress.text.isEmpty ||
      formBirthday.text.isEmpty ||
      formPhoneNum.text.isEmpty) {
    showAlertDialog(context, "Error", "Harap mengisi semua kolom data");
    return;
  }

  final onlyNumbers = RegExp(r'^[0-9]+$');
  if (!onlyNumbers.hasMatch(formRegNum.text)) {
    showAlertDialog(
        context, "Error", "Masukkan no induk dengan benar (Hanya angka)");
    formRegNum.clear();
    return;
  }

  if (!isValidDate(formBirthday.text)) {
    showAlertDialog(context, "Error",
        "Masukkan format tanggal lahir dengan benar (YYYY-MM-DD)");
    formBirthday.clear();
    return;
  }

  if (!onlyNumbers.hasMatch(formPhoneNum.text)) {
    showAlertDialog(
        context, "Error", "Masukkan nomor telepon dengan benar (Hanya angka)");
    formPhoneNum.clear();
    return;
  }

  try {
    final response = await dio.put('$baseUrl/anggota/$memberId',
        data: {
          'nomor_induk': formRegNum.text,
          'nama': formName.text,
          'alamat': formAddress.text,
          'tgl_lahir': formBirthday.text,
          'telepon': formPhoneNum.text,
          'status_aktif': formStatus
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${localStorage.read('token')}'},
        ));

    if (!response.data['success']) {
      showAlertDialog(context, "Error",
          "Terjadi kesalahan saat mengedit anggota, coba ulang");
      return;
    }

    showAlertDialog(context, "Success", "Anggota berhasil diedit");

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/dashboard');
    return;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode! < 500) {
      if (e.response!.statusCode! == 406) {
        showAlertDialog(
            context, "Error", "Sesi login Anda telah habis, coba login ulang");
        localStorage.erase();
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      showAlertDialog(
          context, "Error", "No induk yang Anda edit sudah dipakai");
    } else {
      showAlertDialog(context, "Error", "Internal Server Error");
    }
    return;
  }
}
