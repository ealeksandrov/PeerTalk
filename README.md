#Peer Talk

##Summary

App allows to chat between two iOS devices.

Build on Xcode 6.1 with iOS8 SDK. All types of devices are supported, iOS deployment target is 7.0.

Interface is based on UISplitViewController from iOS8, but falls back to simple UINavigationController for iOS7 iPhone support.

Roadmap:

* Messaging
  * special `sync` message to check `lastDelivered` and `lastRead` items
  * if `lastDelivered` is not actual last message - attempt to resend items
  * `delivered` and `read` notifications
  * `typing` notification (probably with `MCSessionSendDataUnreliable` mode)
* Improve p2p stability
  * attempt to reconnect if peer is lost during conversation
  * heartbeat protocol to monitor real peer connection status
* Replace `JSQMessagesViewController`
  * simple collection view with custom layout (+UIDynamics)
  * flexible textfield with keyboard awareness
* Experiments
  * try Realm instead of MagicalRecord
  * chat with OSX app
  * group chats


## Author

This app was created by Evgeny Aleksandrov.

License: MIT.
