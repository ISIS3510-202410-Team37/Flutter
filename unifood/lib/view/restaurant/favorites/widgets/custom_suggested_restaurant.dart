import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unifood/utils/string_utils.dart';
import 'package:unifood/view/restaurant/detail/views/restaurant_detail.dart';

class CustomSuggestedRestaurant extends StatelessWidget {
  final String id;
  final String restaurantName;
  final String restaurantImage;
  final double? restaurantPrice;
  final String? restaurantFoodType;

  const CustomSuggestedRestaurant({
    Key? key,
    required this.id,
    required this.restaurantName,
    required this.restaurantImage,
    this.restaurantPrice,
    this.restaurantFoodType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RestaurantDetail(restaurantId: id)));
      },
      child: Container(
        color: Colors.transparent,
        width: screenWidth * 0.48,
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: restaurantImage,
                  height: screenHeight * 0.13,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const SizedBox.shrink(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurantName,
                      style: TextStyle(
                        fontSize: screenHeight * 0.015,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      restaurantPrice != null
                          ? formatNumberWithCommas(restaurantPrice!)
                          : restaurantFoodType != null
                              ? restaurantFoodType!
                              : '',
                      style: TextStyle(
                        fontSize: screenHeight * 0.015,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
