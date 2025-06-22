import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text('(닉네임)'),
          SizedBox(width: 10),
          Text(
            '아미타민',
            style:
                TextStyle(fontSize: 25, fontWeight: FontWeight.bold, height: 1),
          ),
          SizedBox(width: 10),
          Text('(성별)'),
          SizedBox(width: 10),
          Text(
            'M',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text('(나이)'),
          SizedBox(width: 10),
          Text(
            '29',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text('(핸드폰번호)'),
          SizedBox(width: 10),
          Text(
            '01051256854',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text('(가입일)'),
          SizedBox(width: 10),
          Text(
            '2024.09.18',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
