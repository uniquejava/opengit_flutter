import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/event_contract.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/presenter/event_presenter.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/event_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class EventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventPageState();
  }
}

class _EventPageState
    extends PullRefreshListState<EventBean, EventPresenter, IEventView>
    with AutomaticKeepAliveClientMixin
    implements IEventView {
  int _page = 1;
  String _userName = "";

  @override
  void initState() {
    super.initState();
    UserBean userBean = LoginManager.instance.getUserBean();
    if (userBean != null) {
      _userName = userBean.login ?? "";
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: buildBody(context),
    );
  }

  @override
  Widget getItemRow(EventBean item) {
    String desc = EventUtil.getEventDes(item);
    String type = EventUtil.getTypeDesc(item);
    String repoName;
    if (item.repo.name.isNotEmpty && item.repo.name.contains("/")) {
      repoName = item.repo.name.split("/")[1];
    }

    List<Widget> centerWidgets = [];
    Text title = Text.rich(
      TextSpan(children: [
        TextSpan(
            text: item.actor.login,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        TextSpan(text: " $type ", style: TextStyle(color: Colors.grey)),
        TextSpan(
            text: repoName ?? item.repo.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ]),
    );
    centerWidgets.add(title);
    if (desc != null && desc.isNotEmpty) {
      centerWidgets.add(Text(desc, style: TextStyle(color: Colors.black87)));
    }

    return new Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              //头像
              ClipOval(
                child:
                ImageUtil.getImageWidget(item.actor.avatarUrl ?? "", 36.0),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: centerWidgets,
                  ),
                ),
                flex: 1,
              ),
              Text(
                DateUtil.getNewsTimeStr(item.createdAt),
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
      ],
    );
  }

  @override
  getMoreData() {
    if (presenter != null) {
      _page++;
      presenter.getEventReceived(_userName, _page, true);
    }
  }

  @override
  EventPresenter initPresenter() {
    return new EventPresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      _page = 1;
      await presenter.getEventReceived(_userName, _page, false);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
