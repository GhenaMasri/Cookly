const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { destination, id } = req.query;

  if (!destination) {
    return res.status(400).send("destination parameter is required");
  }

  let condition = '';
  let params = [destination];

  if (destination === "chef" && id) {
    condition = 'AND kitchen_id = ?';
    params.push(id);
  } else if (destination === "user" && id) {
    condition = 'AND user_id = ?';
    params.push(id);
  } else if (destination === "delivery" && id) {
    condition = 'AND delivery_id = ?';
    params.push(id);
  } else if (destination !== "admin") {
    return res.status(400).send("Invalid destination or missing id");
  }

  const query = `SELECT id,
    message,
    is_read,
    TIME_FORMAT(created_at, '%H:%i') AS time,
    order_id,
    kitchen_id
    FROM \`notification\`
    WHERE destination = ? ${condition}
    ORDER BY created_at DESC`;

  pool.execute(query, params, async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ notifications: results });
  });
});

module.exports = router;
