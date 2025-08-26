import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/login_config.dart';

final loginConfigProvider = Provider<LoginConfig>((ref) {
  throw UnimplementedError(
    'loginConfigProvider must be overridden in each app',
  );
});
