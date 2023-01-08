import 'package:flutter/material.dart';
import 'package:draggable_resizer/draggable_resizer.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double volume = 1.0;

  String ratingImg = "assets/rating/emoji3.png";
  double ratingVal = 25.0;

  double speakerVal = 20.0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF222222),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, //MainAxisAlignment.spaceBetween,
              children: [
                // ///EXAMPLE 1: VOLUME BOOSTER
                _heading("Example 1"),
                _description(
                    "Vertically Drag the volume dialar\nDrag up to increase the volume and down to decrease."),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: CircularProgressIndicator(
                        value: volume / 100,
                        strokeWidth: 10,
                        valueColor: const AlwaysStoppedAnimation(
                            Color.fromARGB(210, 172, 161, 4)),
                      ),
                    ),
                    DraggableResizer(
                      axis: Axis.vertical,
                      widgetWhenDragging: _musicDialar(),
                      draggableWidget: _musicDialar(),
                      onValueChange: ((vol) {
                        setState(() {
                          volume = vol;
                          debugPrint("Size changed to: $vol");
                        });
                      }),
                    ),
                  ],
                ),
                _divider(),
                const SizedBox(height: 20),

                ///EXAMPLE 2: FACE RATING
                _heading("Example 2"),
                _description(
                    "Horizont Drag the rating emojie\nDrag left and right to rate."),
                const SizedBox(height: 10),
                DraggableResizer(
                  shouldDraggableWidgetRotate: false,
                  shouldDraggingWidgetRotate: false,
                  showFeedback: false,
                  axis: Axis.horizontal,
                  direction: Direction.leftToRight,
                  widgetWhenDragging: _emoji(),
                  draggableWidget: _emoji(),
                  onValueChange: ((rating) {
                    setState(() {
                      if (rating >= 0 && rating < 20) {
                        ratingImg = "assets/rating/emoji1.png";
                      }
                      if (rating >= 20 && rating < 40) {
                        ratingImg = "assets/rating/emoji2.png";
                      }
                      if (rating >= 40 && rating < 60) {
                        ratingImg = "assets/rating/emoji3.png";
                      }
                      if (rating >= 60 && rating < 80) {
                        ratingImg = "assets/rating/emoji4.png";
                      }
                      if (rating >= 80 && rating < 100) {
                        ratingImg = "assets/rating/emoji5.png";
                      }
                      setState(() => ratingVal = rating);
                      debugPrint("Rating changed to: $rating");
                    });
                  }),
                ),
                _heading("${(ratingVal / 20).ceilToDouble()} / 5.0"),
                _divider(),
                const SizedBox(height: 20),

                ///EXAMPLE 3: BASIC
                _heading("Example 3"),
                _description(
                    "Horizont Drag me\n to Increase or decrease my size"),
                const SizedBox(height: 10),
                Container(
                    height: 130,
                    width: 130,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.amber, shape: BoxShape.circle),
                    child: DraggableResizer(
                      onValueChange: ((val) => setState(() {
                            speakerVal = val;
                          })),
                      axis: Axis.horizontal,
                      showFeedback: true,
                      shouldDraggingWidgetRotate: false,
                      shouldDraggableWidgetRotate: false,
                      widgetWhenDragging: _speaker(),
                      draggableWidget: _speaker(),
                    )),
                _divider(),
              ],
            )),
          ),
        ),
      ),
    );
  }

  _heading(String heading) => Text(heading,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color.fromARGB(255, 166, 162, 162)));
  _description(String heading) => Text(heading,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Color.fromARGB(255, 145, 142, 142)));
  _divider() => Container(
      margin: const EdgeInsets.all(16.0), height: 0.2, color: Colors.grey);
  _musicDialar() => Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: const Color.fromARGB(233, 185, 195, 9), width: 5)),
      child: Image.asset("assets/audio_speakers.png"));
  _emoji() => Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ratingImg), fit: BoxFit.fitHeight),
            shape: BoxShape.circle),
      );
  _speaker() => Container(
        height: speakerVal + 60,
        width: speakerVal + 60,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/nozzle.png")),
            shape: BoxShape.circle),
      );
}
