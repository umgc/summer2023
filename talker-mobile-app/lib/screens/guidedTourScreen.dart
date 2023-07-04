import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GuidedTourScreen extends StatefulWidget {
  const GuidedTourScreen({Key? key}) : super(key: key);

  @override
  State<GuidedTourScreen> createState() => _GuidedTourScreenState();
}

class _GuidedTourScreenState extends State<GuidedTourScreen> {
  final CarouselController _controller = CarouselController();

  static const List<String> guidedTourImages = [
    'assets/GuidedTour_1.jpeg',
    'assets/GuidedTour_2.jpeg',
    'assets/GuidedTour_3.jpeg',
    'assets/GuidedTour_4.jpeg'
  ];

  int activeIndex = 0;

  void onDotClicked(int index) {
    _controller.animateToPage(index);
  }

  List<Widget> buildImages() => guidedTourImages
      .map((image) => SizedBox(
            width: double.infinity,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage(image),
            ),
          ))
      .toList();

  Widget buildIndicator() => Container(
        margin: const EdgeInsets.only(top: 10),
        child: AnimatedSmoothIndicator(
            onDotClicked: onDotClicked,
            activeIndex: activeIndex,
            count: guidedTourImages.length,
            effect: const WormEffect(
              spacing: 20,
              dotHeight: 25,
              dotWidth: 25,
              activeDotColor: const Color(0xFFCA595D),
            )),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                items: buildImages(),
                carouselController: _controller,
                options: CarouselOptions(
                    viewportFraction: 1,
                    height: double.infinity,
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index)),
              ),
            ),
            buildIndicator(),
          ],
        ),
      ),
    );
  }
}
