import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FavoriteDeleteDialog extends StatelessWidget {
  const FavoriteDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('removeFavorite'.tr()),
      content: Text('removeConfirmation'.tr()),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('cancel'.tr())),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('remove'.tr())),
      ],
    );
  }

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => const FavoriteDeleteDialog(),
        ) ??
        false;
  }
}
