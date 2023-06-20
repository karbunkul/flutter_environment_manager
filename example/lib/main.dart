import 'package:environment_manager/environment_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvironmentManager<EnvironmentItem>(
      initialData: EnvironmentItem(id: 'prod'),
      builder: (context, env) {
        return MaterialApp(
          home: HomePage(key: ValueKey(env)),
        );
      },
      onChanged: (val) async {
        await Future.delayed(const Duration(milliseconds: 500));
        print(val.id);
      },
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
        child: Text(
          EnvironmentManager.current<EnvironmentItem>(context)?.id ?? 'Unknown',
        ),
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
                          onPressed: () => _onPressed(context, e),
                          child: Text(e.id.toString()),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.settings),
      ),
    );
  }

  void _onPressed(BuildContext context, EnvironmentItem env) {
    EnvironmentManager.change<EnvironmentItem>(context, env);
  }
}

class EnvironmentItem {
  final String id;
  final String? description;

  EnvironmentItem({required this.id, this.description});

  @override
  int get hashCode {
    return id.length + (description?.length ?? 0);
  }
}
