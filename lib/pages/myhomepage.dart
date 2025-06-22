import 'package:amine_graph/widgets/nav_drawer.dart';
import 'package:amine_graph/widgets/user_board.dart';
import 'package:amine_graph/widgets/user_info.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.green,
                width: 2.0,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: AppBar(
              title: Container(
                alignment: Alignment.centerLeft,
                child: const Text('아미타민',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: () {
                    // 로그아웃 처리할 코드
                  },
                  child: Container(
                    width: 100.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(55, 78, 79, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: const Center(
                      child: Text('로그아웃',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: Row(
        children: [
          const NavDrawer(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  controller: _horizontalScrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalScrollController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: SizedBox(
                        width: 1700,
                        child: Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: true,
                          controller: _verticalScrollController,
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: const Offset(4.0, 4.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 1.0,
                                        ),
                                      ],
                                    ),
                                    child: const UserInfo(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: 1700,
                                    height: 900,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: const Offset(4.0, 4.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 1.0,
                                        ),
                                      ],
                                    ),
                                    child: const UserBoard(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
