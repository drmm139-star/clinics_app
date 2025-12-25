import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../config/app_config.dart';

final Logger logger = Logger();

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController medicalHistoryController =
      TextEditingController();

  String? selectedGender;
  final List<String> genderOptions = ['ذكر', 'أنثى'];

  String? phoneErrorText;

  bool isValidEgyptianPhone(String phone) {
    return phone.length == 11 &&
        (phone.startsWith('010') ||
            phone.startsWith('011') ||
            phone.startsWith('012') ||
            phone.startsWith('015'));
  }

  /// ✅ النسخة النهائية
  Future<void> submitPatient() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "name": nameController.text.trim(),
      "age": ageController.text.trim(),
      "gender": selectedGender ?? "",
      "phone": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "address": addressController.text.trim(),
      "medical_history": medicalHistoryController.text.trim(),
    };

    logger.i('Submitting patient data');
    logger.d(data);

    try {
      final request = http.Request('POST', Uri.parse(AppConfig.apiUrl))
        ..headers.addAll({"Content-Type": "application/json"})
        ..body = jsonEncode(data);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      logger.i('Server response: ${response.statusCode}');
      logger.d(response.body);

      if (response.statusCode != 200 && response.statusCode != 302) {
        throw "Server error ${response.statusCode}";
      }

      if (response.body.trim().startsWith('<')) {
        _onSuccess();
        return;
      }

      final result = jsonDecode(response.body);
      if (result is Map && result["status"] == "success") {
        _onSuccess();
      } else {
        throw result["message"] ?? "استجابة غير متوقعة";
      }
    } catch (e, s) {
      logger.e('Submit error', error: e, stackTrace: s);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
      }
    }
  }

  void _onSuccess() {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم إضافة المريض بنجاح")));

    _formKey.currentState!.reset();
    selectedGender = null;

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة بيانات مريض جديد"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "اسم المريض",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "أدخل اسم المريض" : null,
                ),
                const SizedBox(height: 16),

                /// 🔢 السن
                Tooltip(
                  message: "السن رقمين فقط",
                  child: TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: "السن",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    validator: (v) => v!.isEmpty ? "أدخل السن" : null,
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: "النوع",
                    border: OutlineInputBorder(),
                  ),
                  items: genderOptions
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedGender = v),
                  validator: (v) => v == null ? "اختر النوع" : null,
                ),
                const SizedBox(height: 16),

                /// 📞 رقم الهاتف
                Tooltip(
                  message:
                      "رقم مصري يبدأ بـ 010 / 011 / 012 / 015 ويتكون من 11 رقم",
                  child: TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "رقم الهاتف",
                      border: const OutlineInputBorder(),
                      errorText: phoneErrorText,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          phoneErrorText = "أدخل رقم الهاتف";
                        } else if (!isValidEgyptianPhone(value)) {
                          phoneErrorText =
                              "رقم غير صحيح (010 / 011 / 012 / 015)";
                        } else {
                          phoneErrorText = null;
                        }
                      });
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "أدخل رقم الهاتف";
                      }
                      if (!isValidEgyptianPhone(v)) {
                        return "رقم هاتف مصري غير صحيح";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "البريد الإلكتروني",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return "أدخل البريد الإلكتروني";
                    if (!v.contains('@')) return "بريد غير صحيح";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "العنوان",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "أدخل العنوان" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: medicalHistoryController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "السجل الطبي (اختياري)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: submitPatient,
                  child: const Text("حفظ البيانات"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
