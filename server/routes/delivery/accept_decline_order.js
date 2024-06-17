const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
  const { id } = req.query;
  const { status } = req.body;

  if (!id) {
    return res.status(400).send("id field is required");
  }

  try {
    // get kitchen id, delivery man name and user id
    const orderQuery = `SELECT
      o.user_id,
      o.kitchen_id,
      do.order_id,
      CONCAT(u.first_name, ' ', u.last_name) AS delivery_name
      FROM delivery_orders do
      INNER JOIN orders o ON o.id = do.order_id
      INNER JOIN delivery d ON d.id = do.delivery_id
      INNER JOIN user u ON u.id = d.user_id
      WHERE do.id = ?
    `;

    const [orderQueryResult] = await pool.promise().execute(orderQuery, [id]);
    if (orderQueryResult.rows === 0) {
      res.status(404).send("delivery order not found");
    } else {
      
      if (status === "accepted") {
        //////////////////////////////// accepted case ////////////////////////////////
        const query = "UPDATE delivery_orders SET status = ? WHERE id = ?";
        const [result] = await pool.promise().execute(query, [status, id]);
        if (result.affectedRows === 1) {
          //update assigned flag in orders table
          const updateAssigned = "UPDATE orders SET assigned = 2 WHERE id = ?";
          const [updateResult] = await pool.promise().execute(updateAssigned, [orderQueryResult[0].order_id]);
          if (updateResult.affectedRows === 1) {
            // send notification to chef 
            const insertNotificationQuery = `
              INSERT INTO \`notification\` (kitchen_id, order_id, message, destination)
              VALUES (?, ?, ?, ?);
            `;
            const notificationMessage = `${orderQueryResult[0].delivery_name} accepted the order. Will pick up the order soon`;
            const destColumn = "chef";
            await pool.promise().execute(insertNotificationQuery, [orderQueryResult[0].kitchen_id, orderQueryResult[0].order_id, notificationMessage, destColumn]);
            // send notification to user
            const insertUserNotificationQuery = `
                INSERT INTO \`notification\` (user_id, order_id, message, destination)
                VALUES (?, ?, ?, ?);
              `;
            const UserNotificationMessage = `${orderQueryResult[0].delivery_name} in his way to deliver your order`;
            const destinationColumn = "user";
            await pool.promise().execute(insertUserNotificationQuery, [orderQueryResult[0].user_id, orderQueryResult[0].order_id, UserNotificationMessage, destinationColumn]);
            res.status(200).send("delivery order accepted, assigned flag updated and notifications sent");
          }
        } else {
          res.status(404).send("delivery order not found");
        }
      } else {
        //////////////////////////////// declined case ////////////////////////////////
        const query = "DELETE FROM delivery_orders WHERE id = ?";
        const [result] = await pool.promise().execute(query, [id]);
        if (result.affectedRows === 1) {
          //update assigned flag in orders table
          const updateAssigned = "UPDATE orders SET assigned = 0 WHERE id = ?";
          const [updateResult] = await pool.promise().execute(updateAssigned, [orderQueryResult[0].order_id]);
          if (updateResult.affectedRows === 1) {
            // send notification to chef
            const insertNotificationQuery = `
              INSERT INTO \`notification\` (kitchen_id, order_id, message, destination)
              VALUES (?, ?, ?, ?);
            `;
            const notificationMessage = `${orderQueryResult[0].delivery_name} declined the order. Reassign it to another delivery`;
            const destColumn = "chef";
            await pool.promise().execute(insertNotificationQuery, [orderQueryResult[0].kitchen_id, orderQueryResult[0].order_id, notificationMessage, destColumn]);
            res.status(200).send("delivery order declined, assigned flag updated and notification sent");
          }
        } else {
          res.status(404).send("delivery order not found");
        }
      }
    }
  } catch (error) {
    console.error("Error updating notification:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
