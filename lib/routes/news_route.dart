import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';

import '../providers/settings_provider.dart';

List<Card> _newsCards = [];

class NewsRoute extends StatefulWidget {
  const NewsRoute({super.key});

  @override
  State<NewsRoute> createState() => _NewsRouteState();
}

class _NewsRouteState extends State<NewsRoute> {
  // ignore: unused_field
  late AppLocalizations _localizations;
  late final _settingsProvider = context.watch<SettingsProvider>();
  TextStyle? _newsBodyStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context)!;
    _newsBodyStyle = Theme.of(context).textTheme.bodySmall;
    final settingsRead = context.read<SettingsProvider>();
    if (settingsRead.newNewsAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        settingsRead.setNewNewsAvailable(false);
      });
    }
    if (settingsRead.rssFeed != null) {
      setState(() {
        updateNewsListFromXml(settingsRead.rssFeed!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_settingsProvider.rssFeed == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_newsCards.isEmpty) {
      updateNewsListFromXml(_settingsProvider.rssFeed!);
    }
    return RefreshIndicator(
      onRefresh: () async {
        try {
          await _settingsProvider.fetchNewRss(context);
          setState(() {
            updateNewsListFromXml(_settingsProvider.rssFeed!);
          });
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(
                content:
                    Text("Error encountered when fetching the latest news. "
                        "Please try again later")));
        }
      },
      child: ListView(
        key: const PageStorageKey("News"),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: _newsCards,
      ),
    );
  }

  void updateNewsListFromXml(String input) {
    _newsCards = [];
    final news = XmlDocument.parse(input).findAllElements("item").toList();
    for (final item in news) {
      final card = Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              style: _newsBodyStyle,
              children: buildNewsText(item),
            ),
          ),
        ),
      );

      _newsCards.add(card);
    }
  }

  List<TextSpan> buildNewsText(XmlElement input) {
    final description = input.getElement("description")!.innerText;
    final htmlBody = parse(description).body!;
    final List<TextSpan> textSpanChildren = [];

    for (final child in htmlBody.children) {
      for (final node in child.nodes) {
        if (!node.hasChildNodes() && node.text!.isNotEmpty) {
          textSpanChildren.add(TextSpan(text: node.text));
        } else if (node.toString().contains("<html br>")) {
          textSpanChildren.add(const TextSpan(text: "\n"));
        } else if (node.toString().contains("<html span>")) {
          if (node.attributes.containsKey("class") &&
              node.attributes["class"] == "emoji") {
            textSpanChildren.add(TextSpan(text: node.text));
          }
        } else if (node.toString().contains("<html b>")) {
          textSpanChildren.add(TextSpan(
              text: node.text,
              style: const TextStyle(fontWeight: FontWeight.bold)));
        } else if (node.toString().contains("<html a>")) {
          textSpanChildren.add(
            TextSpan(
              text: node.text,
              style: const TextStyle(color: Colors.blueAccent),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (node.attributes["href"] == null) return;
                  final url = Uri.parse(node.attributes["href"]!);

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
            ),
          );
        }
      }
    }

    return textSpanChildren;
  }
}
