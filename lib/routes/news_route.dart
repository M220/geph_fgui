import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';

import '../providers/settings_provider.dart';
import '../rss/rss_manager.dart';

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
      Future.delayed(const Duration(seconds: 1), () {
        settingsRead.setNewNewsAvailable(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // TODO: The future should be the loading of the real, newer news.
      future: RssManager.getRss(context),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return newsListFromXmlString(snapshot.data!);
        } else {
          if (_settingsProvider.newsLoadedNumber == 0) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return newsListFromXmlString(_settingsProvider.rssFeed);
          }
        }
      },
    );
  }

  Widget newsListFromXmlString(String input) {
    final news = XmlDocument.parse(input).findAllElements("item").toList();
    if (news.length > _settingsProvider.newsLoadedNumber) {
      _settingsProvider.setRssFeed(input);
      _settingsProvider.setNewsLoadedNumber(news.length);
    }

    return ListView.builder(
      key: const PageStorageKey("News"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: news.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                style: _newsBodyStyle,
                children: buildNewsText(news[index]),
              ),
            ),
          ),
        );
      },
    );
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
