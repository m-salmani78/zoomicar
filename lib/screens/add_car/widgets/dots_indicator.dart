import 'dart:math';

import 'package:flutter/material.dart';
import '/screens/add_car/repos/car_change_notifier.dart';
import 'package:provider/provider.dart';

class DotsIndicator extends StatelessWidget {
  final disabledColor = const Color(0xEECCCCCC);
  final int count;
  final int currentPage;
  const DotsIndicator({Key? key, required this.count, this.currentPage = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double _width = min(180, MediaQuery.of(context).size.width * 0.45);
    final handler = Provider.of<CarChangeNotifier>(context);
    return SizedBox(
      // height: 24,
      width: _width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(height: 6, width: _width - 10, color: disabledColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              count,
              (index) => GestureDetector(
                onTap: index >= currentPage
                    ? null
                    : () {
                        handler.previousPage(index);
                      },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: _buildDot(context, index),
                  decoration: BoxDecoration(
                    color: disabledColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer _buildDot(BuildContext context, int index) {
    Color color;
    if (currentPage == index) {
      color = Colors.blue;
    } else if (currentPage < index) {
      color = Colors.transparent;
    } else {
      color = Colors.green;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 23,
      width: 23,
      child: currentPage <= index
          ? Center(
              child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white),
            ))
          : const Icon(
              Icons.check,
              size: 20,
              color: Colors.white,
            ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
