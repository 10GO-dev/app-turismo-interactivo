import 'dart:async';

import 'package:app_final/models/location.dart';
import 'package:collection/collection.dart';
import 'package:app_final/components/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../constants.dart';

const key = 'com.hoc.list';

class MyPlacesScreen extends StatefulWidget {
  const MyPlacesScreen({Key? key}) : super(key: key);
  @override
  State<MyPlacesScreen> createState() => _MyPlacesScreenState();
}

class _MyPlacesScreenState extends State<MyPlacesScreen> {
  final compositeSubscription = CompositeSubscription();

  final controller = StreamController<void>();
  late final StateStream<ViewState> list$ = controller.stream
      .startWith(null)
      .switchMap((_) => context.rxPrefs
          .getStringListStream(key)
          .map((list) => ViewState.success((list ?? []).map((e) => conve).toList()))
          .onErrorReturnWith((e, s) => ViewState.failure(e, s)))
      .debug(identifier: '<<STATE>>', log: debugPrint)
      .publishState(ViewState.loading)
    ..connect().addTo(compositeSubscription);

  @override
  void initState() {
    super.initState();
    final _ = list$; // evaluation lazy property.
  }

  @override
  void dispose() {
    compositeSubscription.dispose();
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: const Text('Mis lugares'),
      ),
      body: StreamBuilder<ViewState>(
        stream: list$,
        initialData: list$.value,
        builder: (context, snapshot) {
          final state = snapshot.requireData;

          final asyncError = state.error;
          if (asyncError != null) {
            final error = asyncError.error;
            debugPrint('Error: $error');
            debugPrint('StackTrace: ${asyncError.stackTrace}');

            return Center(
              child: Text(
                'Error: $error',
                // ignore: deprecated_member_use
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final list = state.items;
          if (list.isEmpty) {
            return Center(
              child: Text(
                'Empty',
                // ignore: deprecated_member_use
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => PlaceListTile(
              press: () => Navigator.of(context).pop(list[index].placeId!),
              pressDelete: () => context.showDialogRemove(list[index].placeId!), // TODO: remove item
              name: list[index].name!, 
            )
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () async {
              await context.rxPrefs.reload();
              controller.add(null);
            },
            tooltip: 'Reload',
            child: const Icon(Icons.refresh),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

extension BuildContextX on BuildContext {
  RxSharedPreferences get rxPrefs => get();

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class ViewState {
  final List<Place> items;
  final bool isLoading;
  final AsyncError? error;

  static const loading = ViewState._([], true, null);

  const ViewState._(this.items, this.isLoading, this.error);

  ViewState.success(List<Place> items) : this._(items, false, null);

  ViewState.failure(Object e, StackTrace s)
      : this._([], false, AsyncError(e, s));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewState &&
          runtimeType == other.runtimeType &&
          const ListEquality<Place>().equals(items, other.items) &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode => items.hashCode ^ isLoading.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'ViewState{items.length: ${items.length}, isLoading: $isLoading, error: $error}';
}





class PlaceListTile extends StatelessWidget {
  const PlaceListTile({
    Key? key,
    required this.name,
    required this.press,
    required this.pressDelete,
  }) : super(key: key);

  final String name;
  final VoidCallback press;
  final VoidCallback pressDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: SvgPicture.asset("assets/icons/location_pin.svg", colorFilter: const ColorFilter.mode(secondaryColor40LightTheme, BlendMode.srcIn) ),
          title: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
           trailing: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: pressDelete,
                ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: secondaryColor5LightTheme,
        ),
      ],
    );
  }
}