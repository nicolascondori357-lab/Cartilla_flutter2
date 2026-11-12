import 'package:flutter/material.dart';
import '../../domain/entities/tarea.dart';
import '../../data/local/local_database.dart';
import 'configuracion_screen.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TextEditingController _tituloController =
      TextEditingController();

  List<Tarea> tareas = [];

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  // Obtener las tareas de SQLite
  Future<void> _cargarTareas() async {
    final lista = await LocalDatabase.instance.obtenerTodas();

    if (!mounted) return;

    setState(() {
      tareas = lista;
    });
  }

  // Agregar una tarea
  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) return;

    final nuevaTarea = Tarea(
      titulo: titulo,
      descripcion: '',
      completada: false,
      prioridad: 'normal',
      fecha: DateTime.now().toIso8601String(),
    );

    await LocalDatabase.instance.insertar(nuevaTarea);

    _tituloController.clear();

    await _cargarTareas();
  }
  // Marcar una tarea como completada
  Future<void> _cambiarEstado(Tarea tarea, bool? valor) async {
    final tareaActualizada = tarea.copyWith(
      completada: valor ?? false,
    );

    await LocalDatabase.instance.actualizar(tareaActualizada);

    await _cargarTareas();
  }

  // Eliminar una tarea
  Future<void> _eliminarTarea(Tarea tarea) async {
    if (tarea.id == null) return;

    await LocalDatabase.instance.eliminar(tarea.id!);

    await _cargarTareas();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ConfiguracionScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
           
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                hintText: 'Escribí una tarea...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _agregarTarea(),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _agregarTarea,
                icon: const Icon(Icons.add),
                label: const Text('Agregar tarea'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: tareas.isEmpty
                  ? const Center(
                      child: Text('Todavía no hay tareas'),
                    )
                  : ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = tareas[index];

                        return Dismissible(
                          key: ValueKey(tarea.id),

                          direction: DismissDirection.endToStart,

                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                              right: 20,
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),

                          onDismissed: (direction) {
                            _eliminarTarea(tarea);
                          },

                          child: Card(
                            child: ListTile(
                              leading: Checkbox(
                                value: tarea.completada,
                                onChanged: (valor) {
                                  _cambiarEstado(tarea, valor);
                                },
                              ),

                              title: Text(
                                tarea.titulo,
                                style: TextStyle(
                                  decoration: tarea.completada
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),

                              subtitle: Text(
                                tarea.completada
                                    ? 'Completada'
                                    : 'Pendiente',
                              ),

                              trailing: const Icon(
                                Icons.drag_handle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}