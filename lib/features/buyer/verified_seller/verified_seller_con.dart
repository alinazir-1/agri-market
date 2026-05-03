import 'package:get/get.dart';

class VerifiedSellerItem {
  const VerifiedSellerItem({
    required this.id,
    required this.name,
    required this.city,
    required this.specialty,
    required this.responseRate,
    required this.fulfilledOrders,
    required this.rating,
    required this.isTopPerformer,
  });

  final String id;
  final String name;
  final String city;
  final String specialty;
  final String responseRate;
  final int fulfilledOrders;
  final double rating;
  final bool isTopPerformer;
}

class VerifiedSellerCon extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<VerifiedSellerItem> sellers = <VerifiedSellerItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seedVerifiedSellers();
  }

  void _seedVerifiedSellers() {
    sellers.assignAll(const [
      VerifiedSellerItem(
        id: 'vs-1',
        name: 'Al-Madina Grain Traders',
        city: 'Faisalabad',
        specialty: 'Wheat, Maize, and Feed Grains',
        responseRate: '98%',
        fulfilledOrders: 412,
        rating: 4.9,
        isTopPerformer: true,
      ),
      VerifiedSellerItem(
        id: 'vs-2',
        name: 'Punjab Oilseed Collective',
        city: 'Multan',
        specialty: 'Sunflower, Canola, and Mustard',
        responseRate: '96%',
        fulfilledOrders: 297,
        rating: 4.8,
        isTopPerformer: true,
      ),
      VerifiedSellerItem(
        id: 'vs-3',
        name: 'Safa Pulses & Legumes',
        city: 'Sargodha',
        specialty: 'Chickpeas, Lentils, and Beans',
        responseRate: '94%',
        fulfilledOrders: 233,
        rating: 4.7,
        isTopPerformer: false,
      ),
      VerifiedSellerItem(
        id: 'vs-4',
        name: 'Delta Agro Commodities',
        city: 'Hyderabad',
        specialty: 'Rice, Broken Rice, and Bran',
        responseRate: '95%',
        fulfilledOrders: 321,
        rating: 4.8,
        isTopPerformer: true,
      ),
      VerifiedSellerItem(
        id: 'vs-5',
        name: 'Khyber Fresh Inputs',
        city: 'Peshawar',
        specialty: 'Spices, Herbs, and Botanicals',
        responseRate: '92%',
        fulfilledOrders: 188,
        rating: 4.6,
        isTopPerformer: false,
      ),
      VerifiedSellerItem(
        id: 'vs-6',
        name: 'Makran Marine Ingredients',
        city: 'Gwadar',
        specialty: 'Fish Meal and Aquatic Ingredients',
        responseRate: '93%',
        fulfilledOrders: 164,
        rating: 4.7,
        isTopPerformer: false,
      ),
    ]);
  }
}
