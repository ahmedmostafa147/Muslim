import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:muslim/Models/api_reciters.dart';

class RecitersController extends GetxController {
  var recitersList = <Reciter>[].obs;
  var filteredRecitersList = <Reciter>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReciters();
  }

  void fetchReciters() async {
    try {
      isLoading(true);
      final response =
          await http.get(Uri.parse('https://mp3quran.net/api/v3/reciters'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['reciters'];
        recitersList.value =
            jsonResponse.map((reciter) => Reciter.fromJson(reciter)).toList();
        filteredRecitersList.value = recitersList;
      } else {
        Get.snackbar("Error", "Failed to load reciters");
      }
    } finally {
      isLoading(false);
    }
  }

  void filterReciters(String query) {
    if (query.isEmpty) {
      filteredRecitersList.value = recitersList;
    } else {
      filteredRecitersList.value = recitersList.where((reciter) {
        return reciter.name!.toLowerCase().contains(query.toLowerCase()) ||
            reciter.letter!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
