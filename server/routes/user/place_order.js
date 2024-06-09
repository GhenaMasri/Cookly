const express = require("express");
const router = express.Router();
const pool = require("../../db");
const { admin } = require('../../index');

router.put("/", async (req, res) => {
    const { orderId, totalPrice, status, userNumber, kitchenNumber, city, address, notes, pickupTime, payment, delivery, userId} = req.body;

    if (!orderId || !totalPrice || !status || !userNumber || !kitchenNumber || !city || !payment || !userId) {
      return res.status(400).send("All fields are required");
    }
  
    const updateOrderQuery = `
      UPDATE orders
      SET 
        total_price = ?,
        status = ?,
        user_number = ?,
        kitchen_number = ?,
        city = ?,
        address = ?,
        notes = ?,
        pickup_time = ?,
        payment = ?,
        delivery = ?
      WHERE id = ?;
    `;
  
    try {
      await pool.promise().execute(updateOrderQuery, [totalPrice, status, userNumber, kitchenNumber, city, address, notes, pickupTime, payment, delivery, orderId]);
      const userTokenQuery = `
        SELECT fcm_token 
        FROM user u 
        INNER JOIN kitchen k ON u.id = k.user_id 
        WHERE k.id = ?
      `
      pool.query(userTokenQuery, [userId], (err, results) => {
        if (err) {
          return res.status(500).send('Server error');
        }
  
        const fcmToken = results[0].fcm_token;

        if (fcmToken) {
          const message = {
            notification: {
              title: 'New Order wwwwwww',
              body: 'You have received a new order',
            },
            token: fcmToken,
          };
  
          admin.messaging().send(message)
            .then((response) => {
              res.status(200).send('Order placed and notification sent');
            })
            .catch((error) => {
              console.error('Error sending message:', error);
              res.status(500).send('Order placed but failed to send notification');
            });
        } else {
          res.status(200).send('Order placed but no FCM token found');
        }
      });
    } catch (error) {
      console.error("Error inserting/updating order data:", error);
      res.status(500).send("Internal server error");
    }
});

module.exports = router;
