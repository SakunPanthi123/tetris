// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Tetris(),
  ));
}

class Tetris extends StatefulWidget {
  const Tetris({super.key});

  @override
  State<Tetris> createState() => _TetrisState();
}

class _TetrisState extends State<Tetris> {
  List<int> leftEdge = [
    0,
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    120,
    130,
    140,
    150,
    160,
    170
  ];

  List<int> rightEdge = [
    9,
    19,
    29,
    39,
    49,
    59,
    69,
    79,
    89,
    99,
    109,
    119,
    129,
    139,
    149,
    159,
    169,
    179
  ];
  static List<List<int>> tetrisShapes = [
    [-10, -9, -8, -7], // Shape 1
    [-10, -9, -8, 2], // Shape 2
    [-10, -9, 1, 2], // Shape 3
    [-10, 0, 1, 11], // Shape 4
    [-10, -9, 0, 10], // Shape 5
    [-10, 0, 1, 2], // Shape 6
    [-10, 0, 10, 11], // Shape 7
    [-10, -9, -8, 0], // Shape 8
    [-9, 0, 1, 10], // Shape 9
    [-10, -9, 0, 1], // Shape 10
  ];
  late Timer timer;
  bool isIncoming = true;
  int score = 0;
  List<int> incoming = tetrisShapes[Random().nextInt(tetrisShapes.length)];
  List<int> filled = [];
  List<int> endLine = [170, 171, 172, 173, 174, 175, 176, 177, 178, 179];

  void gameStart() {
    timer = Timer.periodic(Duration(milliseconds: 400), (limer) {
      incoming = incoming.map((e) => e + 10).toList();
      setState(() {});
      for (int i = 0; i < 4; i++) {
        if (endLine.contains(incoming[i]) ||
            filled.contains(incoming[i] + 10)) {
          filled.addAll(incoming);
          score += 10;
          int a = Random().nextInt(tetrisShapes.length);
          int b = Random().nextInt(6);
          incoming = tetrisShapes[a].map((e) => e + b).toList();
        }
      }
    });
  }

  void gameStop() {
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10),
                itemCount: 180,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color:
                            incoming.contains(index) || filled.contains(index)
                                ? Colors.blue
                                : Colors.black,
                      ),
                      // child: Center(
                      //   child: Text(
                      //     index.toString(),
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Score $score',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    bool stopper = false;
                    for (int i = 0; i < 4; i++) {
                      if (leftEdge.contains(incoming[i]) ||
                          filled.contains(incoming[i] - 1)) {
                        stopper = true;
                      }
                    }
                    if (!stopper) {
                      incoming = incoming.map((e) => e - 1).toList();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Icon(Icons.keyboard_arrow_left_outlined),
                  )),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    bool stopper = false;
                    for (int i = 0; i < 4; i++) {
                      if (rightEdge.contains(incoming[i]) ||
                          filled.contains(incoming[i] + 1)) {
                        stopper = true;
                      }
                    }
                    if (!stopper) {
                      incoming = incoming.map((e) => e + 1).toList();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Icon(Icons.keyboard_arrow_right_outlined),
                  )),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              gameStart();
            },
            child: Icon(Icons.play_arrow),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {
              gameStop();
            },
            child: Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
