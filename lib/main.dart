import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _spotifyGreen = Color(0xFF1DB954);
const _darkBackground = Color(0xFF121212);
const _lightBackground = Color(0xFFF7F7F7);

class AppAssets {
  static const spotifyIcon = 'assets/images/logo.png';
  static const onboardingListen = 'assets/images/fundo get started.png';
  static const onboardingMode = 'assets/images/fundo choose mode.png';
  static const albumBillie =
      'assets/images/imagem que fica no card verd com happier than ever.png';
  static const news1 = 'assets/images/imagem que fica em cima de bad guy.png';
  static const news2 = 'assets/images/imgaem que fica em cima de scorpion.png';
}

final ThemeController themeController = ThemeController();

class ThemeController {
  ThemeController([ThemeMode initialMode = ThemeMode.light])
      : mode = ValueNotifier<ThemeMode>(initialMode);

  final ValueNotifier<ThemeMode> mode;

  void setMode(ThemeMode nextMode) {
    if (mode.value == nextMode) {
      return;
    }
    mode.value = nextMode;
  }
}

void main() {
  runApp(const MyApp());
}

ThemeData _buildTheme({
  required Brightness brightness,
  required Color scaffold,
}) {
  final base = ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _spotifyGreen,
      brightness: brightness,
    ),
    useMaterial3: true,
  );

  final textTheme = GoogleFonts.manropeTextTheme(base.textTheme).apply(
    bodyColor: brightness == Brightness.dark ? Colors.white : Colors.black87,
    displayColor:
        brightness == Brightness.dark ? Colors.white : Colors.black87,
  );

  return base.copyWith(
    scaffoldBackgroundColor: scaffold,
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _spotifyGreen,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _spotifyGreen,
      unselectedItemColor: Color(0xFF9E9E9E),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Spotify UI',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(
            brightness: Brightness.light,
            scaffold: _lightBackground,
          ),
          darkTheme: _buildTheme(
            brightness: Brightness.dark,
            scaffold: _darkBackground,
          ),
          themeMode: mode,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => const SplashScreen());
              case '/get-started':
                return MaterialPageRoute(
                  builder: (_) => const GetStartedScreen(),
                );
              case '/choose-mode':
                return MaterialPageRoute(
                  builder: (_) => ChooseModeScreen(
                    controller: themeController,
                  ),
                );
              case '/home':
                return MaterialPageRoute(builder: (_) => const HomeScreen());
              default:
                return MaterialPageRoute(
                  builder: (_) => const GetStartedScreen(),
                );
            }
          },
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static final Future<void> _delay =
      Future<void>.delayed(const Duration(seconds: 2));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _delay,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const GetStartedScreen();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: const Center(
            child: AssetImageSafe(
              path: AppAssets.spotifyIcon,
              width: 88,
              height: 88,
            ),
          ),
        );
      },
    );
  }
}

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: AssetImageSafe(
              path: AppAssets.onboardingListen,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xB3000000),
                    Color(0xE6000000),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                children: [
                  const SpotifyLogo(),
                  const Spacer(),
                  Text(
                    'Enjoy Listening To Music',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Sagittis enim purus sed phasellus. Cursus sed id '
                    'scelerisque aliquam.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/choose-mode');
                      },
                      child: const Text('Get Started'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChooseModeScreen extends StatelessWidget {
  const ChooseModeScreen({
    super.key,
    required this.controller,
  });

  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller.mode,
      builder: (context, selectedMode, _) {
        return Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(
                child: AssetImageSafe(
                  path: AppAssets.onboardingMode,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    children: [
                      const SpotifyLogo(),
                      const Spacer(),
                      Text(
                        'Choose Mode',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ModeCard(
                            icon: Icons.nightlight_outlined,
                            label: 'Dark Mode',
                            isSelected: selectedMode == ThemeMode.dark,
                            onTap: () => controller.setMode(ThemeMode.dark),
                          ),
                          const SizedBox(width: 16),
                          ModeCard(
                            icon: Icons.wb_sunny_outlined,
                            label: 'Light Mode',
                            isSelected: selectedMode == ThemeMode.light,
                            onTap: () => controller.setMode(ThemeMode.light),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/home');
                          },
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _news = [
    NewsCardData(
      title: 'Bad Guy',
      artist: 'Billie Eilish',
      image: AppAssets.news1,
    ),
    NewsCardData(
      title: 'Scorpion',
      artist: 'Drake',
      image: AppAssets.news2,
    ),
  ];

  static const _playlist = [
    PlaylistItem(
      title: 'As It Was',
      artist: 'Harry Styles',
      duration: '5:33',
    ),
    PlaylistItem(
      title: 'God Did',
      artist: 'DJ Khaled',
      duration: '3:43',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1B1B1B);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF6E6E6E);
    final cardBackground = isDark ? const Color(0xFF1D1D1D) : Colors.white;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleIconButton(
                      icon: Icons.search,
                      color: textPrimary,
                    ),
                    const AssetImageSafe(
                      path: AppAssets.spotifyIcon,
                      width: 30,
                      height: 30,
                    ),
                    CircleIconButton(
                      icon: Icons.more_vert,
                      color: textPrimary,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'New Album',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: NewAlbumCard(
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    TabItem(label: 'News', isActive: true),
                    SizedBox(width: 20),
                    TabItem(label: 'Video'),
                    SizedBox(width: 20),
                    TabItem(label: 'Artists'),
                    SizedBox(width: 20),
                    TabItem(label: 'Podcast'),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'News',
                action: 'See More',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = _news[index];
                    return NewsCard(
                      item: item,
                      backgroundColor: cardBackground,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemCount: _news.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Playlist',
                action: 'See More',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _playlist[index];
                  return PlaylistRow(
                    item: item,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    isLast: index == _playlist.length - 1,
                  );
                },
                childCount: _playlist.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class SpotifyLogo extends StatelessWidget {
  const SpotifyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AssetImageSafe(
      path: AppAssets.spotifyIcon,
      width: 52,
      height: 52,
    );
  }
}

class ModeCard extends StatelessWidget {
  const ModeCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? _spotifyGreen : Colors.white24;
    final iconColor = isSelected ? _spotifyGreen : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class NewAlbumCard extends StatelessWidget {
  const NewAlbumCard({
    super.key,
    required this.textPrimary,
    required this.textSecondary,
  });

  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: _spotifyGreen,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New Album',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Happier Than Ever',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Billie Eilish',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          const AssetImageSafe(
            path: AppAssets.albumBillie,
            width: 90,
            height: 110,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.label, this.isActive = false});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? Colors.white : const Color(0xFF1B1B1B);
    final inactiveColor = isDark ? Colors.white60 : const Color(0xFF9E9E9E);
    final color = isActive ? activeColor : inactiveColor;

    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
        const SizedBox(height: 6),
        if (isActive)
          Container(
            width: 18,
            height: 2,
            decoration: BoxDecoration(
              color: _spotifyGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.action,
    required this.textPrimary,
    required this.textSecondary,
    required this.padding,
  });

  final String title;
  final String action;
  final Color textPrimary;
  final Color textSecondary;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            action,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.item,
    required this.backgroundColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  final NewsCardData item;
  final Color backgroundColor;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetImageSafe(
            path: item.image,
            width: double.infinity,
            height: 90,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            item.artist,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textSecondary,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class PlaylistRow extends StatelessWidget {
  const PlaylistRow({
    super.key,
    required this.item,
    required this.textPrimary,
    required this.textSecondary,
    required this.isLast,
  });

  final PlaylistItem item;
  final Color textPrimary;
  final Color textSecondary;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.artist,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                item.duration,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                    ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.favorite_border,
                color: _spotifyGreen,
                size: 18,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: Colors.black.withOpacity(0.06),
          ),
      ],
    );
  }
}

class NewsCardData {
  const NewsCardData({
    required this.title,
    required this.artist,
    required this.image,
  });

  final String title;
  final String artist;
  final String image;
}

class PlaylistItem {
  const PlaylistItem({
    required this.title,
    required this.artist,
    required this.duration,
  });

  final String title;
  final String artist;
  final String duration;
}

class AssetImageSafe extends StatelessWidget {
  const AssetImageSafe({
    super.key,
    required this.path,
    this.fit,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String path;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.black12,
          alignment: Alignment.center,
          child: Icon(
            Icons.image_outlined,
            color: Colors.black.withOpacity(0.4),
          ),
        );
      },
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: image,
    );
  }
}
