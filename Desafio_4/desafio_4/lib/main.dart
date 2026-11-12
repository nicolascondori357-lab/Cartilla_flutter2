import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksState {
  final List<String> tareas;
  final List<bool> completadas;

  const TasksState({
    this.tareas = const [],
    this.completadas = const [],
  });

  int get pendientes =>
      tareas.length - completadas.where((c) => c).length;
}

class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState());

  void agregar(String titulo) {
    if (titulo.trim().isEmpty) return;

    state = TasksState(
      tareas: [...state.tareas, titulo.trim()],
      completadas: [...state.completadas, false],
    );
  }

  void eliminar(int indice) {
    if (indice < 0 || indice >= state.tareas.length) return;

    final nuevasTareas = [...state.tareas];
    final nuevasCompletadas = [...state.completadas];

    nuevasTareas.removeAt(indice);
    nuevasCompletadas.removeAt(indice);

    state = TasksState(
      tareas: nuevasTareas,
      completadas: nuevasCompletadas,
    );
  }

  void toggleCompletada(int indice) {
    if (indice < 0 || indice >= state.completadas.length) return;

    final nuevasCompletadas = [...state.completadas];
    nuevasCompletadas[indice] = !nuevasCompletadas[indice];

    state = TasksState(
      tareas: state.tareas,
      completadas: nuevasCompletadas,
    );
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de tareas',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int seccion = 0;

  final List<Widget> pantallas = const [
    InicioScreen(),
    TareasScreen(),
    PerfilScreen(),
  ];

  void cambiarSeccion(int indice) {
    setState(() {
      seccion = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi organizador de tareas'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              accountName: Text('Usuario'),
              accountEmail: Text('Mi cuenta personal'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.teal,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                cambiarSeccion(0);
              },
            ),

            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis tareas'),
              onTap: () {
                Navigator.pop(context);
                cambiarSeccion(1);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                cambiarSeccion(2);
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);

                showAboutDialog(
                  context: context,
                  applicationName: 'Mi organizador de tareas',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'Aplicación realizada con Flutter.',
                );
              },
            ),
          ],
        ),
      ),

      body: IndexedStack(
        index: seccion,
        children: pantallas,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: seccion,
        onDestinationSelected: cambiarSeccion,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(tasksProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 90,
              color: Colors.teal,
            ),

            const SizedBox(height: 20),

            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Organizá tus actividades y mantené tus tareas al día.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Icon(
                      Icons.pending_actions,
                      size: 40,
                      color: Colors.teal,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Tareas pendientes',
                      style: TextStyle(fontSize: 18),
                    ),

                    Text(
                      '${state.pendientes}',
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController controlador = TextEditingController();

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  void agregarTarea() {
    ref.read(tasksProvider.notifier).agregar(controlador.text);
    controlador.clear();
  }

  @override
  Widget build(BuildContext context) {
 
    final state = ref.watch(tasksProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Mis tareas',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controlador,
                  decoration: const InputDecoration(
                    labelText: 'Escribí una tarea',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  onSubmitted: (_) => agregarTarea(),
                ),
              ),

              const SizedBox(width: 10),

              IconButton(
                onPressed: agregarTarea,
                icon: const Icon(Icons.add_circle),
                color: Colors.teal,
                iconSize: 40,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: state.tareas.isEmpty
                ? const Center(
                    child: Text(
                      'Todavía no hay tareas.\n¡Agregá tu primera tarea!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                : ListView.builder(
                    itemCount: state.tareas.length,
                    itemBuilder: (context, indice) {
                      return Card(
                        child: CheckboxListTile(
                          value: state.completadas[indice],
                          title: Text(
                            state.tareas[indice],
                            style: TextStyle(
                              decoration: state.completadas[indice]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),

                          onChanged: (valor) {
                            ref
                                .read(tasksProvider.notifier)
                                .toggleCompletada(indice);
                          },

                          secondary: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              ref
                                  .read(tasksProvider.notifier)
                                  .eliminar(indice);
                            },
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

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.teal,
            child: Icon(
              Icons.person,
              size: 65,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Usuario',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Mi perfil de tareas',
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Mi organizador de tareas',
                applicationVersion: '1.0.0',
              );
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('Información de la aplicación'),
          ),
        ],
      ),
    );
  }
}