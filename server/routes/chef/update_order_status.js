const express = require("express");
const router = express.Router();
const pool = require("../../db");

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
      INSERT INTO \`notification\` (user_id, kitchen_id, order_id, message, destination)
      VALUES (?, ?, ?, ?, ?);
    `;
    const notificationMessage = `Your order (${orderId}) status changed to ${status}`;
    const destColumn = "user";

    await pool.promise().execute(insertNotificationQuery, [userId, kitchenId, orderId, notificationMessage, destColumn]);

    res.status(200).send("Order updated successfully and notification sent");
  } catch (err) {
    console.error("Error:", err);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
