import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A button that shows developer tools in development mode.
class DevToolsButton extends StatelessWidget {
  const DevToolsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _showDevToolsModal(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.developer_mode,
              color: Colors.black54,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _showDevToolsModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => const DevToolsModal(),
    );
  }
}

/// A modal dialog for development tools.
class DevToolsModal extends StatefulWidget {
  const DevToolsModal({super.key});

  @override
  State<DevToolsModal> createState() => _DevToolsModalState();
}

class _DevToolsModalState extends State<DevToolsModal> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _refreshTokenController = TextEditingController();
  String _selectedUserType = 'User';

  @override
  void dispose() {
    _tokenController.dispose();
    _refreshTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Development Tools',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Access Token:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                hintText: 'Enter access token',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Refresh Token:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _refreshTokenController,
              decoration: InputDecoration(
                hintText: 'Enter refresh token',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'User Type:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              title: const Text('User'),
              value: 'User',
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Business Client'),
              value: 'BusinessClient',
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final authService = context.read<AuthService>();
                    final token = _tokenController.text;
                    final refreshToken = _refreshTokenController.text;
                    authService.injectUser(
                      accessToken: token,
                      refreshToken: refreshToken,
                      role: _selectedUserType,
                    );
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
