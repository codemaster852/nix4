import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Note: In a production environment, you would use supabase_flutter and other packages.
// For this single-file preview, we implement the UI and logic flow using standard Flutter.

void main() {
  runApp(const Nix4App());
}

class Nix4App extends StatefulWidget {
  const Nix4App({super.key});

  @override
  State<Nix4App> createState() => _Nix4AppState();
}

class _Nix4AppState extends State<Nix4App> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nix 4',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // Light Mode: White and Purple
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF6200EE),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          primary: const Color(0xFF6200EE),
          secondary: const Color(0xFFBB86FC),
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      // Dark Mode: Purple and Black
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFBB86FC),
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFBB86FC),
          brightness: Brightness.dark,
          primary: const Color(0xFFBB86FC),
          secondary: const Color(0xFF03DAC6),
          surface: const Color(0xFF121212),
        ),
        useMaterial3: true,
      ),
      home: AuthWrapper(toggleTheme: toggleTheme),
    );
  }
}

// Simple logic to switch between Auth and Main App
class AuthWrapper extends StatefulWidget {
  final VoidCallback toggleTheme;
  const AuthWrapper({super.key, required this.toggleTheme});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isAuthenticated = false;
  bool _showSignUp = false;

  void _login() => setState(() => _isAuthenticated = true);
  void _logout() => setState(() => _isAuthenticated = false);
  void _toggleAuthMode() => setState(() => _showSignUp = !_showSignUp);

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return MainChatPage(onLogout: _logout, toggleTheme: widget.toggleTheme);
    }
    return _showSignUp 
      ? SignUpPage(onSignInTap: _toggleAuthMode, onSignUpSuccess: _login) 
      : SignInPage(onSignUpTap: _toggleAuthMode, onSignInSuccess: _login);
  }
}

// --- SIGN IN PAGE ---
class SignInPage extends StatelessWidget {
  final VoidCallback onSignUpTap;
  final VoidCallback onSignInSuccess;

  const SignInPage({super.key, required this.onSignUpTap, required this.onSignInSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Nix 4", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF6200EE))),
              const Text("by Codenix", style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onSignInSuccess,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Sign In"),
              ),
              const SizedBox(height: 20),
              const Text("Or continue with"),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(Icons.g_mobiledata, Colors.red, "Google"),
                  const SizedBox(width: 20),
                  _socialButton(Icons.code, Colors.black, "GitHub"),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: onSignUpTap,
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color, String label) {
    return InkWell(
      onTap: onSignInSuccess,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}

// --- SIGN UP PAGE ---
class SignUpPage extends StatelessWidget {
  final VoidCallback onSignInTap;
  final VoidCallback onSignUpSuccess;

  const SignUpPage({super.key, required this.onSignInTap, required this.onSignUpSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Create Account", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _inputField("Username", Icons.person_outline),
              const SizedBox(height: 16),
              _inputField("Full Name", Icons.badge_outlined),
              const SizedBox(height: 16),
              _inputField("Email", Icons.email_outlined),
              const SizedBox(height: 16),
              _inputField("Password", Icons.lock_outline, obscure: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onSignUpSuccess,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Sign Up"),
              ),
              TextButton(
                onPressed: onSignInTap,
                child: const Text("Already have an account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, IconData icon, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon),
      ),
    );
  }
}

// --- MAIN CHAT PAGE ---
class MainChatPage extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback toggleTheme;
  const MainChatPage({super.key, required this.onLogout, required this.toggleTheme});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"role": "assistant", "content": "Hello! I am Nix 4. How can I assist you today?"}
  ];
  bool _isLoading = false;

  final String sheetsUrl = "https://docs.google.com/spreadsheets/d/1i9JYpZzxUHeUg9F6i1AP-mx4OiCiaF2YA3KmWVqwDsU/gviz/tq?tqx=out:csv";
  final String longCatApiKey = "ak_2rU1Lo7PA23X5Is9wm3m69EY2T37J";

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userMsg = _controller.text.trim();
    setState(() {
      _messages.add({"role": "user", "content": userMsg});
      _isLoading = true;
    });
    _controller.clear();

    String? answerFound;

    try {
      // 1. Search in Google Sheets first
      final response = await http.get(Uri.parse(sheetsUrl));
      if (response.statusCode == 200) {
        List<String> lines = response.body.split('\n');
        // Assuming Column A is question, Column B is answer
        for (var line in lines) {
          List<String> parts = line.split(',');
          if (parts.length >= 2) {
            String sheetQuestion = parts[0].replaceAll('"', '').trim().toLowerCase();
            String sheetAnswer = parts[1].replaceAll('"', '').trim();
            if (sheetQuestion == userMsg.toLowerCase()) {
              answerFound = sheetAnswer;
              break;
            }
          }
        }
      }

      // 2. If not found in sheets, use AI API (Simulated call)
      if (answerFound == null) {
        // Here you would use longCatApiKey with an actual endpoint
        // For demonstration, we simulate an AI thinking process
        await Future.delayed(const Duration(seconds: 1));
        answerFound = "I couldn't find a specific answer in my records for '$userMsg', but as Nix 4 AI, I'm here to help you explore more!";
      }
    } catch (e) {
      answerFound = "Error connecting to Nix services. Please check your connection.";
    }

    setState(() {
      _messages.add({"role": "assistant", "content": answerFound!});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nix 4", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.brightness_6), onPressed: widget.toggleTheme),
          IconButton(icon: const Icon(Icons.logout), onPressed: widget.onLogout),
        ],
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                bool isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser 
                        ? Theme.of(context).primaryColor 
                        : Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                        bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      msg["content"]!,
                      style: TextStyle(color: isUser ? Colors.white : null),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask Nix 4...",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}