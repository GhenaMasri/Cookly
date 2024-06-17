const express = require("express");
const router = express.Router();
const pool = require("../../db");

const admin = require('firebase-admin');

router.put("/", async (req, res) => {
  const {orderId, totalPrice, status, userNumber, kitchenNumber, city, address, notes, pickupTime, payment, delivery, kitchenId, userId,} = req.body;

  if (!orderId || !totalPrice || !status || !userNumber || !kitchenNumber || !city || !payment || !kitchenId || !userId) {
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

  const insertNotificationQuery = `
      INSERT INTO \`notification\` (kitchen_id, order_id, message, destination)
      VALUES (?, ?, ?, ?);
    `;

  const notificationMessage = `New order placed. Press to see details`;
  const destColumn = "chef";

  try {
    // insert order data
    await pool
      .promise()
      .execute(updateOrderQuery, [
        totalPrice,
        status,
        userNumber,
        kitchenNumber,
        city,
        address,
        notes,
        pickupTime,
        payment,
        delivery,
        orderId,
      ]);

    // insert notification
    await pool
      .promise()
      .execute(insertNotificationQuery, [
        kitchenId,
        orderId,
        notificationMessage,
        destColumn,
    ]);

    // update user points
    let points;
    if (delivery === "yes") {
      points = (totalPrice - 10) / 5;
    } else {
      points = totalPrice / 5;
    }
    points = Math.floor(points);

    const [userRows] = await pool.promise().query("SELECT points FROM user WHERE id = ?", [userId]);

    if (userRows.length === 0) {
      return res.status(404).send("User not found");
    }

    const currentPoints = userRows[0].points;
    const newPoints = currentPoints + points;

    const updateUserPointsQuery = "UPDATE user SET points = ? WHERE id = ?";
    await pool.promise().execute(updateUserPointsQuery, [newPoints, userId]);

    ////////////////////////////////////////////////// NOTIFICATION //////////////////////////////////////////////////
    const getTokenQuery = "SELECT fcm_token FROM user WHERE id = (SELECT user_id FROM kitchen WHERE id = ?)";
    const [tokenResult] = await pool.promise().execute(getTokenQuery, [kitchenId]);
    const registrationToken = tokenResult[0].fcm_token;
    const message = {
      notification: {
        title: 'New order',
        body: 'A user placed a new order, check it in pending orders'
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
    res.status(200).send("Order placed successfully");
  } catch (error) {
    console.error("Error inserting/updating order data:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;