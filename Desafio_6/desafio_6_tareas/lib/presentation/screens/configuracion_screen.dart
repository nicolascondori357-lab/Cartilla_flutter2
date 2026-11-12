import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('preferencias');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),

        builder: (context, box, _) {
          final bool modoOscuro =
              box.get('modoOscuro', defaultValue: false);

          final bool notificaciones =
              box.get('notificaciones', defaultValue: true);

          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Modo oscuro'),
                subtitle: const Text(
                  'Cambiar el tema de la aplicación',
                ),
                secondary: const Icon(Icons.dark_mode),

                value: modoOscuro,

                onChanged: (valor) {
                  box.put('modoOscuro', valor);
                },
              ),

              const Divider(),

              SwitchListTile(
                title: const Text('Notificaciones'),
                subtitle: const Text(
                  'Activar o desactivar las notificaciones',
                ),
                secondary: const Icon(Icons.notifications),

                value: notificaciones,

                onChanged: (valor) {
                  box.put('notificaciones', valor);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}