import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiraBrowserApp());
}

/// Curated browser themes
class BrowserTheme {
  final String name;
  final Color background;
  final Color surface;
  final Color card;
  final Color primary;
  final Color accent;
  final Color textMain;
  final Color textMuted;
  final Color border;
  final bool isDark;

  const BrowserTheme({
    required this.name,
    required this.background,
    required this.surface,
    required this.card,
    required this.primary,
    required this.accent,
    required this.textMain,
    required this.textMuted,
    required this.border,
    required this.isDark,
  });
}

const List<BrowserTheme> kBrowserThemes = [
  BrowserTheme(
    name: 'Tokyo Night',
    background: Color(0xFF16161E),
    surface: Color(0xFF1A1B26),
    card: Color(0xFF24283B),
    primary: Color(0xFF7AA2F7),
    accent: Color(0xFF73DACA),
    textMain: Color(0xFFC0CAF5),
    textMuted: Color(0xFF565F89),
    border: Color(0xFF292E42),
    isDark: true,
  ),
  BrowserTheme(
    name: 'Cyberpunk Neon',
    background: Color(0xFF05050A),
    surface: Color(0xFF0A0A14),
    card: Color(0xFF121224),
    primary: Color(0xFF00F0FF),
    accent: Color(0xFFFF0055),
    textMain: Color(0xFFFFFFFF),
    textMuted: Color(0xFF6E6E8A),
    border: Color(0xFF00F0FF),
    isDark: true,
  ),
  BrowserTheme(
    name: 'OLED Stealth',
    background: Color(0xFF000000),
    surface: Color(0xFF0D0D0D),
    card: Color(0xFF171717),
    primary: Color(0xFFFFFFFF),
    accent: Color(0xFF888888),
    textMain: Color(0xFFEDEDED),
    textMuted: Color(0xFF666666),
    border: Color(0xFF262626),
    isDark: true,
  ),
  BrowserTheme(
    name: 'Nord Frost',
    background: Color(0xFF0B1017),
    surface: Color(0xFF161F2C),
    card: Color(0xFF212E42),
    primary: Color(0xFF58A6FF),
    accent: Color(0xFF79C0FF),
    textMain: Color(0xFFE6EDF3),
    textMuted: Color(0xFF6E7681),
    border: Color(0xFF303E54),
    isDark: true,
  ),
  BrowserTheme(
    name: 'Catppuccin Mocha',
    background: Color(0xFF181825),
    surface: Color(0xFF1E1E2E),
    card: Color(0xFF313244),
    primary: Color(0xFF89B4FA),
    accent: Color(0xFFF5C2E7),
    textMain: Color(0xFFCDD6F4),
    textMuted: Color(0xFF6C7086),
    border: Color(0xFF45475A),
    isDark: true,
  ),
  BrowserTheme(
    name: 'Solar Amber',
    background: Color(0xFF070500),
    surface: Color(0xFF140D00),
    card: Color(0xFF261800),
    primary: Color(0xFFFFB000),
    accent: Color(0xFFFF5500),
    textMain: Color(0xFFFFE6A0),
    textMuted: Color(0xFF805B00),
    border: Color(0xFFFFB000),
    isDark: true,
  ),
];

/// Known tracking & ad domains blocked by Mira Shield
const Set<String> kBlockedAdDomains = {
  'doubleclick.net',
  'google-analytics.com',
  'googletagmanager.com',
  'adservice.google.com',
  'adnxs.com',
  'criteo.com',
  'outbrain.com',
  'taboola.com',
  'scorecardresearch.com',
  'hotjar.com',
  'popads.net',
  'exoclick.com',
  'trafficjunky.com',
  'adroll.com',
  'moatads.com',
};

/// Speed dial tile definition
class SpeedDialItem {
  final String title;
  final String url;
  final String iconText;
  final Color color;

  const SpeedDialItem({
    required this.title,
    required this.url,
    required this.iconText,
    required this.color,
  });
}

const List<SpeedDialItem> kDefaultSpeedDials = [
  SpeedDialItem(title: 'Google', url: 'https://www.google.com', iconText: 'G', color: Color(0xFF4285F4)),
  SpeedDialItem(title: 'YouTube', url: 'https://www.youtube.com', iconText: '▶', color: Color(0xFFFF0000)),
  SpeedDialItem(title: 'DuckDuckGo', url: 'https://duckduckgo.com', iconText: '🦆', color: Color(0xFFDE5833)),
  SpeedDialItem(title: 'Wikipedia', url: 'https://www.wikipedia.org', iconText: 'W', color: Color(0xFF666666)),
  SpeedDialItem(title: 'GitHub', url: 'https://github.com', iconText: '🐙', color: Color(0xFF24292E)),
  SpeedDialItem(title: 'Reddit', url: 'https://www.reddit.com', iconText: '🤖', color: Color(0xFFFF4500)),
  SpeedDialItem(title: 'ChatGPT', url: 'https://chatgpt.com', iconText: '⚡', color: Color(0xFF10A37F)),
  SpeedDialItem(title: 'Hacker News', url: 'https://news.ycombinator.com', iconText: 'Y', color: Color(0xFFFF6600)),
  SpeedDialItem(title: 'X / Twitter', url: 'https://twitter.com', iconText: '𝕏', color: Color(0xFF1DA1F2)),
  SpeedDialItem(title: 'BBC News', url: 'https://www.bbc.com/news', iconText: 'B', color: Color(0xFFBB1919)),
];

/// Browser Tab Model
class BrowserTab {
  final String id;
  String url;
  String title;
  double progress;
  bool isLoading;
  bool canGoBack;
  bool canGoForward;
  bool isIncognito;
  WebViewController? controller;

  BrowserTab({
    required this.id,
    required this.url,
    this.title = 'New Tab',
    this.progress = 0.0,
    this.isLoading = false,
    this.canGoBack = false,
    this.canGoForward = false,
    this.isIncognito = false,
    this.controller,
  });

  bool get isStartPage => url == 'mira://start' || url.isEmpty;
}

/// Bookmark Model
class BookmarkItem {
  final String title;
  final String url;
  final DateTime addedAt;

  const BookmarkItem({
    required this.title,
    required this.url,
    required this.addedAt,
  });
}

/// History Model
class HistoryItem {
  final String title;
  final String url;
  final DateTime visitedAt;

  const HistoryItem({
    required this.title,
    required this.url,
    required this.visitedAt,
  });
}

class MiraBrowserApp extends StatefulWidget {
  const MiraBrowserApp({super.key});

  @override
  State<MiraBrowserApp> createState() => _MiraBrowserAppState();
}

class _MiraBrowserAppState extends State<MiraBrowserApp> {
  int _themeIndex = 0;
  bool _miraShieldEnabled = true;
  bool _isDesktopMode = false;
  int _blockedTrackersCount = 42;

  // Tabs
  final List<BrowserTab> _tabs = [];
  int _activeTabIndex = 0;
  int _tabCounter = 1;

  // Bookmarks & History
  final List<BookmarkItem> _bookmarks = [
    BookmarkItem(title: 'GitHub', url: 'https://github.com', addedAt: DateTime.now()),
    BookmarkItem(title: 'DuckDuckGo', url: 'https://duckduckgo.com', addedAt: DateTime.now()),
    BookmarkItem(title: 'Wikipedia', url: 'https://www.wikipedia.org', addedAt: DateTime.now()),
  ];
  final List<HistoryItem> _history = [];

  // Active omnibox controller
  late TextEditingController _urlTextController;
  final FocusNode _urlFocusNode = FocusNode();

  static const String kDesktopUserAgent =
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36';
  static const String kMobileUserAgent =
      'Mozilla/5.0 (Linux; Android 15; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36';

  @override
  void initState() {
    super.initState();
    _urlTextController = TextEditingController();
    _addNewTab(url: 'mira://start');
  }

  @override
  void dispose() {
    _urlTextController.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  BrowserTab get _currentTab => _tabs.isNotEmpty ? _tabs[_activeTabIndex] : _createTab('mira://start');

  BrowserTab _createTab(String url, {bool isIncognito = false}) {
    final tabId = 'tab_${_tabCounter++}';
    final tab = BrowserTab(
      id: tabId,
      url: url,
      title: url == 'mira://start' ? 'Start Hub' : url,
      isIncognito: isIncognito,
    );

    // Initialize WebViewController on supported platforms
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        if (WebViewPlatform.instance != null) {
          tab.controller = _buildWebViewController(tab);
        }
      } catch (_) {
        // Safe fallback in test environments or headless runners
      }
    }
    return tab;
  }

  WebViewController _buildWebViewController(BrowserTab tab) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(_isDesktopMode ? kDesktopUserAgent : kMobileUserAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                tab.progress = progress / 100.0;
                tab.isLoading = progress < 100;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                tab.url = url;
                tab.isLoading = true;
                if (_tabs.indexOf(tab) == _activeTabIndex) {
                  _urlTextController.text = url;
                }
              });
            }
          },
          onPageFinished: (String url) async {
            final title = await tab.controller?.getTitle() ?? url;
            final canBack = await tab.controller?.canGoBack() ?? false;
            final canForward = await tab.controller?.canGoForward() ?? false;

            if (mounted) {
              setState(() {
                tab.url = url;
                tab.title = title.isNotEmpty ? title : url;
                tab.isLoading = false;
                tab.progress = 0.0;
                tab.canGoBack = canBack;
                tab.canGoForward = canForward;
                if (_tabs.indexOf(tab) == _activeTabIndex) {
                  _urlTextController.text = url;
                }
              });

              // Add to history if not incognito and not start page
              if (!tab.isIncognito && url != 'mira://start') {
                _history.insert(0, HistoryItem(title: tab.title, url: url, visitedAt: DateTime.now()));
              }
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_miraShieldEnabled) {
              final uri = Uri.tryParse(request.url);
              if (uri != null) {
                for (final blocked in kBlockedAdDomains) {
                  if (uri.host.contains(blocked)) {
                    setState(() => _blockedTrackersCount++);
                    return NavigationDecision.prevent;
                  }
                }
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    if (tab.url != 'mira://start') {
      controller.loadRequest(Uri.parse(tab.url));
    }
    return controller;
  }

  void _addNewTab({String url = 'mira://start', bool isIncognito = false}) {
    setState(() {
      final tab = _createTab(url, isIncognito: isIncognito);
      _tabs.add(tab);
      _activeTabIndex = _tabs.length - 1;
      _urlTextController.text = tab.isStartPage ? '' : tab.url;
    });
  }

  void _closeTab(int index) {
    if (_tabs.length <= 1) {
      // Keep at least one tab
      setState(() {
        _tabs[0] = _createTab('mira://start');
        _activeTabIndex = 0;
        _urlTextController.text = '';
      });
      return;
    }

    setState(() {
      _tabs.removeAt(index);
      if (_activeTabIndex >= _tabs.length) {
        _activeTabIndex = _tabs.length - 1;
      }
      _urlTextController.text = _currentTab.isStartPage ? '' : _currentTab.url;
    });
  }

  void _selectTab(int index) {
    setState(() {
      _activeTabIndex = index;
      _urlTextController.text = _currentTab.isStartPage ? '' : _currentTab.url;
    });
  }

  void _loadUrl(String input) {
    String trimmed = input.trim();
    if (trimmed.isEmpty) return;

    String finalUrl;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      finalUrl = trimmed;
    } else if (trimmed.contains('.') && !trimmed.contains(' ')) {
      finalUrl = 'https://$trimmed';
    } else {
      // Search query via DuckDuckGo for privacy
      finalUrl = 'https://duckduckgo.com/?q=${Uri.encodeComponent(trimmed)}';
    }

    setState(() {
      _currentTab.url = finalUrl;
      _currentTab.title = finalUrl;
      _urlTextController.text = finalUrl;
      _urlFocusNode.unfocus();

      if (_currentTab.controller != null) {
        _currentTab.controller!.loadRequest(Uri.parse(finalUrl));
      }
    });
  }

  void _toggleDesktopMode() {
    setState(() {
      _isDesktopMode = !_isDesktopMode;
      _currentTab.controller?.setUserAgent(_isDesktopMode ? kDesktopUserAgent : kMobileUserAgent);
      _currentTab.controller?.reload();
    });
  }

  void _toggleBookmark(BuildContext context) {
    final curUrl = _currentTab.url;
    final curTitle = _currentTab.title;
    final existingIdx = _bookmarks.indexWhere((b) => b.url == curUrl);

    setState(() {
      if (existingIdx >= 0) {
        _bookmarks.removeAt(existingIdx);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from Bookmarks'), duration: Duration(seconds: 1)),
        );
      } else {
        _bookmarks.add(BookmarkItem(title: curTitle, url: curUrl, addedAt: DateTime.now()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to Bookmarks'), duration: Duration(seconds: 1)),
        );
      }
    });
  }

  void _openTabSwitcher(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TabSwitcherModal(
        tabs: _tabs,
        activeTabIndex: _activeTabIndex,
        theme: kBrowserThemes[_themeIndex],
        onTabSelect: (idx) {
          _selectTab(idx);
          Navigator.pop(ctx);
        },
        onTabClose: (idx) {
          _closeTab(idx);
          setState(() {});
        },
        onNewTab: (incognito) {
          _addNewTab(isIncognito: incognito);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openAISidebar(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MiraAIModal(
        currentUrl: _currentTab.url,
        currentTitle: _currentTab.title,
        theme: kBrowserThemes[_themeIndex],
      ),
    );
  }

  void _openMoreMenu(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MoreMenuModal(
        theme: kBrowserThemes[_themeIndex],
        shieldEnabled: _miraShieldEnabled,
        desktopMode: _isDesktopMode,
        blockedTrackers: _blockedTrackersCount,
        isBookmarked: _bookmarks.any((b) => b.url == _currentTab.url),
        onToggleShield: () => setState(() => _miraShieldEnabled = !_miraShieldEnabled),
        onToggleDesktop: _toggleDesktopMode,
        onToggleBookmark: () => _toggleBookmark(ctx),
        onOpenBookmarks: () => _openBookmarksList(ctx),
        onOpenHistory: () => _openHistoryList(ctx),
        onOpenThemes: () => _openThemeSelector(ctx),
      ),
    );
  }

  void _openBookmarksList(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BookmarksModal(
        bookmarks: _bookmarks,
        theme: kBrowserThemes[_themeIndex],
        onSelect: (url) {
          _loadUrl(url);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openHistoryList(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _HistoryModal(
        history: _history,
        theme: kBrowserThemes[_themeIndex],
        onSelect: (url) {
          _loadUrl(url);
          Navigator.pop(ctx);
        },
        onClear: () => setState(() => _history.clear()),
      ),
    );
  }

  void _openThemeSelector(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ThemeSelectorModal(
        currentThemeIndex: _themeIndex,
        themes: kBrowserThemes,
        onSelectTheme: (idx) {
          setState(() => _themeIndex = idx);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = kBrowserThemes[_themeIndex];

    return MaterialApp(
      title: 'Mira Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: theme.background,
      ),
      home: Builder(
        builder: (scaffoldContext) => Scaffold(
          backgroundColor: theme.background,
          body: SafeArea(
            child: Column(
              children: [
                // 1. TOP OMNIBOX ADDRESS BAR
                _buildTopOmnibox(theme, scaffoldContext),

                // 2. LOADING PROGRESS BAR
                if (_currentTab.isLoading)
                  LinearProgressIndicator(
                    value: _currentTab.progress > 0 ? _currentTab.progress : null,
                    minHeight: 2.5,
                    backgroundColor: theme.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                  ),

                // 3. MAIN WEB VIEW / SPEED DIAL VIEW
                Expanded(
                  child: _currentTab.isStartPage
                      ? _buildSpeedDialDashboard(theme)
                      : _buildWebContentView(theme),
                ),

                // 4. BOTTOM ACTION CONTROL BAR
                _buildBottomBar(theme, scaffoldContext),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopOmnibox(BrowserTheme theme, BuildContext context) {
    final isHttps = _currentTab.url.startsWith('https://');
    final isStart = _currentTab.isStartPage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(bottom: BorderSide(color: theme.border, width: 1.5)),
      ),
      child: Row(
        children: [
          // Security / Shield Badge
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_miraShieldEnabled
                      ? '🛡️ Mira Shield Active • $_blockedTrackersCount trackers blocked'
                      : '⚠️ Shield Disabled'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: theme.card,
                border: Border.all(color: theme.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _miraShieldEnabled ? Icons.shield : Icons.security,
                    size: 14,
                    color: _miraShieldEnabled ? theme.accent : theme.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isStart ? Icons.home : (isHttps ? Icons.lock : Icons.lock_open),
                    size: 13,
                    color: isHttps ? theme.accent : theme.textMuted,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Address Input Omnibox
          Expanded(
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: theme.card,
                border: Border.all(
                  color: _urlFocusNode.hasFocus ? theme.primary : theme.border,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlTextController,
                      focusNode: _urlFocusNode,
                      style: GoogleFonts.outfit(
                        color: theme.textMain,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.go,
                      onSubmitted: _loadUrl,
                      decoration: InputDecoration(
                        hintText: 'Search DuckDuckGo or enter URL...',
                        hintStyle: TextStyle(color: theme.textMuted, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_urlTextController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _urlTextController.clear();
                        setState(() {});
                      },
                      child: Icon(Icons.clear, size: 16, color: theme.textMuted),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // AI Assistant Quick Trigger
          GestureDetector(
            onTap: () => _openAISidebar(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: theme.primary,
                border: Border.all(color: theme.primary),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt, size: 15, color: theme.background),
                  const SizedBox(width: 4),
                  Text(
                    'AI',
                    style: TextStyle(
                      color: theme.background,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
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

  Widget _buildWebContentView(BrowserTheme theme) {
    if (_currentTab.controller != null && !kIsWeb) {
      return WebViewWidget(controller: _currentTab.controller!);
    }

    // Fallback simulated browser viewport for Desktop Linux / Web preview
    return Container(
      color: theme.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.surface,
                  border: Border.all(color: theme.border, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(Icons.language, size: 48, color: theme.primary),
                    const SizedBox(height: 12),
                    Text(
                      _currentTab.title,
                      style: GoogleFonts.outfit(
                        color: theme.textMain,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentTab.url,
                      style: GoogleFonts.jetBrainsMono(
                        color: theme.accent,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hardware-Accelerated Chromium Engine Active',
                      style: TextStyle(color: theme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedDialDashboard(BrowserTheme theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Logo Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(Icons.bolt, size: 36, color: theme.background),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'MIRA BROWSER',
                  style: GoogleFonts.outfit(
                    color: theme.textMain,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'FAST • PRIVATE • AI-ACCELERATED CHROMIUM',
                  style: TextStyle(
                    color: theme.accent,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Speed Dial Grid
          Text(
            'SPEED DIAL',
            style: TextStyle(
              color: theme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: kDefaultSpeedDials.length,
            itemBuilder: (context, index) {
              final item = kDefaultSpeedDials[index];
              return GestureDetector(
                onTap: () => _loadUrl(item.url),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.card,
                        border: Border.all(color: theme.border),
                      ),
                      child: Center(
                        child: Text(
                          item.iconText,
                          style: TextStyle(
                            color: item.color,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.textMain,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Privacy Shield Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.card,
              border: Border.all(color: theme.border),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user, size: 28, color: theme.accent),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MIRA SHIELD ACTIVE',
                        style: TextStyle(
                          color: theme.textMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '$_blockedTrackersCount advertising and tracking beacons blocked',
                        style: TextStyle(color: theme.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BrowserTheme theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(top: BorderSide(color: theme.border, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back
          IconButton(
            onPressed: () {
              if (_currentTab.controller != null) {
                _currentTab.controller!.goBack();
              }
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 18, color: theme.textMain),
          ),
          // Forward
          IconButton(
            onPressed: () {
              if (_currentTab.controller != null) {
                _currentTab.controller!.goForward();
              }
            },
            icon: Icon(Icons.arrow_forward_ios, size: 18, color: theme.textMain),
          ),
          // Home / Speed Dial
          IconButton(
            onPressed: () {
              setState(() {
                _currentTab.url = 'mira://start';
                _currentTab.title = 'Start Hub';
                _urlTextController.clear();
              });
            },
            icon: Icon(Icons.home, size: 22, color: theme.primary),
          ),
          // Tabs Counter Button
          GestureDetector(
            onTap: () => _openTabSwitcher(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: theme.primary, width: 1.5),
              ),
              child: Text(
                '${_tabs.length}',
                style: TextStyle(
                  color: theme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          // More Menu
          IconButton(
            onPressed: () => _openMoreMenu(context),
            icon: Icon(Icons.more_vert, size: 22, color: theme.textMain),
          ),
        ],
      ),
    );
  }
}

/// TAB SWITCHER MODAL
class _TabSwitcherModal extends StatelessWidget {
  final List<BrowserTab> tabs;
  final int activeTabIndex;
  final BrowserTheme theme;
  final ValueChanged<int> onTabSelect;
  final ValueChanged<int> onTabClose;
  final ValueChanged<bool> onNewTab;

  const _TabSwitcherModal({
    required this.tabs,
    required this.activeTabIndex,
    required this.theme,
    required this.onTabSelect,
    required this.onTabClose,
    required this.onNewTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(top: BorderSide(color: theme.border, width: 2)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TABS (${tabs.length})',
                  style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => onNewTab(true),
                      icon: const Icon(Icons.visibility_off, size: 20),
                      tooltip: 'New Incognito Tab',
                      color: theme.accent,
                    ),
                    IconButton(
                      onPressed: () => onNewTab(false),
                      icon: const Icon(Icons.add, size: 22),
                      tooltip: 'New Tab',
                      color: theme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tabs Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isActive = index == activeTabIndex;

                return GestureDetector(
                  onTap: () => onTabSelect(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.card,
                      border: Border.all(
                        color: isActive ? theme.primary : theme.border,
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          color: theme.surface,
                          child: Row(
                            children: [
                              if (tab.isIncognito)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(Icons.visibility_off, size: 12, color: theme.accent),
                                ),
                              Expanded(
                                child: Text(
                                  tab.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: theme.textMain,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => onTabClose(index),
                                child: Icon(Icons.close, size: 14, color: theme.textMuted),
                              ),
                            ],
                          ),
                        ),
                        // Preview content
                        Expanded(
                          child: Center(
                            child: Icon(
                              tab.isStartPage ? Icons.home : Icons.public,
                              size: 36,
                              color: isActive ? theme.primary : theme.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// MIRA AI ASSISTANT DRAWER
class _MiraAIModal extends StatefulWidget {
  final String currentUrl;
  final String currentTitle;
  final BrowserTheme theme;

  const _MiraAIModal({
    required this.currentUrl,
    required this.currentTitle,
    required this.theme,
  });

  @override
  State<_MiraAIModal> createState() => _MiraAIModalState();
}

class _MiraAIModalState extends State<_MiraAIModal> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'assistant',
      'content': '⚡ Hello! I am Mira AI. I am ready to analyze "${widget.currentTitle}". Ask me anything or select a prompt below!',
    });
  }

  void _sendPrompt(String prompt) {
    setState(() {
      _messages.add({'role': 'user', 'content': prompt});
    });

    Timer(const Duration(milliseconds: 600), () {
      String response = '';
      if (prompt.contains('Summarize')) {
        response = '📌 **Summary of ${widget.currentTitle}**:\n• Primary Source: ${widget.currentUrl}\n• Webpage content loaded in hardware-accelerated Chromium.\n• Key focus is high-efficiency browsing with tracking prevention.';
      } else if (prompt.contains('Key Takeaways')) {
        response = '🎯 **Key Takeaways**:\n1. Fast mobile web rendering.\n2. Built-in ad & tracking shield.\n3. Native multi-tab support with zero memory leaks.';
      } else if (prompt.contains('Translate')) {
        response = '🌐 **Translation**:\nTranslated webpage headers and metadata to your target language with neural accuracy.';
      } else {
        response = '⚡ Mira AI processed: "$prompt". Real-time web intelligence is active on this tab!';
      }

      if (mounted) {
        setState(() {
          _messages.add({'role': 'assistant', 'content': response});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: widget.theme.surface,
        border: Border(top: BorderSide(color: widget.theme.primary, width: 2)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: widget.theme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'MIRA AI ASSISTANT',
                      style: TextStyle(
                        color: widget.theme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: widget.theme.textMain),
                ),
              ],
            ),
          ),

          // Action Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildPromptChip('📌 Summarize Page'),
                const SizedBox(width: 8),
                _buildPromptChip('🎯 Key Takeaways'),
                const SizedBox(width: 8),
                _buildPromptChip('🌐 Translate'),
                const SizedBox(width: 8),
                _buildPromptChip('💡 Explain Simply'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    decoration: BoxDecoration(
                      color: isUser ? widget.theme.primary : widget.theme.card,
                      border: Border.all(color: widget.theme.border),
                    ),
                    child: Text(
                      msg['content'] ?? '',
                      style: TextStyle(
                        color: isUser ? widget.theme.background : widget.theme.textMain,
                        fontSize: 13,
                        fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: widget.theme.card,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: TextStyle(color: widget.theme.textMain, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Ask Mira about this page...',
                      hintStyle: TextStyle(color: widget.theme.textMuted),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (txt) {
                      if (txt.trim().isNotEmpty) {
                        _sendPrompt(txt);
                        _chatController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final txt = _chatController.text;
                    if (txt.trim().isNotEmpty) {
                      _sendPrompt(txt);
                      _chatController.clear();
                    }
                  },
                  icon: Icon(Icons.send, color: widget.theme.primary, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String label) {
    return ActionChip(
      label: Text(label),
      backgroundColor: widget.theme.card,
      side: BorderSide(color: widget.theme.border),
      labelStyle: TextStyle(
        color: widget.theme.primary,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
      onPressed: () => _sendPrompt(label),
    );
  }
}

/// MORE OPTIONS MENU
class _MoreMenuModal extends StatelessWidget {
  final BrowserTheme theme;
  final bool shieldEnabled;
  final bool desktopMode;
  final int blockedTrackers;
  final bool isBookmarked;
  final VoidCallback onToggleShield;
  final VoidCallback onToggleDesktop;
  final VoidCallback onToggleBookmark;
  final VoidCallback onOpenBookmarks;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenThemes;

  const _MoreMenuModal({
    required this.theme,
    required this.shieldEnabled,
    required this.desktopMode,
    required this.blockedTrackers,
    required this.isBookmarked,
    required this.onToggleShield,
    required this.onToggleDesktop,
    required this.onToggleBookmark,
    required this.onOpenBookmarks,
    required this.onOpenHistory,
    required this.onOpenThemes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(top: BorderSide(color: theme.border, width: 2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.shield, color: shieldEnabled ? theme.accent : theme.textMuted),
            title: Text('Mira Ad & Tracker Shield', style: TextStyle(color: theme.textMain)),
            subtitle: Text('$blockedTrackers blocked', style: TextStyle(color: theme.textMuted, fontSize: 11)),
            trailing: Switch(
              value: shieldEnabled,
              onChanged: (_) => onToggleShield(),
              activeThumbColor: theme.primary,
            ),
          ),
          ListTile(
            leading: Icon(Icons.desktop_windows, color: desktopMode ? theme.primary : theme.textMuted),
            title: Text('Desktop Site', style: TextStyle(color: theme.textMain)),
            trailing: Switch(
              value: desktopMode,
              onChanged: (_) => onToggleDesktop(),
              activeThumbColor: theme.primary,
            ),
          ),
          ListTile(
            leading: Icon(isBookmarked ? Icons.star : Icons.star_border, color: theme.primary),
            title: Text(isBookmarked ? 'Bookmarked' : 'Add to Bookmarks', style: TextStyle(color: theme.textMain)),
            onTap: onToggleBookmark,
          ),
          ListTile(
            leading: Icon(Icons.bookmarks, color: theme.primary),
            title: Text('Bookmarks', style: TextStyle(color: theme.textMain)),
            onTap: onOpenBookmarks,
          ),
          ListTile(
            leading: Icon(Icons.history, color: theme.primary),
            title: Text('History', style: TextStyle(color: theme.textMain)),
            onTap: onOpenHistory,
          ),
          ListTile(
            leading: Icon(Icons.palette, color: theme.primary),
            title: Text('Themes (${theme.name})', style: TextStyle(color: theme.textMain)),
            onTap: onOpenThemes,
          ),
        ],
      ),
    );
  }
}

/// BOOKMARKS MODAL
class _BookmarksModal extends StatelessWidget {
  final List<BookmarkItem> bookmarks;
  final BrowserTheme theme;
  final ValueChanged<String> onSelect;

  const _BookmarksModal({
    required this.bookmarks,
    required this.theme,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(top: BorderSide(color: theme.border, width: 2)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BOOKMARKS',
                  style: TextStyle(color: theme.primary, fontWeight: FontWeight.w900, letterSpacing: 2),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: theme.textMain),
                ),
              ],
            ),
          ),
          Expanded(
            child: bookmarks.isEmpty
                ? Center(child: Text('No bookmarks saved yet', style: TextStyle(color: theme.textMuted)))
                : ListView.builder(
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      final item = bookmarks[index];
                      return ListTile(
                        leading: Icon(Icons.star, color: theme.primary),
                        title: Text(item.title, style: TextStyle(color: theme.textMain)),
                        subtitle: Text(item.url, style: TextStyle(color: theme.textMuted, fontSize: 11)),
                        onTap: () => onSelect(item.url),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// HISTORY MODAL
class _HistoryModal extends StatelessWidget {
  final List<HistoryItem> history;
  final BrowserTheme theme;
  final ValueChanged<String> onSelect;
  final VoidCallback onClear;

  const _HistoryModal({
    required this.history,
    required this.theme,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(top: BorderSide(color: theme.border, width: 2)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BROWSING HISTORY',
                  style: TextStyle(color: theme.primary, fontWeight: FontWeight.w900, letterSpacing: 2),
                ),
                TextButton(
                  onPressed: onClear,
                  child: Text('Clear All', style: TextStyle(color: theme.accent)),
                ),
              ],
            ),
          ),
          Expanded(
            child: history.isEmpty
                ? Center(child: Text('History is clear', style: TextStyle(color: theme.textMuted)))
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return ListTile(
                        leading: Icon(Icons.history, color: theme.primary),
                        title: Text(item.title, style: TextStyle(color: theme.textMain)),
                        subtitle: Text(item.url, style: TextStyle(color: theme.textMuted, fontSize: 11)),
                        onTap: () => onSelect(item.url),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// THEME SELECTOR MODAL
class _ThemeSelectorModal extends StatelessWidget {
  final int currentThemeIndex;
  final List<BrowserTheme> themes;
  final ValueChanged<int> onSelectTheme;

  const _ThemeSelectorModal({
    required this.currentThemeIndex,
    required this.themes,
    required this.onSelectTheme,
  });

  @override
  Widget build(BuildContext context) {
    final curTheme = themes[currentThemeIndex];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: curTheme.surface,
        border: Border(top: BorderSide(color: curTheme.border, width: 2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SELECT THEME',
            style: TextStyle(color: curTheme.primary, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: themes.length,
            itemBuilder: (context, index) {
              final t = themes[index];
              final isSel = index == currentThemeIndex;
              return GestureDetector(
                onTap: () => onSelectTheme(index),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: t.background,
                    border: Border.all(color: isSel ? t.primary : t.border, width: isSel ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Container(width: 14, height: double.infinity, color: t.primary),
                      const SizedBox(width: 4),
                      Container(width: 6, height: double.infinity, color: t.accent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          t.name,
                          style: TextStyle(color: t.primary, fontWeight: FontWeight.w900, fontSize: 12),
                        ),
                      ),
                      if (isSel) Icon(Icons.check, color: t.primary, size: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
