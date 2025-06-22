import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      color: Colors.white,
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text(
                '회원 관리',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // 회원 관리 페이지로 이동하는 코드
              },
            ),
            ListTile(
              title: const Text(
                '설문 관리',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // 설문 관리 페이지로 이동하는 코드
              },
            ),
            ListTile(
              title: const Text(
                '설문 답변 관리',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // 설문 답변 관리 페이지로 이동하는 코드
              },
            ),
            ListTile(
              title: const Text(
                '목표 관리',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // 목표 관리 페이지로 이동하는 코드
              },
            ),
            ListTile(
              title: const Text(
                '피로드 관리',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // 피로드 관리 페이지로 이동하는 코드
              },
            ),
          ],
        ),
      ),
    );
  }
}
