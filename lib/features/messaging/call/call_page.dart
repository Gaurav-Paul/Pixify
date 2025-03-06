import 'package:flutter/material.dart';
import 'package:pixify/constant_values.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallPage extends StatelessWidget {
  final String uid;
  final String username;
  final String callID;
  const CallPage({
    super.key,
    required this.callID,
    required this.uid,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    // var x = ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
    //   ZegoUIKitSignalingPlugin(),
    // ]);
    return ZegoUIKitPrebuiltCall(
      appID: ConstantValues
          .zegoCloudAppID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: ConstantValues
          .zegoCloudAppSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: uid,
      userName: username,
      callID: callID,

      plugins: [
        ZegoUIKitSignalingPlugin(),
      ],
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
