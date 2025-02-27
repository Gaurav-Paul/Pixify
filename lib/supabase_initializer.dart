import 'package:supabase_flutter/supabase_flutter.dart';

initializeSupabaseAPI() async {
  await Supabase.initialize(
    url: 'https://lotnhpdgecbemxljmpqk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvdG5ocGRnZWNiZW14bGptcHFrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA2NzMyODcsImV4cCI6MjA1NjI0OTI4N30.PsA988QhvdrdTqRcdnSPKyziVpUO7DmEODKQmaPP1ic',
  );
}
