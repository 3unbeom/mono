import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared/shared.dart';

final currentOfferingPackagesProvider =
    FutureProvider.autoDispose<List<Package>>((ref) async {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        return [];
      }

      final packages = offerings.current!.availablePackages;
      Log.i('Current offering has ${packages.length} packages');
      return packages;
    });
