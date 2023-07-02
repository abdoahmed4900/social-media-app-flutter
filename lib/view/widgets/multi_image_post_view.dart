import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MultiImagePostView extends StatefulWidget {
  const MultiImagePostView({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List images;

  @override
  State<MultiImagePostView> createState() => _MultiImagePostViewState();
}

class _MultiImagePostViewState extends State<MultiImagePostView> {
  late final PageController controller;

  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
    controller = PageController(initialPage: index, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
                controller.animateToPage(value,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linearToEaseOut);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(
                              widget.images[index],
                            ))),
                  ),
                );
              },
              physics: const PageScrollPhysics(),
              itemCount: widget.images.length,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 47,
          ),
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: index,
              onDotClicked: (val) {
                controller.jumpToPage(val);
              },
              count: widget.images.length,
              effect: WormEffect(
                  dotWidth: MediaQuery.sizeOf(context).width / 60,
                  dotHeight: MediaQuery.sizeOf(context).height / 117,
                  paintStyle: PaintingStyle.stroke,
                  strokeWidth: 1.5,
                  activeDotColor: Colors.indigo),
            ),
          )
        ],
      ),
    );
  }
}
