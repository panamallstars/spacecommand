#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"app.spacecommand.SpaceCommand";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "LaunchColor" asset catalog color resource.
static NSString * const ACColorNameLaunchColor AC_SWIFT_PRIVATE = @"LaunchColor";

#undef AC_SWIFT_PRIVATE
