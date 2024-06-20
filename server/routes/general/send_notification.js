const express = require("express");
const router = express.Router();
const pool = require("../../db");
const admin = require('firebase-admin');

router.post("/", async (req, res) => {
  const { sendId, recId, recType } = req.query;
  const { text } = req.body;

  if (!sendId || !recId || !recType) {
    return res.status(400).send("sendId, recId, recType parameters are required");
  }

  // get user id based on receiver type (chef or normal)
  let receiverId;
  let senderName;

  if (recType === "chef") {
    const getUseridQuery = "SELECT user_id FROM kitchen WHERE id = ?";
    const [useridResult] = await pool.promise().execute(getUseridQuery, [recId]);
    receiverId = useridResult[0].user_id;
  } else { // recType === "user"
    receiverId = recId;
  }

  // get sender name based on receiver type 
  if (recType === "chef") { // then snder is user so get users name
    const getSenderNameQuery = "SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM user WHERE id = ?";
    const [senderNameResult] = await pool.promise().execute(getSenderNameQuery, [sendId]);
    senderName = senderNameResult[0].full_name;
  } else { // recType === "user" then sender is kitchen so get kitchens name
    const getSenderNameQuery = "SELECT name FROM kitchen WHERE id = ?";
    const [senderNameResult] = await pool.promise().execute(getSenderNameQuery, [sendId]);
    senderName = senderNameResult[0].name;
  }

  // get reciver token and send notification
  const getTokenQuery = "SELECT fcm_token FROM user WHERE id = ?";
  const [tokenResult] = await pool.promise().execute(getTokenQuery, [receiverId]);
  const registrationToken = tokenResult[0].fcm_token;

  const message = {
    notification: {
      title: `${senderName}`,
      body: `${text}`
    },
    token: registrationToken
  };

  admin.messaging().send(message)
    .then((response) => {
      console.log('Successfully sent message:', response);
      res.status(200).send('Notification sent');
    })
    .catch((error) => {
      console.log('Error sending message:', error);
      res.status(500).send('Notification failed');
  });
});

module.exports = router;