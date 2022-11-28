import 'package:agile_prototyp/src/bloc/data_accessor_cubit.dart';
import 'package:agile_prototyp/src/bloc/version_controll_cubit.dart';
import 'package:agile_prototyp/src/models/krankheiten.dart';
import 'package:agile_prototyp/src/providers/hive_boxes.dart';
import 'package:agile_prototyp/src/views/screens/overview_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(KrankheitenAdapter());
  HiveBoxes.instance;
  runApp(const Prototyp());
}

class Prototyp extends StatelessWidget {
  const Prototyp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(lazy: false, create: (BuildContext context) => DataAccessorCubit()),
          BlocProvider(lazy: false, create: (BuildContext context) => VersionControllCubit()),
        ],
        child: const MaterialApp(
          title: 'Datenhaltung Prototyp',
          home: Overview(),
        )
    );
  }
}
