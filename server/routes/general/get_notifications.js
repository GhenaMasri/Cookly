const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { id, destination } = req.query;

  if (!id || !destination) {
    return res.status(400).send("All parameters are required");
  }

  let condition = '';
  let params = [];

  if (destination === "chef") {
    condition = 'kitchen_id = ?';
    params = [id];
  } else if (destination === "user") {
    condition = 'user_id = ?';
    params = [id];
  } else {
    return res.status(400).send("Invalid destination");
  }

  const query = `SELECT id,
    message,
    is_read,
    TIME_FORMAT(created_at, '%H:%i') AS time,
    order_id
    FROM \`notification\`
    WHERE destination = ? AND ${condition}
    ORDER BY created_at DESC`;

  pool.execute(query, [destination, ...params], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ notifications: results });
  });
});

module.exports = router;
