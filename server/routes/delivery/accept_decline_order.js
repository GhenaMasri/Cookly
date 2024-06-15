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
    if (status === "accepted") {
      const query = "UPDATE delivery_orders SET status = ? WHERE id = ?";
      const [result] = await pool.promise().execute(query, [status, id]);
      if (result.affectedRows === 1) {
        //update assigned flag in orders table
        const updateAssigned =
          "UPDATE orders SET assigned = 2 WHERE id = (SELECT order_id FROM delivery_orders WHERE id = ?)";
        const [updateResult] = await pool.promise().execute(updateAssigned, [id]);
        if (updateResult.affectedRows === 1) {
          res.status(200).send("delivery order accepted and assigned flag updated");
        }
      } else {
        res.status(404).send("delivery order not found");
      }
    } else {
      // get order id before deleting
      const getOrderQuery = "SELECT order_id FROM delivery_orders WHERE id = ?";
      const [rows] = await pool.promise().execute(getOrderQuery, [id]);

      if (rows.length === 0) {
        res.status(404).send("delivery order not found");
      } else {
        const query = "DELETE FROM delivery_orders WHERE id = ?";
        const [result] = await pool.promise().execute(query, [id]);
        if (result.affectedRows === 1) {
          //update assigned flag in orders table
          const orderId = rows[0].order_id;
          const updateAssigned = "UPDATE orders SET assigned = 0 WHERE id = ?";
          const [updateResult] = await pool.promise().execute(updateAssigned, [orderId]);
          if (updateResult.affectedRows === 1) {
            res.status(200).send("delivery order declined and assigned flag updated");
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
