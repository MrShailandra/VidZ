import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class JitsiMeets{

  JoinMeeting(room,name,email,subject,audio,video) async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.meetingPasswordEnabled = true;
      featureFlag.inviteEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION; // Limit video resolution to 360p

      var options = JitsiMeetingOptions()
        ..room = room // Required, spaces will be trimmed
        ..subject = subject
        ..userDisplayName = name
        ..userEmail = email
        ..userAvatarURL = "https://img.icons8.com/officel/16/000000/change-user-male.png" // or .png
        ..audioOnly = true
        ..audioMuted = audio
        ..videoMuted = video
        ..featureFlag = featureFlag;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      print("Something Went Wrong");
    }
  }
}