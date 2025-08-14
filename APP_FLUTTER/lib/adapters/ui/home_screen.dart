import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/chatbot_controller.dart';
import '../../application/disease_detection_controller.dart';
import '../../theme/theme_manager.dart';
import '../../theme/color_palette.dart';
import 'chatbot_screen.dart';
import 'disease_detection_screen.dart';
import 'widgets/app_background.dart';

class HomeScreen extends StatefulWidget {
  final ChatbotController chatbotController;
  final DiseaseDetectionController diseaseController;

  const HomeScreen({
    super.key,
    required this.chatbotController,
    required this.diseaseController,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _DashboardScreen(onNavigate: _navigateToPage),
      ChatbotScreen(controller: widget.chatbotController),
      DiseaseDetectionScreen(controller: widget.diseaseController),
    ];
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeManager.toggleTheme(),
          ),
        ],
      ),
      drawer: _buildDrawer(context, isDark),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Asistente Agrícola';
      case 1:
        return 'Chat IA';
      case 2:
        return 'Visión IA';
      default:
        return 'Asistente Agrícola';
    }
  }

  Widget _buildDrawer(BuildContext context, bool isDark) {
    return Drawer(
      child: AppBackground(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: isDark ? heroGradientDark : heroGradientLight,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.agriculture,
                        size: 40,
                        color: azulVibrante,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Asistente Agrícola',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'IA + Visión por Computadora',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home,
                    title: 'Inicio',
                    index: 0,
                    isDark: isDark,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.chat_bubble,
                    title: 'Chat IA',
                    index: 1,
                    isDark: isDark,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.visibility,
                    title: 'Visión IA',
                    index: 2,
                    isDark: isDark,
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: isDark ? modernDarkSecondaryText : modernLightSecondaryText,
                    ),
                    title: Text(
                      isDark ? 'Modo Claro' : 'Modo Oscuro',
                      style: TextStyle(
                        color: isDark ? modernDarkText : modernLightText,
                      ),
                    ),
                    onTap: () {
                      Provider.of<ThemeManager>(context, listen: false).toggleTheme();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Versión 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? modernDarkMutedText : modernLightMutedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _selectedIndex == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: isSelected 
            ? (isDark ? primaryGradientDark : primaryGradientLight)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected 
              ? Colors.white
              : (isDark ? modernDarkSecondaryText : modernLightSecondaryText),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? modernDarkText : modernLightText),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.of(context).pop();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _DashboardScreen extends StatelessWidget {
  final Function(int)? onNavigate;

  const _DashboardScreen({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.isDarkMode;

    return AppBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bienvenida
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: isDark ? heroGradientDark : heroGradientLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.agriculture,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tu asistente agrícola con IA y visión por computadora',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Funcionalidades',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? modernDarkText : modernLightText,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Cards de funcionalidades
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.chat_bubble,
                    title: 'Chat IA',
                    description: 'Conversa con el asistente',
                    gradient: isDark ? primaryGradientDark : primaryGradientLight,
                    onTap: () {
                      onNavigate?.call(1);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.visibility,
                    title: 'Visión IA',
                    description: 'Detecta enfermedades',
                    gradient: isDark ? accentGradientDark : accentGradientLight,
                    onTap: () {
                      onNavigate?.call(2);
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Información adicional
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDark ? darkCardGradient : lightCardGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enfermedades Detectables',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? modernDarkText : modernLightText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDiseaseInfo('🦠 Mancha bacteriana', isDark),
                    _buildDiseaseInfo('🍂 Tizón temprano', isDark),
                    _buildDiseaseInfo('🌿 Tizón tardío', isDark),
                    _buildDiseaseInfo('🍄 Moho de la hoja', isDark),
                    _buildDiseaseInfo('🔴 Mancha foliar por Septoria', isDark),
                    _buildDiseaseInfo('✅ Planta saludable', isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiseaseInfo(String disease, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            disease,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? modernDarkSecondaryText : modernLightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }
}