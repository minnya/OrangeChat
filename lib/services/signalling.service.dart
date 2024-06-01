import 'dart:developer';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:math';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/commons/show_dialog.dart';
import '../helpers/supabase/user_model_helper.dart';
import '../views/call/call_screen.dart';

class SignallingService {
  SignallingService._();

  static final instance = SignallingService._();
  BuildContext? context;
  void init({required BuildContext context}) {
    this.context = context;
    // callsテーブル上でcalleeIdが自分のレコードが挿入されるかをリッスンする
    Supabase.instance.client
      .channel("onIncomingCall")
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: "public",
        table: "calls",
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'callee_id',
          value: AuthHelper().getUID(),
        ),
        callback: (data){
          // handle the incoming call
          final int callId = data.newRecord["id"];
          final String? callerId = data.newRecord['caller_id'];
          final Map<String, dynamic>? sdpOffer = data.newRecord['sdp_offer'];

          if (callerId != null && sdpOffer != null) {
            _handleIncomingCall(callId, callerId, sdpOffer);
          }
        }
    ).subscribe();
  }

  void _handleIncomingCall(int callId, String callerId, Map<String, dynamic> sdpOffer) async {
    UserModel userModel = await UserModelHelper().get(callerId);
    final bool result = await showOKCancelDialog(
      context: context!,
      message: "Calling from ${userModel.name}\nDo you want to join the call?",
    );

    if (result == true && context!.mounted) {
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (BuildContext context) => CallScreen(
            callId: callId,
            callerId: callerId,
            calleeId: AuthHelper().getUID(),
            offer: sdpOffer,
          ),
        ),
      );
    }
  }
}
