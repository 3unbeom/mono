import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppInfoSection extends StatelessWidget {
  final String? supportEmail;
  final String? termsUrl;
  final String? privacyUrl;
  final VoidCallback? onVersionLongPress;

  const AppInfoSection({
    super.key,
    this.supportEmail,
    this.termsUrl,
    this.privacyUrl,
    this.onVersionLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '앱 정보',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        // 버전 정보
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            return ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('버전 정보'),
              subtitle: snapshot.hasData
                  ? Text(
                      '${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                    )
                  : null,
              onLongPress: onVersionLongPress,
            );
          },
        ),
        // 문의하기
        if (supportEmail != null)
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('문의하기'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchEmail(supportEmail!),
          ),
        // 오픈소스 라이선스
        ListTile(
          leading: const Icon(Icons.article_outlined),
          title: const Text('오픈소스 라이선스'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () =>
              showLicensePage(context: context, useRootNavigator: true),
        ),
        // 이용약관
        if (termsUrl != null)
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('이용약관'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl(termsUrl!),
          ),
        // 개인정보 처리방침
        if (privacyUrl != null)
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('개인정보 처리방침'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl(privacyUrl!),
          ),
      ],
    );
  }

  Future<void> _launchEmail(String email) async {
    try {
      await launchUrl(Uri(scheme: 'mailto', path: email));
    } catch (e) {
      // 이메일 앱이 없는 경우에 대한 처리는 별도로 하지 않음
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      await launchUrlString(url);
    } catch (e) {
      // URL 열기 실패
    }
  }
}
