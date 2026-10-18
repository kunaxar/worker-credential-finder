import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';
import 'ui.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Credential providers finder (prototype)', debugShowCheckedModeBanner: false, theme: buildTheme(),
        builder: (c, child) => Container(color: g100, child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: ClipRect(child: child)))),
        home: const Shell(),
      );
}

class AppState extends ChangeNotifier {
  int sel = 0;
  final ticked = <String>{};
  final shown = <int>{};
  void upd(VoidCallback f) { f(); notifyListeners(); }
}

final app = AppState();
Future<void> open(String u) => launchUrl(Uri.parse(u));

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: Column(children: [demoBanner(), Expanded(child: ListenableBuilder(listenable: app, builder: (c, _) => [FindTab(), CheckTab(), ResearchTab()][tab]))])),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab, onDestinationSelected: (i) => setState(() => tab = i), backgroundColor: Colors.white, indicatorColor: Colors.transparent, height: 64,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.search), selectedIcon: Icon(Icons.search, color: orange), label: 'Find'),
            NavigationDestination(icon: Icon(Icons.verified_user_outlined), selectedIcon: Icon(Icons.verified_user, color: orange), label: 'Check'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book, color: orange), label: 'Research'),
          ],
        ),
      );
}

Widget card(Widget child, {Color? bg}) => Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10), padding: const EdgeInsets.all(14), width: double.infinity,
      decoration: BoxDecoration(color: bg ?? Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: g200)), child: child);

Widget label(String t) => Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 6), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: g500, letterSpacing: 1)));

Widget linkBtn(Link l) => InkWell(onTap: () => open(l.url), child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [const Icon(Icons.open_in_new, size: 16, color: slate), const SizedBox(width: 8), Expanded(child: Text(l.label, style: const TextStyle(color: slate, fontSize: 14, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)))])));

class FindTab extends StatelessWidget {
  const FindTab({super.key});
  @override
  Widget build(BuildContext context) {
    final c = creds[app.sel];
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      const Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 4), child: Text('Who can issue it?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800))),
      const Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 12), child: Text('Pick a credential. See who issues it and where to find a real provider.', style: TextStyle(color: g500, fontSize: 15))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Wrap(spacing: 8, runSpacing: 8, children: [
        for (var i = 0; i < creds.length; i++) Pill('${creds[i].emoji}  ${creds[i].name}', on: app.sel == i, onTap: () => app.upd(() => app.sel = i)),
      ])),
      label('ISSUED BY'),
      card(Text(c.who, style: const TextStyle(fontSize: 15, height: 1.45))),
      label('HOW YOU GET IT'),
      card(Text(c.how, style: const TextStyle(fontSize: 15, height: 1.45))),
      label('WHERE TO LOOK (OFFICIAL SITE)'),
      card(Column(children: [for (final l in c.find) Align(alignment: Alignment.centerLeft, child: linkBtn(l))]), bg: g50),
      label('CHECK BEFORE YOU PAY'),
      for (final q in c.check) card(InkWell(
        onTap: () => app.upd(() => app.ticked.contains('${c.name}|$q') ? app.ticked.remove('${c.name}|$q') : app.ticked.add('${c.name}|$q')),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(app.ticked.contains('${c.name}|$q') ? Icons.check_circle : Icons.circle_outlined, color: app.ticked.contains('${c.name}|$q') ? green : g300),
          const SizedBox(width: 10),
          Expanded(child: Text(q, style: const TextStyle(fontSize: 14, height: 1.4))),
        ]),
      )),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(c.caution, style: const TextStyle(color: g500, fontSize: 12.5, height: 1.4))),
    ]);
  }
}

class CheckTab extends StatelessWidget {
  const CheckTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 4), child: Text('Spot a bad provider', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800))),
        const Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 12), child: Text('Things a provider might tell you. Tap one to see why it matters.', style: TextStyle(color: g500, fontSize: 15))),
        for (var i = 0; i < claims.length; i++) card(InkWell(
          onTap: () => app.upd(() => app.shown.contains(i) ? app.shown.remove(i) : app.shown.add(i)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(claims[i].said, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, height: 1.35)),
            if (app.shown.contains(i)) ...[
              const SizedBox(height: 8),
              Tag(claims[i].verdict, claims[i].flag ? amber : green, claims[i].flag ? amberBg : greenBg),
              const SizedBox(height: 6),
              Text(claims[i].why, style: const TextStyle(color: g600, fontSize: 13.5, height: 1.4)),
              if (claims[i].src != null) linkBtn(claims[i].src!),
            ] else
              const Padding(padding: EdgeInsets.only(top: 6), child: Text('Tap to see', style: TextStyle(color: slate, fontSize: 12.5, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]);
}

class ResearchTab extends StatelessWidget {
  const ResearchTab({super.key});
  Widget b(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontSize: 14, height: 1.45, color: g600)));
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Research and limits', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        const Text('WHAT THIS IS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: g500, letterSpacing: 1)),
        b('It points to the issuer\'s own locator or list for each credential. It does not keep its own list of providers, so nothing here goes out of date.'),
        b('Every issuer and rule shown comes from an official page. The sources are on each credential and below.'),
        const SizedBox(height: 8),
        const Text('WHAT IT DOES NOT DO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: g500, letterSpacing: 1)),
        b('No prices, no ratings, no booking, no enrolment, no live availability. Prices and dates are only on the provider\'s or issuer\'s site.'),
        b('It does not say which credential a job or state requires. Rules differ by state, project and employer.'),
        b('The "Spot a bad provider" examples are illustrative statements written for this prototype. They are not quotes from any real company.'),
        const SizedBox(height: 8),
        const Text('HYPOTHESES (NO WORKER INTERVIEWS)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: g500, letterSpacing: 1)),
        b('Workers search the web for a class and may land on sites that look official but are not. Pointing them to the issuer\'s locator first should reduce that. To be tested with real workers.'),
        const SizedBox(height: 8),
        const Text('SOURCES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: g500, letterSpacing: 1)),
        linkBtn(const Link('OSHA authorized online providers', 'https://www.osha.gov/training/outreach/training-providers')),
        linkBtn(const Link('OSHA Find a Trainer', 'https://www.osha.gov/training/outreach/find-a-trainer/')),
        linkBtn(const Link('OSHA 1910.178 (forklift)', 'https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.178')),
        linkBtn(const Link('NCCCO practical test sites', 'https://nccco.org/nccco/get-cco-certified/find-cco-test-locations/find-practical-test-sites')),
        linkBtn(const Link('AWS ATF locator', 'https://my.aws.org/certification/atflocator')),
        linkBtn(const Link('NCCER Find a Center', 'https://www.nccer.org/find-a-center/')),
        linkBtn(const Link('Apprenticeship.gov job finder', 'https://www.apprenticeship.gov/apprenticeship-job-finder')),
        linkBtn(const Link('CareerOneStop certification finder', 'https://www.careeronestop.org/Toolkit/Training/find-certifications.aspx')),
      ]);
}
