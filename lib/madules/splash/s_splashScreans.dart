import 'package:flutter/material.dart';
import 'th_splashScrean.dart';

import '../../shared/componente.dart';
import '../Register/who.dart';
import 'f_splashScrean.dart';

class s_splashScrean extends StatelessWidget {
  const s_splashScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/didadesign22.png'),
                  fit: BoxFit.cover,
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => whoscrean()));
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                        color: defultColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 80,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '',
                  style: TextStyle(
                      fontSize: 25,
                      color: defultColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 100),
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    ' '
                    '',
                    overflow: TextOverflow
                        .ellipsis, // استخدم النقاط المعلقة في حالة التجاوز
                    maxLines: 2,
                    style: TextStyle(fontSize: 20, color: defultColor),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const th_splashScrean()));
              },
              backgroundColor: defultColor,
              child: const Icon(Icons.arrow_forward),
            ),
          ),
          Positioned(
            left: 70,
            bottom: 30,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FSplashScrean()));
              },
              child: Container(
                width: 35,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: const Color.fromRGBO(175, 196, 240, 1.0),
                ),
              ),
            ),
          ),
          Positioned(
            left: 120,
            bottom: 30,
            child: Container(
              width: 35,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: defultColor,
              ),
            ),
          ),
          Positioned(
            left: 170,
            bottom: 30,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const th_splashScrean()));
              },
              child: Container(
                width: 35,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: const Color.fromRGBO(175, 196, 240, 1.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
