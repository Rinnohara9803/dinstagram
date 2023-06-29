import 'package:flutter/material.dart';

class CustomPopUpMenuButton extends StatelessWidget {
  const CustomPopUpMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shadowColor: Colors.black,
      icon: const Icon(
        Icons.arrow_drop_down_outlined,
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            height: 0,
            padding: EdgeInsets.zero,
            value: 'Option-1',
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              height: 48,
              color: const Color.fromARGB(255, 38, 37, 37),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.people_alt_outlined,
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem<String>(
            height: 0,
            padding: EdgeInsets.zero,
            value: 'Option-2',
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              height: 48,
              color: const Color.fromARGB(255, 38, 37, 37),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Favourites',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.star_outline,
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      onSelected: (String value) {
        // implement drop down select
      },
    );
  }
}
