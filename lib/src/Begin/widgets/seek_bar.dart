import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../begin.dart';
import '../utilities/provider/provider.dart';

class SeekBar extends StatefulWidget {
  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  Duration currentPosition = Duration.zero;
  int seekValue = 0;
  var globalTiming;


  @override
  void initState() {
    super.initState();
    streamOfPosition();
  }

  streamOfPosition() {
    AudioService.positionStream.listen(
      (Duration position) {
        currentPosition = position;
        if (globalTiming != null) {
          if (usingSeek == false) {
            globalTiming.incrementTime(currentPosition.inSeconds * 1.0);
          }
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Consumer<Seek>(builder: (context, timing, child) {
            globalTiming = timing;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: orientedCar
                          ? deviceHeight / 2 / 25
                          : deviceWidth / 30),
                  child: Text(
                    !usingSeek
                        ? currentPosition
                            .toString()
                            .replaceRange(0, 2, "")
                            .replaceRange(
                                currentPosition
                                    .toString()
                                    .replaceRange(0, 2, "")
                                    .indexOf("."),
                                currentPosition
                                    .toString()
                                    .replaceRange(0, 2, "")
                                    .length,
                                "")
                        : (Duration(seconds: seekValue))
                            .toString()
                            .replaceRange(0, 2, "")
                            .replaceRange(
                                currentPosition
                                    .toString()
                                    .replaceRange(0, 2, "")
                                    .indexOf("."),
                                currentPosition
                                    .toString()
                                    .replaceRange(0, 2, "")
                                    .length,
                                ""),
                    style: TextStyle(
                        fontSize: deviceWidth / 35,
                        fontFamily: "FuturaR",
                        shadows: [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 2.0,
                            color: Colors.black38,
                          ),
                        ],
                        color: musicBox.get("dynamicArtDB") ?? true
                            ? nowContrast
                            : Colors.white),
                  ),
                ),
                Container(
                  width:
                      orientedCar ? deviceHeight / 2 / 1.5 : deviceWidth / 1.5,
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 2.35),
                      thumbColor: Colors.transparent,
                      inactiveTrackColor: musicBox.get("dynamicArtDB") ?? true
                          ? nowContrast.withOpacity(0.1)
                          : Colors.white10,
                    ),
                    child: Slider(
                        activeColor: musicBox.get("dynamicArtDB") ?? true
                            ? nowContrast
                            : Colors.white,
                        min: 00.0,
                        max: nowMediaItem.duration.inMilliseconds / 1000,
        
                        value: timing.time,
                        onChanged: (var valo) async {
                          usingSeek = true;
                          seekValue = double.parse('$valo').toInt();
                          timing.seekIncrementTime(valo);
                        },
                        onChangeEnd: (var valuo) {
                          int seeker = double.parse('$valuo').toInt();
                   
                          AudioService.seekTo(Duration(seconds: seeker));
                          usingSeek = false;
                        }),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      right: orientedCar
                          ? deviceHeight / 2 / 25
                          : deviceWidth / 30),
                  child: Text(
                    nowMediaItem.duration.inMilliseconds == null
                        ? Duration(
                                milliseconds:
                                    nowMediaItem.duration.inMilliseconds)
                            .toString()
                        : Duration(
                                milliseconds:
                                    nowMediaItem.duration.inMilliseconds)
                            .toString()
                            .replaceRange(0, 2, "")
                            .replaceRange(
                              5,
                              Duration(
                                      milliseconds:
                                          nowMediaItem.duration.inMilliseconds)
                                  .toString()
                                  .replaceRange(0, 2, "")
                                  .length,
                              "",
                            ),
                    style: TextStyle(
                        fontSize: deviceWidth / 35,
                        fontFamily: "FuturaR",
                        shadows: [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 1.5,
                            color: Colors.black38,
                          ),
                        ],
                        color: musicBox.get("dynamicArtDB") ?? true
                            ? nowContrast
                            : Colors.white),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
