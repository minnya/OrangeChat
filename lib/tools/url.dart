// URLかどうかを判定する関数
import '../const/variables.dart';

bool isUrl(String input) {
  final uri = Uri.tryParse(input);
  if (uri == null) return false;
  // httpまたはhttpsスキームを持っている場合はURLとみなす
  return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
}

// パスをURLに直す関数
String? resolveUrl(String? url, String id) {
  if (url == null)
    return "https://api.dicebear.com/9.x/fun-emoji/png?seed=${id}&backgroundType=gradientLinear";
  if (isUrl(url))
    return url; // URL形式の場合
  else
    return ConstVariables.SUPABASE_HOSTNAME + url; // パス形式の場合
}
