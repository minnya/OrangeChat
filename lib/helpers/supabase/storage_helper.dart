import 'dart:io';
import 'dart:typed_data';

import 'package:orange_chat/const/variables.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class StorageHelper {
  final SupabaseClient client = Supabase.instance.client;
  final String uid = AuthHelper().getUID();

  Future<String> uploadFile({BuildContext? context, required File file}) async {

    Uint8List img = await imageCompress(imageFile: file);

    // 画像アップロード
    final String path = await client.storage.from('posts').uploadBinary(
      '$uid/${DateFormat('yyyyMMddHHmmss${DateTime.now().millisecond}').format(DateTime.now())}.jpeg',
      img,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );

    print("upload path: $path");
    final String signedUrl = await client
        .storage
        .from('posts')
        .createSignedUrl(
      path.replaceFirst("posts/", ""),
      31536000, // 1年間Urlを有効にする
      // transform: TransformOptions(
      //   width: 200,
      //   height: 200,
      // ),
    );
    print("signedUrl: $signedUrl");

    return signedUrl.replaceAll(ConstVariables.SUPABASE_HOSTNAME, "");
  }

  Future<Uint8List> imageCompress({required File imageFile})async{

    Uint8List img = imageFile.readAsBytesSync();

    var result = await FlutterImageCompress.compressWithList(
      img,
      quality: 40,
    );

    return result;
  }
}