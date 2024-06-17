const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { destination, id } = req.query;

  if (!destination) {
    return res.status(400).send("destination parameter is required");
  }

  let condition = 'AND is_read = 0';
  let params = [destination];

  if (destination === "chef" && id) {
    condition = ' AND kitchen_id = ?';
    params.push(id);
  } else if (destination === "user" && id) {
    condition = ' AND user_id = ?';
    params.push(id);
  } else if (destination === "delivery" && id) {
    condition = ' AND delivery_id = ?';
    params.push(id);
  } else if (destination !== "admin") {
    return res.status(400).send("Invalid destination or missing id");
  }

  const query = `SELECT COUNT(*) as count
    FROM \`notification\`
    WHERE destination = ? ${condition}`;

  pool.execute(query, params, async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ count: results[0].count });
  });
});

module.exports = router;
