import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://czsmxaroaolgpghdmwtr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN6c214YXJvYW9sZ3BnaGRtd3RyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyMjk1MjksImV4cCI6MjA5NTgwNTUyOX0.m8-Sp0PPMyykAooTh-kmkrhJZsObdh8ITfJ8MYFUtAQ',
  );

  runApp(const ITSSerabutanApp());
}

final supabase = Supabase.instance.client;
