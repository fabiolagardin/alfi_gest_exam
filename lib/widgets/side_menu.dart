import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Socie'),
            onTap: () {
              Navigator.pushNamed(context, '/socie');
            },
          ),
          ListTile(
            leading: const Icon(Icons.circle),
            title: const Text('Circoli'),
            onTap: () {
              Navigator.pushNamed(context, '/circoli');
            },
          ),
        ],
      ),
    );
  }
}
