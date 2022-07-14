import 'package:environment_manager/environment_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvironmentManager(
      initialId: 'prod',
      builder: (context, envId) {
        return MaterialApp(
          home: HomePage(key: ValueKey(envId)),
        );
      },
      onChanged: print,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Environment Manager')),
      body: Center(
        child: Text(EnvironmentManager.current(context) ?? 'Unknown'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    children: [
                      EnvironmentItem(id: 'stage'),
                      EnvironmentItem(id: 'prod'),
                    ].map((e) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                EnvironmentManager.change(context, e.id);
                              },
                              child: Text(e.description ?? e.id.toUpperCase())),
                        ),
                      );
                    }).toList(),
                  ),
                );
              });
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
