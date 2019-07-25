import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/route/navigator_util.dart';

class CommonUtil {
  static launchUrl(context, String url) {
    if (url == null && url.length == 0) return;
    Uri parseUrl = Uri.parse(url);
    bool isImage = ImageUtil.isImage(parseUrl.toString());
    if (parseUrl.toString().endsWith("?raw=true")) {
      isImage =
          ImageUtil.isImage(parseUrl.toString().replaceAll("?raw=true", ""));
    }
    if (isImage) {
      NavigatorUtil.goPhotoView(context, '', url);
      return;
    }

    if (parseUrl != null &&
        parseUrl.host == "github.com" &&
        parseUrl.path.length > 0) {
      List<String> pathnames = TextUtil.split(parseUrl.path, '/');
      if (pathnames.length == 2) {
        //解析人
//        String userName = pathnames[1];
//        NavigatorUtil.goUserProfile(context, userName); //yuzo
      } else if (pathnames.length >= 3) {
        String userName = pathnames[1];
        String repoName = pathnames[2];
        //解析仓库
        if (pathnames.length == 3) {
          NavigatorUtil.goReposDetail(context, userName, repoName);
        } else {
          launchWebView(context, "", url);
        }
      }
    } else if (url != null && url.startsWith("http")) {
      launchWebView(context, "", url);
    }
  }

  static void launchWebView(BuildContext context, String title, String url) {
    if (url.startsWith("http")) {
      NavigatorUtil.goWebView(context, title, url);
    } else {
      NavigatorUtil.goWebView(
        context,
        title,
        Uri.dataFromString(url,
                mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
            .toString(),
      );
    }
  }
}
