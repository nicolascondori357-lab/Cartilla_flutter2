import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Text('1'),
            ),
            title: const Text('Primera publicación'),
            subtitle: const Text('Contenido de la primera publicación'),
            onTap: () {
              context.push('/posts/1');
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Text('2'),
            ),
            title: const Text('Segunda publicación'),
            subtitle: const Text('Contenido de la segunda publicación'),
            onTap: () {
              context.push('/posts/2');
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Text('3'),
            ),
            title: const Text('Tercera publicación'),
            subtitle: const Text('Contenido de la tercera publicación'),
            onTap: () {
              context.push('/posts/3');
            },
          ),
        ],
      ),
    );
  }
}