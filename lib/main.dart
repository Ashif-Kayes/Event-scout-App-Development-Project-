import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this dependency in pubspec.yaml

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignUp Demo',
      home: const SignUpPage(),
    );
  }
}

// ================= SignUp Page =================
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedGender;
  DateTime? _dob;
  bool _agreed = false;

  final Map<String, String> validUsers = {
    'john@example.com': 'password123',
    'jane@flutter.dev': 'flutter456',
    'sam@test.com': 'mypassword',
  };

  Future<void> _selectDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (!validUsers.containsKey(email) || validUsers[email] != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(
            fullName: _nameController.text.trim(),
            email: email,
            gender: _selectedGender!,
            dob: _dob!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) => (value == null || value.length < 3)
                    ? 'Name must be at least 3 characters'
                    : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                (value == null || !value.contains('@') || !value.contains('.'))
                    ? 'Enter a valid email'
                    : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                (value == null || value.length < 6) ? 'Minimum 6 characters' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: "Gender"),
                items: ['Male', 'Female', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
                validator: (val) => val == null ? 'Select gender' : null,
              ),
              ListTile(
                title: Text(_dob == null
                    ? 'Select Date of Birth'
                    : '${_dob!.day}-${_dob!.month}-${_dob!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDOB(context),
              ),
              CheckboxListTile(
                title: const Text("I agree to Terms & Conditions"),
                value: _agreed,
                onChanged: (val) => setState(() => _agreed = val ?? false),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_dob == null || !_agreed) {
                    setState(() {});
                    return;
                  }
                  _submitForm();
                },
                child: const Text("Submit"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AboutUsPage()));
                },
                child: const Text("About Us"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= Welcome Page =================
class WelcomePage extends StatelessWidget {
  final String fullName, email, gender;
  final DateTime dob;

  const WelcomePage({
    super.key,
    required this.fullName,
    required this.email,
    required this.gender,
    required this.dob,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Welcome, $fullName!",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildRow("Email", email),
                _buildRow("Gender", gender),
                _buildRow("DOB", "${dob.day}-${dob.month}-${dob.year}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

// ================= About Us Page =================
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  final List<Map<String, String>> team = const [
    {
      "name": "Tabassum Kabir",
      "roll": "CSE2001",
      "email": "alice@example.com",
      "image": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Ashif Kayes",
      "roll": "CSE2002",
      "email": "bob@example.com",
      "image": "https://i.pravatar.cc/150?img=2",
    },
    {
      "name": "Swapon Barman",
      "roll": "CSE2003",
      "email": "charlie@example.com",
      "image": "https://i.pravatar.cc/150?img=3",
    },
    {
      "name": "Akash Biswas",
      "roll": "CSE2003",
      "email": "charlie@example.com",
      "image": "https://i.pravatar.cc/150?img=3",
    },
  ];

  void _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Text("My Awesome App",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          ...team.map((member) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(member["image"]!),
                  radius: 30,
                ),
                title: Text(member["name"]!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Roll: ${member["roll"]}"),
                    GestureDetector(
                      onTap: () => _launchEmail(member["email"]!),
                      child: Text(
                        member["email"]!,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
