const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
  const {
    orderId,
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
    kitchenId,
    userId,
  } = req.body;

  if (
    !orderId ||
    !totalPrice ||
    !status ||
    !userNumber ||
    !kitchenNumber ||
    !city ||
    !payment ||
    !kitchenId ||
    !userId
  ) {
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
      INSERT INTO \`notification\` (user_id, kitchen_id, order_id, message, destination)
      VALUES (?, ?, ?, ?, ?);
    `;

  const notificationMessage = `New order placed with ID: ${orderId}`;
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
        userId,
        kitchenId,
        orderId,
        notificationMessage,
        destColumn,
      ]);
    res.status(200).send("Order placed successfully");
  } catch (error) {
    console.error("Error inserting/updating order data:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;