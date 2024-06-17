const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.post("/", async (req, res) => {
  const { orderId, deliveryId } = req.body;

  const query = `
    INSERT INTO delivery_orders (order_id, delivery_id) 
    VALUES (?, ?)
  `;

  pool.execute(query, [orderId, deliveryId], (error, results, fields) => {
    if (error) {
      console.error("Error inserting values:", error);
      res.status(500).send("Error inserting values");
      return;
    }
    // update assigned flag in order table
    const updateAssigned = "UPDATE orders SET assigned = 1 WHERE id = ?";
    pool.execute(updateAssigned, [orderId], (error, results, fields) => {
      if (error) {
        console.error("Error updating values:", error);
        res.status(500).send("Error updating values");
        return;
      }

      // send notification to delivery
      const insertNotificationQuery = `
      INSERT INTO \`notification\` (delivery_id, order_id, message, destination)
      VALUES (?, ?, ?, ?);
    `;

      const notificationMessage = `New order assigned to you. See it in home page to accept or decline`;
      const destColumn = "delivery";

      pool.execute(insertNotificationQuery, [deliveryId, orderId, notificationMessage, destColumn], (error, results, fields) => {
        if (error) {
          console.error("Error sending notification:", error);
          res.status(500).send("Error sending notification");
          return;
        }
        res.status(200).send("Order assigned to delivery man, assigned flag updated and notification sent");
      });
    });
  });
});

module.exports = router;
