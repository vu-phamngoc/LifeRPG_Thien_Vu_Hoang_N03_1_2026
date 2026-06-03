const { onDocumentCreated } =
  require("firebase-functions/v2/firestore");

const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification =
onDocumentCreated(
  "notificationRequests/{notificationId}",
  async (event) => {
    const snap = event.data;

    if (!snap) {
      return;
    }

    const data = snap.data();

    const token = data.receiverToken;

    if (!token) {
      await snap.ref.update({
        status: "failed",
        error: "Missing token",
      });
      return;
    }

    const message = {
      token: token,
      notification: {
        title: data.title,
        body: data.body,
      },
      data: {
        type: data.type || "",
        taskId: data.taskId || "",
      },
    };

    try {
      await admin.messaging().send(message);

      await snap.ref.update({
        status: "sent",
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (error) {
      await snap.ref.update({
        status: "failed",
        error: error.message,
      });
    }
  },
);