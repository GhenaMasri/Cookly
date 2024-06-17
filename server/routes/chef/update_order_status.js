const express = require("express");
const router = express.Router();
const pool = require("../../db");
const admin = require('firebase-admin');

router.put("/", async (req, res) => {
  const { orderId } = req.query;
  const { status } = req.body;

  if (!orderId) {
    return res.status(400).send("orderId is required");
  }

  try {
    // Step 1: Retrieve user_id and kitchen_id from orders table
    const [orderRows] = await pool.promise().query("SELECT user_id, kitchen_id FROM orders WHERE id = ?", [orderId]);

    if (orderRows.length === 0) {
      return res.status(404).send("Order does not exist");
    }

    const userId = orderRows[0].user_id;
    const kitchenId = orderRows[0].kitchen_id;

    // Step 2: Update the order status
    const updateQuery = "UPDATE orders SET status = ? WHERE id = ?";
    const [updateResult] = await pool.promise().execute(updateQuery, [status, orderId]);

    if (updateResult.affectedRows === 0) {
      return res.status(404).send("Order does not exist");
    }

    // Step 3: Insert the notification
    const insertNotificationQuery = `
      INSERT INTO \`notification\` (user_id, order_id, message, destination)
      VALUES (?, ?, ?, ?);
    `;
    const notificationMessage = `Your order status changed to ${status}. Press to see details `;
    const destColumn = "user";

    await pool.promise().execute(insertNotificationQuery, [userId, orderId, notificationMessage, destColumn]);

    ////////////////////////////////////////////////// NOTIFICATION //////////////////////////////////////////////////
    const getTokenQuery = "SELECT fcm_token FROM user WHERE id = ?";
    const [tokenResult] = await pool.promise().execute(getTokenQuery, [userId]);
    const registrationToken = tokenResult[0].fcm_token;
    const message = {
      notification: {
        title: 'Order status update',
        body: `Your order status changed to ${status}`
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

    // send notification to chef when the status changed to delivered
    if (status == "delivered") {
      const insertChefNotificationQuery = `
      INSERT INTO \`notification\` (kitchen_id, order_id, message, destination)
      VALUES (?, ?, ?, ?);
    `;
      const chefNotificationMessage = `The order delivered successfully to the user! `;
      const chefDestColumn = "chef";

      await pool.promise().execute(insertChefNotificationQuery, [kitchenId, orderId, chefNotificationMessage, chefDestColumn]);

      ////////////////////////////////////////////////// NOTIFICATION //////////////////////////////////////////////////
      const getTokenQuery = "SELECT fcm_token FROM user WHERE id = (SELECT user_id FROM kitchen WHERE id = ?)";
      const [tokenResult] = await pool.promise().execute(getTokenQuery, [kitchenId]);
      const registrationToken = tokenResult[0].fcm_token;
      const message = {
        notification: {
          title: 'Order status update',
          body: chefNotificationMessage
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

      res.status(200).send("Order updated successfully and notifications sent");
    } 
    else {
      res.status(200).send("Order updated successfully and notification sent");
    }
  } catch (err) {
    console.error("Error:", err);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
