import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> fetchReciters() async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();
      final savedReciters = prefs.getString('recitersList');

      if (savedReciters != null) {
        List jsonResponse = json.decode(savedReciters);
        recitersList.value =
            jsonResponse.map((reciter) => Reciter.fromJson(reciter)).toList();
        _sortRecitersList();
        filteredRecitersList.value = recitersList;
        isLoading(false);
        return;
      }

      final response =
          await http.get(Uri.parse('https://mp3quran.net/api/v3/reciters'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['reciters'];
        recitersList.value =
            jsonResponse.map((reciter) => Reciter.fromJson(reciter)).toList();
        _sortRecitersList();
        filteredRecitersList.value = recitersList;

        await prefs.setString('recitersList', json.encode(jsonResponse));
      } else {
        Get.snackbar("Error", "Failed to load reciters");
      }
    } finally {
      isLoading(false);
    }
  }

  void _sortRecitersList() {
    recitersList.sort((a, b) => a.letter!.compareTo(b.letter!));
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
