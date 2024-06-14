const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", (req, res) => {
  const { city } = req.query;

  if(!city) {
    res.status(400).send("City field is required");
    return;
  }

  let query = `
    SELECT 
      u.id AS user_id,
      d.id AS delivery_id,
      CONCAT(u.first_name, ' ', u.last_name) AS full_name,
      u.phone,
      d.status
    FROM user u
    INNER JOIN delivery d ON u.id = d.user_id
    WHERE d.city = ?
  `;

  pool.execute(query, [city], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ delivery: results });
  });
});

module.exports = router;
