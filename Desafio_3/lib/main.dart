import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool modoOscuro = false;

  void cambiarTema(bool valor) {
    setState(() {
      modoOscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),

      themeMode: modoOscuro ? ThemeMode.dark : ThemeMode.light,

      home: HomeScreen(
        modoOscuro: modoOscuro,
        cambiarTema: cambiarTema,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) cambiarTema;

  const HomeScreen({
    super.key,
    required this.modoOscuro,
    required this.cambiarTema,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _seccion = 0;

  bool mostrarConfiguracion = false;

  @override
  Widget build(BuildContext context) {

    final cs = Theme.of(context).colorScheme;

    final List<Widget> _pantallas = [
      InicioScreen(),
      TareasScreen(),
      PerfilScreen(),
    ];

    return Scaffold(

      appBar: AppBar(
        title: Text(
          mostrarConfiguracion
              ? 'Configuración'
              : ['Inicio', 'Tareas', 'Perfil'][_seccion],
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(
              decoration: BoxDecoration(
                color: cs.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/300',
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Nicolás Condori',
                    style: TextStyle(
                      color: cs.onPrimary,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    'Estudiante',
                    style: TextStyle(
                      color: cs.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                setState(() {
                  _seccion = 0;
                  mostrarConfiguracion = false;
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(Icons.task),
              title: Text('Mis Tareas'),
              onTap: () {
                setState(() {
                  _seccion = 1;
                  mostrarConfiguracion = false;
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                setState(() {
                  _seccion = 2;
                  mostrarConfiguracion = false;
                });
                Navigator.pop(context);
              },
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                setState(() {
                  mostrarConfiguracion = true;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: mostrarConfiguracion
          ? ConfiguracionScreen(
              modoOscuro: widget.modoOscuro,
              cambiarTema: widget.cambiarTema,
            )
          : _pantallas[_seccion],


      bottomNavigationBar: mostrarConfiguracion
          ? null
          : NavigationBar(
              selectedIndex: _seccion,
              onDestinationSelected: (int indice) {
                setState(() {
                  _seccion = indice;
                });
              },

              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),

                NavigationDestination(
                  icon: Icon(Icons.task_outlined),
                  selectedIcon: Icon(Icons.task_alt),
                  label: 'Tareas',
                ),

                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),


      floatingActionButton:
          !mostrarConfiguracion && _seccion == 1
              ? FloatingActionButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Agregar tarea'),
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                )
              : null,
    );
  }
}


class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Esta es mi aplicación personal.',
                  style: TextStyle(
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          Text(
            'Mis estadísticas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 15),

          Row(
            children: [

              Expanded(
                child: tarjetaEstadistica(
                  context,
                  Icons.task,
                  '5',
                  'Tareas',
                ),
              ),

              SizedBox(width: 8),

              Expanded(
                child: tarjetaEstadistica(
                  context,
                  Icons.check_circle,
                  '3',
                  'Hechas',
                ),
              ),

              SizedBox(width: 8),

              Expanded(
                child: tarjetaEstadistica(
                  context,
                  Icons.pending_actions,
                  '2',
                  'Pendientes',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


Widget tarjetaEstadistica(
  BuildContext context,
  IconData icono,
  String numero,
  String titulo,
) {
  final cs = Theme.of(context).colorScheme;

  return Container(
    padding: EdgeInsets.all(12),

    decoration: BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),

    child: Column(
      children: [
        Icon(
          icono,
          color: cs.primary,
        ),

        SizedBox(height: 8),

        Text(
          numero,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(titulo),
      ],
    ),
  );
}


class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Mis Tareas',
        style: TextStyle(fontSize: 24),
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

          CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/300',
            ),
          ),

          SizedBox(height: 15),

          Text(
            'Nicolás Condori',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text('Estudiante'),
        ],
      ),
    );
  }
}


class ConfiguracionScreen extends StatelessWidget {
  final bool modoOscuro;
  final Function(bool) cambiarTema;

  const ConfiguracionScreen({
    super.key,
    required this.modoOscuro,
    required this.cambiarTema,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        SwitchListTile(
          title: Text('Modo oscuro'),
          subtitle: Text('Cambiar el tema de la aplicación'),
          secondary: Icon(Icons.dark_mode),
          value: modoOscuro,

          onChanged: cambiarTema,
        ),
      ],
    );
  }
}