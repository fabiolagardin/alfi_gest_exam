import 'package:flutter/material.dart';

class CardSmallDashboard extends StatelessWidget {
  final String title;
  final Map<int, String> data;
  final Map<String, double> height;

  const CardSmallDashboard({
    Key? key,
    required this.title,
    required this.data,
    required this.height,
  }) : super(key: key);

  TextStyle getTextStyle(int index, int qElement, BuildContext context) {
    if (index == 0) {
      return Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            height: qElement > 2 ? 3 : -0.1,
          );
    } else if (index == 1) {
      return Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.error,
            height: 0.1,
          );
    } else {
      return Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 0.1,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                    10.0), // Imposta il raggio per l'angolo in basso a sinistra
                bottomRight: Radius.circular(
                    10.0), // Imposta il raggio per l'angolo in basso a destra
              ),
            ),
            padding: const EdgeInsets.all(0),
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final key = data.keys.elementAt(index);
                  final value = data.values.elementAt(index);
                  final heightOfElement = height.values.elementAt(index);
                  return Container(
                    height: heightOfElement,
                    child: ListTile(
                      title: Text(key.toString(),
                          style: getTextStyle(index, data.length, context)),
                      trailing: Text(
                        value,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              height: 0.1,
                            ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class CardLargeDashboard extends StatelessWidget {
  final String title;
  final Map<int, String> data;
  final Map<String, double> height;

  const CardLargeDashboard({
    Key? key,
    required this.title,
    required this.data,
    required this.height,
  }) : super(key: key);

  TextStyle getTextStyle(int index, int qElement, BuildContext context) {
    if (index == 0) {
      return Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            height: qElement > 2 ? 3 : -0.1,
          );
    } else if (index == 1) {
      return Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.error,
            height: 0.1,
          );
    } else {
      return Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 0.1,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 0.0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            padding: const EdgeInsets.all(0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Text(
                  data.keys.elementAt(0).toString(),
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 66,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                ),
                Text(
                  data.values.elementAt(0),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                    10.0), // Imposta il raggio per l'angolo in basso a sinistra
                bottomRight: Radius.circular(
                    10.0), // Imposta il raggio per l'angolo in basso a destra
              ),
            ),
            padding: const EdgeInsets.all(0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: data.length - 1,
              itemBuilder: (context, index) {
                index++;
                final key = data.keys.elementAt(index);
                final value = data.values.elementAt(index);
                final heightOfElement = height.values.elementAt(index);
                return Container(
                  height: heightOfElement,
                  child: ListTile(
                    title: Text(key.toString(),
                        style: getTextStyle(index, data.length, context)),
                    trailing: Text(
                      value,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            height: 0.1,
                          ),
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
