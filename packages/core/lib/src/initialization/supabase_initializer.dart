import 'package:core/src/initialization/feature_initializer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInitializer extends FeatureInitializer<SupabaseClient> {
  final String url;
  final String anonKey;
  
  SupabaseInitializer({
    required this.url,
    required this.anonKey,
  });
  
  @override
  Future<SupabaseClient> initialize() async {
    final supabase = await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    return supabase.client;
  }
}