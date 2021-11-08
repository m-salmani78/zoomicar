import 'package:flutter/material.dart';
import '/screens/add_car/repos/car_change_notifier.dart';
import '/screens/add_car/repos/interface.dart';
import '/screens/add_car/widgets/dots_indicator.dart';
import 'package:provider/provider.dart';

import 'widgets/pages/page_1.dart';
import 'widgets/pages/page_2.dart';
import 'widgets/pages/page_3.dart';
import 'widgets/pages/page_4.dart';
import '/models/car_model.dart';

class AddCarScreen extends StatefulWidget {
  // static const String routeName = '/car_name';
  final List<IAddCarPage> pages = [Page1(), Page2(), const Page3(), Page4()];
  late final Car car;
  late final bool editingMode;
  AddCarScreen({Key? key, Car? car}) : super(key: key) {
    editingMode = (car == null) ? false : true;
    this.car = car ?? Car();
  }
  factory AddCarScreen.editMode({required Car car}) => AddCarScreen(car: car);

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarChangeNotifier(
        pagesCount: widget.pages.length,
        car: widget.car.copyInstance(),
      ),
      builder: (context, child) {
        final carHandler = Provider.of<CarChangeNotifier>(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.editingMode ? 'ویرایش خودرو' : 'افزودن خودرو',
            ),
            // title: Text(widget.editingMode ? 'Edit Car' : 'Add Car'),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: carHandler.pageController,
                children: List.generate(widget.pages.length, (index) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(height: 24),
                      widget.pages[index],
                    ],
                  );
                }),
                onPageChanged: (value) => setState(() {
                  currentPage = value;
                }),
              ),
              Positioned(
                top: 0,
                child: DotsIndicator(
                  count: widget.pages.length,
                  currentPage: currentPage,
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: ElevatedButton(
              child: Text(
                currentPage == widget.pages.length - 1 ? 'تایید' : 'بعدی',
                // currentPage == widget.pages.length - 1 ? 'Confirm' : 'Next',
                style: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  carHandler.nextPage(
                    context,
                    onGoNext: (index) => widget.pages[index].onGoNext(),
                    isEditMode: widget.editingMode,
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }
}
