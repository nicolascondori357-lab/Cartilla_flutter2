import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';
import '../../data/services/api_service.dart';
import 'detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  late Future<List<Post>> _postsFuture;

  String busqueda = '';

  @override
  void initState() {
    super.initState();
    _postsFuture = _apiService.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar noticia',
                hintText: 'Escribí un título...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() {
                  busqueda = valor.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {

                // ESTADO 1: Cargando
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando posts...'),
                      ],
                    ),
                  );
                }

                // ESTADO 2: Error
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Error al cargar los datos',
                        ),
                        const SizedBox(height: 8),
                        Text('${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _postsFuture =
                                  _apiService.getPosts();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                // ESTADO 3: Datos recibidos
                final List<Post> posts = snapshot.data!;

                final List<Post> postsFiltrados =
                    posts.where((post) {
                  return post.titulo
                      .toLowerCase()
                      .contains(busqueda);
                }).toList();

                if (postsFiltrados.isEmpty) {
                  return const Center(
                    child: Text(
                      'No se encontraron noticias',
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: postsFiltrados.length,
                  itemBuilder: (context, index) {
                    final post = postsFiltrados[index];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${post.id}'),
                      ),
                      title: Text(post.titulo),
                      subtitle: Text(
                        post.cuerpo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetalleScreen(post: post),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}