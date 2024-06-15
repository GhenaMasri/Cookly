const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { orderId } = req.query;

  if (!orderId) {
    return res.status(400).send("orderId parameter is required");
  }

  try {
    const orderQuery = `
      SELECT 
        o.total_price,
        o.status,
        o.user_number,
        o.address,
        o.delivery,
        o.notes AS order_notes,
        o.pickup_time,
        o.payment,
        TIME_FORMAT(o.created_at, '%H:%i') AS order_time,
        CONCAT(u.first_name, ' ', u.last_name) AS full_name,
        o.assigned
      FROM orders o
      INNER JOIN user u ON u.id = o.user_id
      WHERE o.id = ?`;

    const [orderResults] = await pool.promise().execute(orderQuery, [orderId]);

    if (orderResults.length === 0) {
      return res.status(404).send("Order not found");
    }

    const orderInfo = orderResults[0];

    const orderItemsQuery = `
      SELECT 
        oi.quantity,
        oi.price,
        oi.notes AS item_notes,
        sfq.sub_quantity,
        mi.name AS item_name
      FROM order_item oi
      INNER JOIN sub_food_quantity sfq ON sfq.id = oi.sub_quantity_id
      INNER JOIN menu_item mi ON mi.id = oi.menu_item_id
      WHERE oi.order_id = ?`;

    const [orderItemsResults] = await pool.promise().execute(orderItemsQuery, [orderId]);

    res.status(200).send({ orderInfo: orderInfo, orderItems: orderItemsResults });
  } catch (error) {
    console.error("Error executing query:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
