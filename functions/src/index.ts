import {onCall} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendFcmToTokens = onCall(async (request) => {
  const {topic, title, message} = request.data;

  if (!topic) {
    throw new Error("No topic provided");
  }

  console.log("Sending to topic:", topic);

  await admin.messaging().send({
    topic: topic, // ⭐ KEY FIX
    notification: {
      title: title,
      body: message,
    },
  });

  return {success: true};
});


