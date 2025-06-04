/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onCall } = require("firebase-functions/v2/https"); // Ensure 'onCall' is imported
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin"); // Import Firebase Admin SDK

// Initialize the Firebase Admin SDK.
// This needs to be done once per Cloud Functions instance.
// If running in Cloud Functions, it automatically uses the credentials
// of the service account associated with the project.
admin.initializeApp();

// Export an HTTPS Callable Function to send notifications to users by role
// This function will be called directly from your Flutter app.
exports.sendNotificationToRole = onCall(async (request) => {
  // 1. Basic Authentication/Authorization Check (VERY IMPORTANT FOR ADMIN ACTIONS)
  // Ensure the caller is authenticated.
  if (!request.auth) {
    logger.warn(
      "Unauthorized call to sendNotificationToRole: No authentication context."
    );
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }

  // Optional: More robust admin role check (highly recommended for production)
  // const callingUserId = request.auth.uid;
  // const callingUserDoc = await admin.firestore().collection('users').doc(callingUserId).get();
  // if (!callingUserDoc.exists || callingUserDoc.data().role !== 'admin') {
  //   logger.warn(`User ${callingUserId} attempted to send notification without admin role.`);
  //   throw new functions.https.HttpsError(
  //     'permission-denied',
  //     'Only admin users can send notifications to roles.'
  //   );
  // }

  // 2. Extract data from the request
  const targetRole = request.data.targetRole; // e.g., 'student', 'teacher', 'parent'
  const notificationTitle = request.data.title;
  const notificationBody = request.data.body;
  const customData = request.data.data || {}; // Optional custom data

  // Basic validation
  if (!targetRole || !notificationTitle || !notificationBody) {
    logger.warn("Invalid arguments for sendNotificationToRole", {
      targetRole,
      notificationTitle,
      notificationBody,
    });
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: targetRole, title, or body."
    );
  }

  // 3. Retrieve FCM tokens for all users with the specified role from Firestore
  let fcmTokens = [];
  try {
    const usersSnapshot = await admin
      .firestore()
      .collection("users")
      .where("role", "==", targetRole)
      .get();

    if (usersSnapshot.empty) {
      logger.info(`No users found with role: ${targetRole}.`);
      return {
        success: true,
        message: `No users found with role: ${targetRole}. No notifications sent.`,
      };
    }

    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      if (userData.fcmToken) {
        fcmTokens.push(userData.fcmToken);
      } else {
        logger.info(`User ${doc.id} with role ${targetRole} has no FCM token.`);
      }
    });

    if (fcmTokens.length === 0) {
      logger.info(`No valid FCM tokens found for role: ${targetRole}.`);
      return {
        success: true,
        message: `No valid FCM tokens found for role: ${targetRole}. No notifications sent.`,
      };
    }

    // 4. Compose the FCM message payload
    const message = {
      notification: {
        title: notificationTitle,
        body: notificationBody,
      },
      data: {
        // Custom key-value pairs for app-specific handling
        target_role: targetRole,
        notification_type: "role_broadcast",
        ...customData, // Merge any custom data provided by the client
      },
    };

    // 5. Send the FCM message to all collected tokens
    // sendEachForMulticast can send to up to 500 tokens at once.
    // If you expect more, you'd need to batch `fcmTokens` into chunks of 500.
    // For simplicity, we'll assume less than 500 for now.
    const response = await admin.messaging().sendEachForMulticast({
      tokens: fcmTokens,
      notification: message.notification,
      data: message.data,
    });

    logger.info(
      `Successfully sent messages to ${response.successCount} devices. Failed to send to ${response.failureCount} devices.`,
      {
        successCount: response.successCount,
        failureCount: response.failureCount,
        errors: response.responses
          .filter((r) => !r.success)
          .map((r) => r.error),
      }
    );

    // You might want to handle failed tokens (e.g., remove them from Firestore)
    response.responses.forEach((resp, idx) => {
      if (!resp.success) {
        const failedToken = fcmTokens[idx];
        logger.warn(
          `Failed to send message to token ${failedToken}: ${resp.error}`
        );
        // Consider logic here to remove invalid/expired tokens from your 'users' collection
        // e.g., if (resp.error.code === 'messaging/invalid-registration-token' || resp.error.code === 'messaging/registration-token-not-registered') {
        //   admin.firestore().collection('users').where('fcmToken', '==', failedToken).get().then(snap => {
        //     snap.forEach(doc => doc.ref.update({ fcmToken: admin.firestore.FieldValue.delete() }));
        //   });
        // }
      }
    });

    return {
      success: true,
      message: `Notifications sent to ${response.successCount} devices.`,
      successCount: response.successCount,
      failureCount: response.failureCount,
    };
  } catch (error) {
    logger.error("Error sending notifications to role:", error);

    // Re-throw as an HttpsError for the client to handle
    if (error instanceof functions.https.HttpsError) {
      throw error;
    } else {
      throw new functions.https.HttpsError(
        "internal",
        "Failed to send notifications: " + error.message
      );
    }
  }
});
