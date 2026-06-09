import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kanvas/config/constants.dart';
import 'package:kanvas/config/theme.dart';
import 'package:kanvas/models/profile.dart';
import 'package:kanvas/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  String _currency = 'EUR';
  String _language = 'en';

  Set<String> _selectedMediums = {};
  Set<String> _selectedPeriods = {};

  bool _notifyWeeklyDigest = false;

  bool _initialized = false;
  bool _savingAccount = false;
  bool _savingPrefs = false;
  bool _savingNotifications = false;

  static const _currencies = ['EUR', 'GBP', 'SEK', 'USD'];

  static const _languageLabels = <String, String>{
    'en': 'English',
    'et': 'Eesti',
    'de': 'Deutsch',
    'fr': 'Francais',
    'sv': 'Svenska',
    'lv': 'Latviesu',
    'no': 'Norsk',
    'da': 'Dansk',
    'pl': 'Polski',
    'nl': 'Nederlands',
    'fi': 'Suomi',
    'lt': 'Lietuviu',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _populateFromProfile(UserProfile profile) {
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _countryController.text = profile.country;
    _cityController.text = profile.city;
    _currency = _currencies.contains(profile.currency)
        ? profile.currency
        : 'EUR';
    _language = AppConstants.supportedLocales.contains(profile.language)
        ? profile.language
        : 'en';
    _selectedMediums = profile.preferredMediums.toSet();
    _selectedPeriods = profile.preferredPeriods.toSet();
    _notifyWeeklyDigest = profile.notifyWeeklyDigest;
  }

  Future<void> _saveAccount() async {
    setState(() => _savingAccount = true);
    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            UpdateProfileRequest(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              country: _countryController.text.trim(),
              city: _cityController.text.trim(),
              currency: _currency,
              language: _language,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account saved'),
          backgroundColor: AppTheme.green600,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save account: $e'),
          backgroundColor: AppTheme.red600,
        ),
      );
    } finally {
      if (mounted) setState(() => _savingAccount = false);
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _savingPrefs = true);
    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            UpdateProfileRequest(
              preferredMediums: _selectedMediums.toList(),
              preferredPeriods: _selectedPeriods.toList(),
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preferences saved'),
          backgroundColor: AppTheme.green600,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save preferences: $e'),
          backgroundColor: AppTheme.red600,
        ),
      );
    } finally {
      if (mounted) setState(() => _savingPrefs = false);
    }
  }

  Future<void> _saveNotifications() async {
    setState(() => _savingNotifications = true);
    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            UpdateProfileRequest(notifyWeeklyDigest: _notifyWeeklyDigest),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notification settings saved'),
          backgroundColor: AppTheme.green600,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save notifications: $e'),
          backgroundColor: AppTheme.red600,
        ),
      );
    } finally {
      if (mounted) setState(() => _savingNotifications = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    profileAsync.whenData((profile) {
      if (profile != null && !_initialized) {
        _initialized = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _populateFromProfile(profile));
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Preferences')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load profile: $e',
              style: TextStyle(color: AppTheme.red600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Please log in to view profile.'));
          }
          return _buildForm();
        },
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader('Account'),
          const SizedBox(height: 12),
          _textField('Name', _nameController),
          const SizedBox(height: 12),
          _textField('Email', _emailController, readOnly: true),
          const SizedBox(height: 12),
          _textField(
            'Phone',
            _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          _textField('Country', _countryController),
          const SizedBox(height: 12),
          _textField('City', _cityController),
          const SizedBox(height: 12),
          _dropdownField<String>(
            label: 'Currency',
            value: _currency,
            items: _currencies
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _currency = v);
            },
          ),
          const SizedBox(height: 12),
          _dropdownField<String>(
            label: 'Language',
            value: _language,
            items: AppConstants.supportedLocales.map((code) {
              final label = _languageLabels[code] ?? code;
              return DropdownMenuItem(value: code, child: Text(label));
            }).toList(),
            onChanged: (v) {
              if (v != null) setState(() => _language = v);
            },
          ),
          const SizedBox(height: 20),
          _saveButton('Save Account', _savingAccount, _saveAccount),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          _sectionHeader('Art Preferences'),
          const SizedBox(height: 16),

          _chipGroupLabel('Preferred Mediums'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: AppConstants.mediums.map((medium) {
              final selected = _selectedMediums.contains(medium);
              return FilterChip(
                label: Text(medium),
                selected: selected,
                selectedColor: AppTheme.ink,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : AppTheme.ink,
                  fontSize: 13,
                ),
                checkmarkColor: Colors.white,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedMediums.add(medium);
                    } else {
                      _selectedMediums.remove(medium);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          _chipGroupLabel('Preferred Periods'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: AppConstants.periods.map((period) {
              final selected = _selectedPeriods.contains(period);
              return FilterChip(
                label: Text(period),
                selected: selected,
                selectedColor: AppTheme.ink,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : AppTheme.ink,
                  fontSize: 13,
                ),
                checkmarkColor: Colors.white,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedPeriods.add(period);
                    } else {
                      _selectedPeriods.remove(period);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _saveButton('Save Preferences', _savingPrefs, _savePreferences),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          _sectionHeader('Notifications'),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Weekly art market digest',
              style: TextStyle(fontSize: 14),
            ),
            value: _notifyWeeklyDigest,
            activeThumbColor: AppTheme.ink,
            onChanged: (v) => setState(() => _notifyWeeklyDigest = v),
          ),
          const SizedBox(height: 16),
          _saveButton(
            'Save Notifications',
            _savingNotifications,
            _saveNotifications,
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppTheme.ink,
      ),
    );
  }

  Widget _chipGroupLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.gray500,
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppTheme.gray500, fontSize: 14),
        filled: readOnly,
        fillColor: readOnly ? AppTheme.gray100 : null,
      ),
    );
  }

  Widget _dropdownField<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppTheme.gray500, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _saveButton(String label, bool isLoading, VoidCallback onPressed) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}
