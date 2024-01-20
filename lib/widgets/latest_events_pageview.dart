import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/model/Events.dart';
import '../simple_widgets.dart';
import '../provider/appointment_provider.dart';

class LatestEvents extends StatefulWidget {
  const LatestEvents({super.key});

  @override
  State<LatestEvents> createState() => _LatestEventsState();
}

class _LatestEventsState extends State<LatestEvents> {
  late int selectedPage;
  late final PageController _pageController;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    List<Events> latestEvents = provider.get4LatestEvents();
    List<Events> getOtherLatestEvents = provider.getOther4LatestEvents();
    final List<List<Events>> pages = [latestEvents,getOtherLatestEvents];
    var screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final cardSize = (width-40)/4;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: latestEvents.isNotEmpty ? cardSize : 10,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, indexOfPage) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: pages[indexOfPage].length,
                itemBuilder: (context, index) {
                  final event = pages[indexOfPage][index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, event);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add spacing between items
                      child: SimpleWidgets().eventCard(event.subject, event.icon!, event.color.withOpacity(0.7)),
                    ),
                  );
                },
              );
            },
            onPageChanged: (int index) {
              setState(() {
                selectedPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        latestEvents.isNotEmpty ? PageViewDotIndicator(
          size: const Size(12, 12),
          unselectedSize: const Size(8, 8),
          count: 2,
          onItemClicked: (int index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            },
          currentItem: selectedPage,
          unselectedColor: Colors.grey,
          selectedColor: colorScheme.primary,
        ) : const Center(),
      ],
    );
  }
}




