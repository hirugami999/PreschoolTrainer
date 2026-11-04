import 'package:flutter/material.dart';
import 'math_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фон с математическими символами
          Positioned.fill(
            child: Image.asset(
              'assets/images/math_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Основная композиция
          Align(
            alignment: const Alignment(0, -0.15),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 340,
                ),
                child: SizedBox(
                  height: 360,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Мальчик позади кнопки
                      Positioned(
                        top: 74,
                        child: IgnorePointer(
                          child: Image.asset(
                            'assets/images/boy.png',
                            width: 200,
                            height: 210,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Надпись "Давай считать!"
                      Positioned(
                        top: 15,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Image.asset(
                            'assets/images/title.png',
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Кнопка поверх мальчика
                      Positioned(
                        bottom: 27,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const MathScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF6C83A4),
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: Colors.black38,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(26),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Математика',
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 23,
                                  backgroundColor:
                                  Color(0xFF8299BA),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
