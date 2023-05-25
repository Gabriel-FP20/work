import 'package:flutter/material.dart';
import 'dart:math';
import 'notifications.dart';
import 'pomodoro.dart';
import 'package:confetti/confetti.dart';
import 'shared_data.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _Main();
}

class _Main extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // late Animation<double> _animation;
  double sliderValue = 0.0;
  double waterValue = 0.0;
  double waterValueMax = 0.0;
  double timer = 0;

  bool firstTime = true;
  bool _isActivityTime = SharedData.isActivityTime;
  late ConfettiController _confettiController;
  bool waterButton = true;
  bool hintButton = true;
  bool notificationButton = true;

  bool autoButton = true;
  bool manualButton = false;

  TextEditingController activityTimeController = TextEditingController();
  TextEditingController breakTimeController = TextEditingController();
  int activityTime = 0;
  int breakTime = 0;
  Timer _timer = Timer(Duration.zero, () {});

  List<String> notifications = [];
  String text_notification = "Nada";
  static String text_title = "Nada";

  bool show = false;
  String category = "Nada";

  void removeNotification(String notification) {
    setState(() {
      notifications.remove(notification);
    });
  }

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    timer_Text();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    setState(() {
      _animationController.reset();
      _animationController.forward();
    });
  }

  void stopAnimation() {
    setState(() {
      _animationController.reverse();
    });
  }

  void timer_Text() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _isActivityTime = SharedData.isActivityTime;
      });
    });
  }

  @override
  StatefulWidget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/topo1.png',
                    fit: BoxFit.fill,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: IconButton(
                          icon: const Icon(
                            Icons.settings,
                            size: 40,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Configuraçoes',
                                    style: TextStyle(
                                        fontFamily: 'Baloo',
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Horarios',
                                              style: TextStyle(
                                                  fontFamily: 'Baloo',
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            TextField(
                                              onChanged: (value) => {
                                                setState(() {
                                                  activityTime = int.tryParse(
                                                          activityTimeController
                                                              .text) ??
                                                      0;
                                                })
                                              },
                                              controller:
                                                  activityTimeController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Tempo de Atividade',
                                              ),
                                              style: const TextStyle(
                                                  fontFamily: 'Baloo',
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              onChanged: (value) => {
                                                setState(() {
                                                  breakTime = int.tryParse(
                                                          breakTimeController
                                                              .text) ??
                                                      0;
                                                })
                                              },
                                              controller: breakTimeController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Tempo de Intervalo',
                                              ),
                                              style: const TextStyle(
                                                  fontFamily: 'Baloo',
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            const Text(
                                              'Botao Iniciar',
                                              style: TextStyle(
                                                  fontFamily: 'Baloo',
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (!manualButton) {
                                                          return Colors.grey;
                                                        }
                                                        return Colors.blue;
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      manualButton =
                                                          !manualButton;
                                                      autoButton = !autoButton;
                                                    });
                                                  },
                                                  child: const Text('Manual'),
                                                ),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (!autoButton) {
                                                          return Colors.grey;
                                                        }
                                                        return Colors.blue;
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      manualButton =
                                                          !manualButton;
                                                      autoButton = !autoButton;
                                                    });
                                                  },
                                                  child: const Text('Auto'),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  waterButton = !waterButton;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                          'Controle da Água'),
                                                      Switch(
                                                        value: waterButton,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            waterButton = value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  TextField(
                                                    enabled: waterButton,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText:
                                                          'Quantidade de Água Diária...',
                                                    ),
                                                    onChanged: (value) => {
                                                      setState(() {
                                                        waterValueMax =
                                                            double.parse(value);
                                                      })
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  hintButton = !hintButton;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Receber Dicas'),
                                                  Switch(
                                                    value: hintButton,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        hintButton = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  notificationButton =
                                                      !notificationButton;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('Notificaçoes'),
                                                  Switch(
                                                    value: notificationButton,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        notificationButton =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Salvar'),
                                    ),
                                  ],
                                );
                              },
                            ).then((_) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                          Colors.yellow,
                        ],
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 100,),
                                Text(
                                  _isActivityTime
                                      ? 'Hora da Atividade!'
                                      : 'Hora do Intervalo!',
                                  style: TextStyle(
                                      fontFamily: 'Baloo',
                                      fontSize: 40,
                                      fontWeight: FontWeight.normal),
                                ),
                                ConfettiWidget(
                                  confettiController: _confettiController,
                                  blastDirectionality:
                                      BlastDirectionality.explosive,
                                  shouldLoop: false,
                                  colors: const [
                                    Colors.red,
                                    Colors.green,
                                    Colors.blue,
                                    Colors.yellow,
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 30.0,
                                        activeTrackColor: Colors
                                            .blue, // Define a cor de preenchimento transparente
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 00.0),
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                                overlayRadius: 0.0),
                                      ),
                                      child: Transform.rotate(
                                        angle: 180 * pi / 180,
                                        child: Slider(
                                          value: waterValue,
                                          min: 0,
                                          max: waterValueMax * 1000,
                                          onChanged: (value) {
                                            setState(() {
                                              waterValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 60),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (waterValueMax == 0) {
                                            text_notification =
                                                'Configure sua meta diária de água';
                                            notifications
                                                .add(text_notification);
                                            category = "Água";
                                          }
                                          // if (waterValue == waterValueMax * 1000) {
                                          //   waterValue = 0;
                                          // }
                                        });
                                        if (waterValueMax > 0) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Configuraçoes',
                                                ),
                                                content: StatefulBuilder(
                                                  builder: (BuildContext
                                                          context,
                                                      StateSetter setState) {
                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Ação do botão
                                                                  setState(() {
                                                                    waterValue +=
                                                                        180;
                                                                    if (waterValue >=
                                                                        waterValueMax *
                                                                            1000) {
                                                                      waterValue =
                                                                          waterValueMax *
                                                                              1000;
                                                                    }
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  if ((waterValue >=
                                                                          waterValueMax) &&
                                                                      firstTime) {
                                                                    _confettiController
                                                                        .play();
                                                                    firstTime =
                                                                        false;
                                                                    text_notification =
                                                                        'Meta Atingida';
                                                                    notifications
                                                                        .add(
                                                                            text_notification);
                                                                    category =
                                                                        "Alegria";
                                                                  }
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  padding: const EdgeInsets
                                                                          .all(
                                                                      16.0), // Ajuste o tamanho do botão conforme necessário
                                                                ),
                                                                child: const Text(
                                                                    "180 ml"),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Ação do botão
                                                                  setState(() {
                                                                    waterValue +=
                                                                        300;
                                                                    if (waterValue >=
                                                                        waterValueMax *
                                                                            1000) {
                                                                      waterValue =
                                                                          waterValueMax *
                                                                              1000;
                                                                    }
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  if ((waterValue >=
                                                                          waterValueMax) &&
                                                                      firstTime) {
                                                                    _confettiController
                                                                        .play();
                                                                    firstTime =
                                                                        false;
                                                                    text_notification =
                                                                        'Meta Atingida';
                                                                    notifications
                                                                        .add(
                                                                            text_notification);
                                                                    category =
                                                                        "Alegria";
                                                                  }
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  padding: const EdgeInsets
                                                                          .all(
                                                                      16.0), // Ajuste o tamanho do botão conforme necessário
                                                                ),
                                                                child: const Text(
                                                                    "300 ml"),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Ação do botão
                                                                  setState(() {
                                                                    waterValue +=
                                                                        500;
                                                                    if (waterValue >=
                                                                        waterValueMax *
                                                                            1000) {
                                                                      waterValue =
                                                                          waterValueMax *
                                                                              1000;
                                                                    }
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  if ((waterValue >=
                                                                          waterValueMax *
                                                                              1000) &&
                                                                      firstTime) {
                                                                    _confettiController
                                                                        .play();
                                                                    firstTime =
                                                                        false;
                                                                    text_notification =
                                                                        'Meta Atingida';
                                                                    notifications
                                                                        .add(
                                                                            text_notification);
                                                                    category =
                                                                        "Alegria";
                                                                  }
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      const CircleBorder(),
                                                                  padding: const EdgeInsets
                                                                          .all(
                                                                      16.0), // Ajuste o tamanho do botão conforme necessário
                                                                ),
                                                                child: const Text(
                                                                    "500 ml"),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 30),
                                                          TextField(
                                                            enabled:
                                                                waterButton,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              hintText:
                                                                  'Quantidade de Água Ingerida...',
                                                            ),
                                                            onChanged:
                                                                (value) => {
                                                              setState(() {
                                                                waterValue +=
                                                                    double.parse(
                                                                        value);
                                                                if ((waterValue >=
                                                                    waterValueMax *
                                                                        1000)) {
                                                                  waterValue =
                                                                      waterValueMax *
                                                                          1000;
                                                                }
                                                              })
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {
                                                        waterValue = 0;
                                                        firstTime = true;
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Zerar',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (waterValue >=
                                                              waterValueMax &&
                                                          waterValueMax != 0) {
                                                        _confettiController
                                                            .play();
                                                        firstTime = false;
                                                        text_notification =
                                                            'Meta Atingida';
                                                        notifications.add(
                                                            text_notification);
                                                        category = "Alegria";
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Adicionar',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/gotas.png',
                                            width: 30.0,
                                            height: 30.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ConfettiWidget(
                                  confettiController: _confettiController,
                                  blastDirectionality:
                                      BlastDirectionality.explosive,
                                  shouldLoop: false,
                                  colors: const [
                                    Colors.red,
                                    Colors.green,
                                    Colors.blue,
                                    Colors.yellow,
                                  ],
                                ),
                                SizedBox(
                                    width: 250,
                                    height: 320,
                                    child: KeyedSubtree(
                                      key: ValueKey(
                                          activityTime), // Use uma chave única baseada em activityTime
                                      child: PomodoroTimer(
                                        activityTime: activityTime,
                                        breakTime: breakTime,
                                        auto: autoButton,
                                      ),
                                    )),
                              ],
                            ),
                          ]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: Container(
                height: 200, // Defina a altura máxima desejada
                color: Colors.grey[200],
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Dismissible(
                        key: Key(notification),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          setState(() {
                            notifications.removeAt(index);
                          });
                        },
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd ||
                              direction == DismissDirection.endToStart) {
                            return true;
                          }
                          return false;
                        },
                        child: SizedBox(
                          width: 200,
                          height: 30,
                          child: NotificationBar(
                            text: text_notification,
                            category: category,
                            onDismissed: () => removeNotification(notification),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
