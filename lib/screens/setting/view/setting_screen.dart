import 'package:checklist_app/app/config/l10n/l10n.dart';
import 'package:checklist_app/app/core/constants/app_constants.dart';
import 'package:checklist_app/app/core/cubit/appearance_cubit.dart';
import 'package:checklist_app/app/core/enums/language_enum.dart';
import 'package:checklist_app/app/core/enums/theme_enum.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.setting)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, l10n.appearance, Icons.palette),
                const SizedBox(height: 12),
                _buildThemeModeSection(context),
                const SizedBox(height: 40),
                _buildSectionHeader(context, l10n.language, Icons.language),
                const SizedBox(height: 12),
                _buildLanguageSection(context),
                const SizedBox(height: 40),
                _buildSectionHeader(context, l10n.data, Icons.storage),
                const SizedBox(height: 12),
                _buildDataSection(context),
                const SizedBox(height: 40),
                _buildSectionHeader(context, l10n.support, Icons.help_outline),
                const SizedBox(height: 12),
                _buildSupportSection(context),
                const SizedBox(height: 40),
                _buildSectionHeader(context, l10n.about, Icons.info_outline),
                const SizedBox(height: 12),
                _buildAboutSection(context),
                const SizedBox(height: 32),
                _buildAppCopyright(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: context.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeSection(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AppearanceCubit, AppearanceState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                _buildThemeModeTile(
                  context,
                  l10n.light,
                  l10n.lightDescription,
                  Icons.light_mode,
                  AppConstants.themeModeLight,
                  state.theme.code == AppConstants.themeModeLight,
                  () => _changeThemeMode(context, ThemeEnum.light),
                ),
                _buildDivider(),
                _buildThemeModeTile(
                  context,
                  l10n.dark,
                  l10n.darkDescription,
                  Icons.dark_mode,
                  AppConstants.themeModeDark,
                  state.theme.code == AppConstants.themeModeDark,
                  () => _changeThemeMode(context, ThemeEnum.dark),
                ),
                _buildDivider(),
                _buildThemeModeTile(
                  context,
                  l10n.system,
                  l10n.systemDescription,
                  Icons.settings_system_daydream,
                  AppConstants.themeModeSystem,
                  state.theme.code == AppConstants.themeModeSystem,
                  () => _changeThemeMode(context, ThemeEnum.system),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeModeTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String themeMode,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: isSelected
          ? context.colorScheme.primaryContainer.withOpacity(0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colorScheme.primaryContainer
                      : context.colorScheme.surfaceVariant.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? context.colorScheme.primary
                            : context.textTheme.titleMedium?.color,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: context.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return BlocBuilder<AppearanceCubit, AppearanceState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                _buildLanguageTile(
                  context,
                  'English',
                  'English',
                  '🇺🇸',
                  LanguageEnum.english,
                  state.language == LanguageEnum.english,
                  () => _changeLanguage(context, LanguageEnum.english),
                ),
                _buildDivider(),
                _buildLanguageTile(
                  context,
                  'ខ្មែរ',
                  'Khmer',
                  '🇰🇭',
                  LanguageEnum.khmer,
                  state.language == LanguageEnum.khmer,
                  () => _changeLanguage(context, LanguageEnum.khmer),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String title,
    String subtitle,
    String flag,
    LanguageEnum language,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: isSelected
          ? context.colorScheme.primaryContainer.withOpacity(0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colorScheme.primaryContainer
                      : context.colorScheme.surfaceVariant.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(flag, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? context.colorScheme.primary
                            : context.textTheme.titleMedium?.color,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: context.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _buildActionTile(
          context,
          context.l10n.exportData,
          context.l10n.exportDataDescription,
          Icons.file_download_outlined,
          Colors.blue,
          () {
            _showSnackBar(context, 'Export feature coming soon');
          },
        ),
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildActionTile(
              context,
              context.l10n.helpSupport,
              context.l10n.helpSupportDescription,
              Icons.help_outline,
              Colors.orange,
              () {
                _showSnackBar(context, 'Help & Support coming soon');
              },
            ),
            _buildDivider(),
            _buildActionTile(
              context,
              context.l10n.privacyPolicy,
              context.l10n.privacyPolicyDescription,
              Icons.privacy_tip_outlined,
              Colors.green,
              () {
                _showSnackBar(context, 'Privacy Policy coming soon');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer.withOpacity(
                        0.2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.checklist_rounded,
                      size: 48,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.appTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoTile(
                    context,
                    context.l10n.appVersion,
                    _appVersion,
                    Icons.info_outline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: context.colorScheme.onSurfaceVariant, size: 16),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAppCopyright(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Text(
          '${context.l10n.copyright} © 2025 ${context.l10n.appTitle}',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, indent: 70, endIndent: 18);
  }

  void _changeThemeMode(BuildContext context, ThemeEnum theme) {
    context.read<AppearanceCubit>().changeTheme(theme);
  }

  void _changeLanguage(BuildContext context, LanguageEnum language) {
    context.read<AppearanceCubit>().changeLanguage(language);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
