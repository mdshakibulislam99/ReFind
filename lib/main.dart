import 'package:flutter/material.dart';

void main() => runApp(const ReFindApp());

const purple = Color(0xFF6055F5);
const ink = Color(0xFF191B43);
const muted = Color(0xFF7D819B);
const green = Color(0xFF00B98B);

class ReFindApp extends StatelessWidget {
  const ReFindApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ReFind',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8F9FF),
      colorScheme: ColorScheme.fromSeed(seedColor: purple),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
        bodyMedium: TextStyle(color: ink, height: 1.5),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8F9FF),
        foregroundColor: ink,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E5F1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E5F1)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: purple,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    home: const Welcome(),
  );
}

void go(BuildContext c, Widget page) =>
    Navigator.of(c).push(MaterialPageRoute<void>(builder: (_) => page));
Widget gap([double h = 20]) => SizedBox(height: h);
Widget heading(String title, [String? subtitle]) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      title,
      style: const TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
    ),
    if (subtitle != null) ...[
      gap(7),
      Text(subtitle, style: const TextStyle(color: muted, height: 1.5)),
      gap(),
    ],
  ],
);
Widget panel(Widget child, {Color color = Colors.white}) => Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: const Color(0xFFE9EAF5)),
  ),
  child: child,
);
Widget symbol(IconData icon, {double size = 90, Color color = purple}) =>
    Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(size * .3),
      ),
      child: Icon(icon, size: size * .48, color: color),
    );
Widget pageBody(List<Widget> children, {Key? key}) => Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 540),
    child: ListView(
      key: key,
      padding: const EdgeInsets.all(24),
      children: children,
    ),
  ),
);

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF11172E), Color(0xFF29205D)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.radar_rounded,
                                color: Color(0xFF9D97FF),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'ReFind',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(35),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white12),
                            ),
                            child: symbol(
                              Icons.travel_explore_rounded,
                              size: 150,
                              color: const Color(0xFF9D97FF),
                            ),
                          ),
                          gap(40),
                          const Text(
                            'Lost things.\nFound connections.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          gap(),
                          const Text(
                            'A little help can bring a lot back.\nFind what you lost. Return what you found.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFBFBCD8),
                              height: 1.7,
                            ),
                          ),
                          const Spacer(),
                          FilledButton(
                            onPressed: () => go(context, const Onboarding()),
                            child: const Text('Let’s get started  →'),
                          ),
                          gap(12),
                          TextButton(
                            onPressed: () => go(context, const AuthPage()),
                            child: const Text(
                              'Already have an account? Log in',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          gap(10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int step = 0;
  final titles = [
    'Every item has a story.',
    'Start where you last saw it.',
    'A picture brings you closer.',
  ];
  final subtitles = [
    'Report a lost item or help someone find theirs. Small actions make happy reunions.',
    'Add a location or the route you took to help your community know where to look.',
    'Compare your item with community reports. Image matching will help narrow the search.',
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [
        TextButton(
          onPressed: () => go(context, const AuthPage(register: true)),
          child: const Text('Skip'),
        ),
      ],
    ),
    body: pageBody([
      gap(50),
      Center(
        child: symbol(
          [
            Icons.inventory_2_outlined,
            Icons.map_outlined,
            Icons.image_search_rounded,
          ][step],
          size: 190,
        ),
      ),
      gap(50),
      Text(
        titles[step],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      gap(),
      Text(
        subtitles[step],
        textAlign: TextAlign.center,
        style: const TextStyle(color: muted, height: 1.7),
      ),
      gap(36),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (i) => Container(
            margin: const EdgeInsets.all(4),
            width: i == step ? 25 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == step ? purple : const Color(0xFFDAD8F5),
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ),
      gap(36),
      FilledButton(
        onPressed: () {
          if (step < 2) {
            setState(() => step++);
          } else {
            go(context, const AuthPage(register: true));
          }
        },
        child: Text(step == 2 ? 'Get started' : 'Continue  →'),
      ),
    ]),
  );
}

class AuthPage extends StatefulWidget {
  final bool register;
  const AuthPage({super.key, this.register = false});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  bool hidden = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: pageBody([
      Align(
        alignment: Alignment.centerLeft,
        child: symbol(Icons.radar_rounded, size: 62),
      ),
      gap(28),
      heading(
        widget.register ? 'Join the good find.' : 'Welcome back.',
        widget.register
            ? 'Your community is here to help.'
            : 'Let’s bring you closer to what matters.',
      ),
      Form(
        key: form,
        child: Column(
          children: [
            if (widget.register) ...[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (s) =>
                    s == null || s.trim().isEmpty ? 'Enter your name' : null,
              ),
              gap(16),
            ],
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.alternate_email),
              ),
              validator: (s) =>
                  RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s ?? '')
                  ? null
                  : 'Enter a valid email address',
            ),
            gap(16),
            TextFormField(
              obscureText: hidden,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => hidden = !hidden),
                  icon: Icon(
                    hidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (s) =>
                  (s ?? '').length < 8 ? 'Use at least 8 characters' : null,
            ),
            gap(24),
            FilledButton(
              onPressed: () {
                if (form.currentState!.validate()) {
                  go(context, const PermissionsPage());
                }
              },
              child: Text(
                widget.register ? 'Create demo account' : 'Enter demo',
              ),
            ),
          ],
        ),
      ),
      gap(),
      const Text(
        'Prototype only • No account is created and credentials are not sent or saved.',
        textAlign: TextAlign.center,
        style: TextStyle(color: muted, fontSize: 12),
      ),
      gap(),
      OutlinedButton(
        onPressed: () => go(context, const PermissionsPage()),
        child: const Text('Explore the demo without an account'),
      ),
      TextButton(
        onPressed: () => go(context, AuthPage(register: !widget.register)),
        child: Text(
          widget.register
              ? 'Already a member? Log in'
              : 'New here? Create an account',
        ),
      ),
    ]),
  );
}

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: pageBody([
      Center(child: symbol(Icons.notifications_active_outlined, size: 120)),
      gap(32),
      heading(
        'A better chance to reconnect.',
        'Choose how ReFind can help. Device permissions will be requested when the live features are connected.',
      ),
      for (final row in [
        (
          Icons.location_on_outlined,
          'Location',
          'Find reports near the places you visit.',
        ),
        (
          Icons.photo_camera_outlined,
          'Camera & photos',
          'Show the details that make your item yours.',
        ),
        (
          Icons.notifications_none,
          'Notifications',
          'Hear when a possible match appears.',
        ),
      ]) ...[
        panel(
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(row.$1, color: purple),
            title: Text(row.$2),
            subtitle: Text(row.$3),
          ),
        ),
        gap(12),
      ],
      gap(),
      FilledButton(
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const Home()),
          (_) => false,
        ),
        child: const Text('Continue to demo'),
      ),
    ]),
  );
}

class Item {
  final String name, category, place, description;
  final bool lost, mine;
  bool recovered = false;
  Item(
    this.name,
    this.category,
    this.place,
    this.description, {
    this.lost = false,
    this.mine = false,
  });
  IconData get icon => switch (category) {
    'Electronics' => Icons.headphones_rounded,
    'Keys' => Icons.key_rounded,
    'Wallets' => Icons.account_balance_wallet_outlined,
    _ => Icons.backpack_outlined,
  };
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;
  String query = '', filter = 'All';
  final items = [
    Item(
      'Everyday backpack',
      'Bags',
      'Central Library',
      'Black backpack with a small front pocket. Found near the reading room.',
    ),
    Item(
      'Wireless headphones',
      'Electronics',
      'Riverside Park',
      'Cream headphones in a carrying case.',
      lost: true,
    ),
    Item(
      'House keys',
      'Keys',
      'Campus Café',
      'Three keys with a blue keyring.',
    ),
  ];
  Future<void> report(bool lost) async {
    final item = await Navigator.of(
      context,
    ).push<Item>(MaterialPageRoute(builder: (_) => ReportPage(lost: lost)));
    if (item != null && mounted) {
      setState(() {
        items.insert(0, item);
        tab = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = items
        .where(
          (i) =>
              (tab != 1 || i.mine) &&
              (filter == 'All' || (filter == 'Lost' ? i.lost : !i.lost)) &&
              '${i.name} ${i.place} ${i.category}'.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.radar, color: purple),
            SizedBox(width: 9),
            Text('ReFind', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'About this demo',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Your ReFind prototype'),
                content: const Text(
                  'Browse sample reports and create your own reports for this session. Authentication, maps, uploads, messaging and AI matching need live services before release.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.info_outline),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: tab == 3
          ? profile()
          : tab == 2
          ? mapPage()
          : pageBody([
              if (tab == 0) ...[
                const Text(
                  'A LITTLE HELP. A HAPPY REUNION.',
                  style: TextStyle(
                    color: purple,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                gap(10),
                heading(
                  'Find your things.\nKeep the good going.',
                  'Your community’s lost & found, all in one place.',
                ),
                Row(
                  children: [
                    Expanded(
                      child: action(
                        'I lost something',
                        'Let’s find it',
                        Icons.search_rounded,
                        const Color(0xFFFFECEE),
                        const Color(0xFFE3546B),
                        () => report(true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: action(
                        'I found something',
                        'Make their day',
                        Icons.favorite_border,
                        const Color(0xFFE2F7F0),
                        green,
                        () => report(false),
                      ),
                    ),
                  ],
                ),
                gap(24),
              ] else
                heading(
                  'Your reports',
                  'Keep track of the items you’ve shared this session.',
                ),
              TextField(
                onChanged: (s) => setState(() => query = s),
                decoration: const InputDecoration(
                  hintText: 'Search items, places or categories',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              gap(16),
              Row(
                children: ['All', 'Lost', 'Found']
                    .map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: filter == f,
                          onSelected: (_) => setState(() => filter = f),
                        ),
                      ),
                    )
                    .toList(),
              ),
              gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tab == 0 ? 'Around the community' : 'My items',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    'DEMO',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: muted,
                    ),
                  ),
                ],
              ),
              gap(12),
              if (visible.isEmpty)
                panel(
                  Column(
                    children: [
                      symbol(Icons.inventory_2_outlined),
                      gap(),
                      heading(
                        'No reports here yet.',
                        query.isEmpty
                            ? 'Your next small action could make someone’s day.'
                            : 'Try a different item or location.',
                      ),
                      FilledButton(
                        onPressed: () => report(true),
                        child: const Text('Report an item'),
                      ),
                    ],
                  ),
                ),
              for (final item in visible)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: itemCard(item),
                ),
              if (tab == 0) ...[
                gap(12),
                panel(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.auto_awesome, color: purple),
                      gap(12),
                      const Text(
                        'Looks familiar?',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'Explore how photo matching will help you find a possible match.',
                        style: TextStyle(color: muted),
                      ),
                      gap(12),
                      TextButton(
                        onPressed: () => go(context, const MatchingPage()),
                        child: const Text('Explore image matching  →'),
                      ),
                    ],
                  ),
                  color: const Color(0xFFEEECFF),
                ),
                gap(20),
                const Text(
                  'Be someone’s good news today.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted),
                ),
              ],
            ], key: ValueKey(tab)),
      floatingActionButton: tab == 1
          ? FloatingActionButton(
              onPressed: () => report(true),
              tooltip: 'Add report',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() {
          tab = i;
          query = '';
          filter = 'All';
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget action(
    String title,
    String subtitle,
    IconData icon,
    Color bg,
    Color fg,
    VoidCallback tap,
  ) => Material(
    color: bg,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: tap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: fg, size: 28),
            gap(20),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            gap(4),
            Text(subtitle, style: TextStyle(color: fg, fontSize: 12)),
          ],
        ),
      ),
    ),
  );
  Widget itemCard(Item item) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await goDetail(item);
        if (mounted) setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            symbol(
              item.icon,
              size: 74,
              color: item.lost ? const Color(0xFFBE855C) : purple,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.recovered
                        ? 'REUNITED'
                        : item.lost
                        ? 'LOST'
                        : 'FOUND',
                    style: TextStyle(
                      color: item.lost ? const Color(0xFFE3546B) : green,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  gap(4),
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  gap(3),
                  Text(
                    item.place,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: muted),
          ],
        ),
      ),
    ),
  );
  Future<void> goDetail(Item item) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => DetailPage(item: item)));
  Widget mapPage() => pageBody([
    heading(
      'Find your way back.',
      'Plan where to look with a location or a route.',
    ),
    const DemoMap(),
    gap(),
    const Text(
      'Illustrative map • No live location or distance data',
      style: TextStyle(color: muted, fontSize: 12),
    ),
    gap(),
    FilledButton(
      onPressed: () => go(context, const RoutePage()),
      child: const Text('Choose a route manually'),
    ),
    gap(16),
    OutlinedButton(
      onPressed: () => go(
        context,
        const InfoPage(
          title: 'Location services',
          icon: Icons.location_on_outlined,
          message:
              'GPS is not connected in this prototype. You can enter a location manually when reporting an item.',
        ),
      ),
      child: const Text('About GPS'),
    ),
    gap(24),
    heading('Places in the demo'),
    for (final i in items)
      ListTile(
        leading: const Icon(Icons.place_outlined, color: purple),
        title: Text(i.place),
        subtitle: Text(i.name),
        onTap: () => goDetail(i),
      ),
  ]);
  Widget profile() => pageBody([
    heading('Your little corner.'),
    gap(),
    panel(
      const Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Color(0xFFEEECFF),
            child: Text('RF', style: TextStyle(color: purple, fontSize: 24)),
          ),
          SizedBox(height: 15),
          Text(
            'ReFind Explorer',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          Text('Demo profile', style: TextStyle(color: muted)),
        ],
      ),
    ),
    gap(24),
    ListTile(
      leading: const Icon(Icons.article_outlined),
      title: const Text('My reports'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => setState(() => tab = 1),
    ),
    ListTile(
      leading: const Icon(Icons.settings_outlined),
      title: const Text('Settings'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => go(context, const SettingsPage()),
    ),
    ListTile(
      leading: const Icon(Icons.help_outline),
      title: const Text('Help & safety'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => go(
        context,
        const InfoPage(
          title: 'A safer reunion',
          icon: Icons.handshake_outlined,
          message:
              'Ask the owner to describe a detail that is not in the public report. Arrange a handover in a public place. Keep addresses, identity documents and private contact details out of public descriptions.',
        ),
      ),
    ),
    gap(24),
    const Text(
      'ReFind · Find it. Report it. Get it back.',
      textAlign: TextAlign.center,
      style: TextStyle(color: muted),
    ),
  ]);
}

class ReportPage extends StatefulWidget {
  final bool lost;
  const ReportPage({super.key, required this.lost});
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      description = TextEditingController(),
      location = TextEditingController();
  String category = 'Bags';
  int step = 0;
  @override
  void dispose() {
    name.dispose();
    description.dispose();
    location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.lost ? 'Report a lost item' : 'Report a found item'),
    ),
    body: pageBody([
      Row(
        children: List.generate(
          3,
          (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: i == step ? purple : const Color(0xFFEEECFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                ['1. Details', '2. Location', '3. Review'][i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: i == step ? Colors.white : purple,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
      gap(28),
      Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step == 0) ...[
              heading(
                'Tell us about it.',
                'The small details can make the difference.',
              ),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  hintText: 'e.g. Black everyday backpack',
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter an item name' : null,
              ),
              gap(),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Bags', 'Electronics', 'Keys', 'Wallets', 'Other']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => category = v!,
              ),
              gap(),
              TextFormField(
                controller: description,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Color, brand and distinguishing details…',
                ),
              ),
              gap(),
              panel(
                const Row(
                  children: [
                    Icon(Icons.add_a_photo_outlined, color: purple),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Photo uploads will be available when device integration is connected.',
                        style: TextStyle(color: muted),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (step == 1) ...[
              heading(
                widget.lost
                    ? 'Where did you last see it?'
                    : 'Where did you find it?',
                'Use a public place or a recognizable landmark.',
              ),
              TextFormField(
                controller: location,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter a location' : null,
              ),
              gap(),
              const DemoMap(),
              gap(12),
              const Text(
                'Illustrative map. Your typed location is saved with this report.',
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ],
            if (step == 2) ...[
              heading(
                'Ready to share?',
                'Check the details before adding your demo report.',
              ),
              panel(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.text,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    gap(),
                    Text('${widget.lost ? 'Lost' : 'Found'} · $category'),
                    gap(),
                    Text(location.text),
                    gap(),
                    Text(
                      description.text.isEmpty
                          ? 'No additional details'
                          : description.text,
                    ),
                  ],
                ),
              ),
              gap(),
              const Text(
                'Reports are stored in memory for this demo and reset when the app restarts. Nothing is published online.',
                style: TextStyle(color: muted),
              ),
            ],
            gap(28),
            FilledButton(
              onPressed: () {
                if (!form.currentState!.validate()) return;
                if (step < 2) {
                  setState(() => step++);
                } else {
                  Navigator.pop(
                    context,
                    Item(
                      name.text.trim(),
                      category,
                      location.text.trim(),
                      description.text.trim(),
                      lost: widget.lost,
                      mine: true,
                    ),
                  );
                }
              },
              child: Text(step == 2 ? 'Add demo report' : 'Continue  →'),
            ),
            if (step > 0)
              TextButton(
                onPressed: () => setState(() => step--),
                child: const Text('Back'),
              ),
          ],
        ),
      ),
    ]),
  );
}

class DetailPage extends StatefulWidget {
  final Item item;
  const DetailPage({super.key, required this.item});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final i = widget.item;
    return Scaffold(
      appBar: AppBar(title: const Text('Item details')),
      body: pageBody([
        Center(child: symbol(i.icon, size: 210)),
        gap(28),
        heading(
          i.name,
          '${i.recovered
              ? 'Reunited'
              : i.lost
              ? 'Lost'
              : 'Found'} · ${i.category}',
        ),
        panel(
          Row(
            children: [
              const Icon(Icons.place_outlined, color: purple),
              const SizedBox(width: 10),
              Expanded(child: Text(i.place)),
            ],
          ),
        ),
        gap(24),
        const Text(
          'The details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        gap(8),
        Text(
          i.description.isEmpty
              ? 'No additional details provided.'
              : i.description,
        ),
        gap(28),
        if (!i.mine)
          FilledButton(
            onPressed: () => go(
              context,
              const InfoPage(
                title: 'Start a conversation',
                icon: Icons.forum_outlined,
                message:
                    'Private messaging will connect you with the reporter once the backend is ready. This sample report has no real contact attached.',
              ),
            ),
            child: Text(
              i.lost ? 'I may have found this' : 'This could be mine',
            ),
          ),
        if (i.mine && !i.recovered)
          FilledButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Has this item been returned?'),
                  content: const Text(
                    'Confirm the reunion to close your demo report.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: const Text('Not yet'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(100, 44),
                      ),
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text('Yes, reunited'),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                setState(() => i.recovered = true);
                go(
                  context,
                  const InfoPage(
                    title: 'Back where it belongs.',
                    icon: Icons.check_circle_outline,
                    message:
                        'A happy ending, with a little help. Your report is now marked as reunited.',
                  ),
                );
              }
            },
            child: const Text('Mark as recovered'),
          ),
        gap(),
        const Text(
          'Verify ownership with a detail that is not publicly visible.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ]),
    );
  }
}

class DemoMap extends StatelessWidget {
  const DemoMap({super.key});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: SizedBox(
      height: 230,
      width: double.infinity,
      child: CustomPaint(
        painter: MapPainter(),
        child: const Stack(
          children: [
            Positioned(
              left: 40,
              top: 25,
              child: Text(
                'ILLUSTRATIVE MAP',
                style: TextStyle(
                  color: muted,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            Positioned(
              left: 65,
              top: 70,
              child: Icon(Icons.location_on, color: purple, size: 42),
            ),
            Positioned(
              right: 60,
              bottom: 50,
              child: Icon(Icons.location_on, color: green, size: 42),
            ),
          ],
        ),
      ),
    ),
  );
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFECEFF0),
    );
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = 12;
    for (double x = -size.height; x < size.width + size.height; x += 65) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
      canvas.drawLine(Offset(x, 0), Offset(x - size.height, size.height), p);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .55, 25, 70, 65),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFCBE9D5),
    );
    final path = Path()
      ..moveTo(85, 108)
      ..lineTo(120, 160)
      ..lineTo(size.width - 80, 160)
      ..lineTo(size.width - 80, 150);
    canvas.drawPath(
      path,
      Paint()
        ..color = purple
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});
  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final form = GlobalKey<FormState>();
  String start = '', end = '';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your route')),
    body: pageBody([
      heading(
        'Retrace your steps.',
        'Add the places between which you travelled.',
      ),
      Form(
        key: form,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Starting place'),
              onChanged: (v) => start = v,
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Enter a starting place' : null,
            ),
            gap(),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Destination'),
              onChanged: (v) => end = v,
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Enter a destination' : null,
            ),
          ],
        ),
      ),
      gap(),
      const DemoMap(),
      gap(),
      const Text(
        'Route preview is illustrative. Live directions and distances are not connected.',
        style: TextStyle(color: muted),
      ),
      gap(),
      FilledButton(
        onPressed: () {
          if (form.currentState!.validate()) {
            go(
              context,
              InfoPage(
                title: 'Your search route',
                icon: Icons.route_outlined,
                message:
                    'From $start to $end. Check community reports around these places. Live routing will be added with a map provider.',
              ),
            );
          }
        },
        child: const Text('Review route'),
      ),
    ]),
  );
}

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});
  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  bool loading = false, results = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Image matching')),
    body: pageBody([
      heading(
        'A familiar look.',
        'A preview of how photo-assisted discovery will work.',
      ),
      Center(child: symbol(Icons.image_search_rounded, size: 160)),
      gap(24),
      const Text(
        'Demo only: uses a sample backpack. No image is uploaded or analyzed.',
        textAlign: TextAlign.center,
        style: TextStyle(color: muted),
      ),
      gap(24),
      if (loading)
        const Center(child: CircularProgressIndicator())
      else
        FilledButton(
          onPressed: () async {
            setState(() {
              loading = true;
              results = false;
            });
            await Future<void>.delayed(const Duration(milliseconds: 700));
            if (mounted)
              setState(() {
                loading = false;
                results = true;
              });
          },
          child: const Text('Preview sample results'),
        ),
      if (results) ...[
        gap(28),
        heading('Sample result'),
        panel(
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.backpack_outlined,
              size: 42,
              color: purple,
            ),
            title: const Text('Everyday backpack'),
            subtitle: const Text('Central Library · Sample report'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => go(
              context,
              DetailPage(
                item: Item(
                  'Everyday backpack',
                  'Bags',
                  'Central Library',
                  'Black backpack with a small front pocket.',
                ),
              ),
            ),
          ),
        ),
      ],
    ]),
  );
}

class InfoPage extends StatelessWidget {
  final String title, message;
  final IconData icon;
  const InfoPage({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: pageBody([
      gap(40),
      Center(child: symbol(icon, size: 140)),
      gap(32),
      heading(title, message),
      gap(24),
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Got it'),
      ),
    ]),
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: pageBody([
      heading('Make yourself at home.'),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Match notification preference'),
        subtitle: const Text('Demo preference only; resets when you leave.'),
        value: notifications,
        onChanged: (v) => setState(() => notifications = v),
      ),
      const Divider(),
      const ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text('Appearance'),
        trailing: Text('Light'),
      ),
      const ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text('Language'),
        trailing: Text('English'),
      ),
      gap(28),
      panel(
        const Text(
          'ReFind 1.0 · UI prototype\nLive accounts, persistent storage, photos, GPS, messaging and image matching are planned integrations.',
        ),
      ),
    ]),
  );
}
