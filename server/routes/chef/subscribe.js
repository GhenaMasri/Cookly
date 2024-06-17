const express = require("express");
const router = express.Router();
const pool = require("../../db");
const admin = require('firebase-admin');

router.put("/", async (req, res) => {
  const { id } = req.query;
  const { type } = req.body;

  if (!id || !type) {
    return res.status(400).send("Missing required parameters");
  }

  let expiryDate;
  const currentDate = new Date();
  let query;

  try {
    query = `
      SELECT subscription_expiry, is_active
      FROM kitchen
      WHERE id = ?
    `;
    const [rows] = await pool.promise().execute(query, [id]);

    if (rows.length === 0) {
      return res.status(404).send("Kitchen not found");
    }

    const currentSubscription = rows[0];

    if (
      currentSubscription.is_active === 0 ||
      currentSubscription.subscription_expiry === null
    ) {
      // Case 1: First time subscription or expired subscription
      if (type === "monthly") {
        if (currentDate.getMonth() == 12) {
          expiryDate = new Date(currentDate.setMonth(1));
        } else {
          expiryDate = new Date(
            currentDate.setMonth(currentDate.getMonth() + 1)
          );
        }
      } else if (type === "annually") {
        expiryDate = new Date(
          currentDate.setFullYear(currentDate.getFullYear() + 1)
        );
      } else {
        return res.status(400).send("Invalid subscription type");
      }
    } else {
      // Case 2: Renewing an active subscription
      const previousExpiryDate = new Date(
        currentSubscription.subscription_expiry
      );

      if (type === "monthly") {
        if (currentDate.getMonth() == 12) {
          expiryDate = new Date(previousExpiryDate.setMonth(1));
        } else {
          expiryDate = new Date(
            previousExpiryDate.setMonth(previousExpiryDate.getMonth() + 1)
          );
        }
      } else if (type === "annually") {
        expiryDate = new Date(
          previousExpiryDate.setFullYear(previousExpiryDate.getFullYear() + 1)
        );
      } else {
        return res.status(400).send("Invalid subscription type");
      }
    }

    const isActive = 1;

    // Update the subscription details
    query = `
      UPDATE kitchen
      SET subscription_type = ?, subscription_expiry = ?, is_active = ?
      WHERE id = ?
    `;
    const [result] = await pool
      .promise()
      .execute(query, [type, expiryDate, isActive, id]);

    if (result.affectedRows === 0) {
      return res.status(404).send("Kitchen not found");
    }

    // send notification to admin
    const insertNotificationQuery = `
      INSERT INTO \`notification\` (kitchen_id, message, destination)
      VALUES (?, ?, ?);
    `;

    const notificationMessage = `New kitchen subscription. Press to see kitchen information`;
    const destColumn = "admin";
    await pool.promise().execute(insertNotificationQuery, [
        id,
        notificationMessage,
        destColumn,
    ]);
    ////////////////////////////////////////////////// NOTIFICATION //////////////////////////////////////////////////
    const getTokenQuery = "SELECT fcm_token FROM user WHERE type = ?";
    const [tokenResult] = await pool.promise().execute(getTokenQuery, [destColumn]);
    const registrationToken = tokenResult[0].fcm_token;
    const message = {
      notification: {
        title: 'Kitchen subscription',
        body: 'A kitchen subscriped successfully'
      },
      token: registrationToken
    };

    admin.messaging().send(message)
      .then((response) => {
        console.log('Successfully sent message:', response);
      })
      .catch((error) => {
        console.log('Error sending message:', error);
    });
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    res.status(200).send({ message: "Kitchen subscription updated successfully and notification sent" });
  } catch (error) {
    console.error("Error updating values:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
