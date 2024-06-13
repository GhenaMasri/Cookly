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

  const query = `SELECT COUNT(*) as count
    FROM \`notification\`
    WHERE destination = ? AND is_read = 0 AND ${condition}`;

  pool.execute(query, [destination, ...params], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ count: results[0].count });
  });
});

module.exports = router;
