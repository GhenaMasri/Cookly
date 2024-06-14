const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
    const userRoleQuery = `
    SELECT type, COUNT(*) AS count 
    FROM user 
    WHERE type IN ('chef', 'normal', 'delivery') 
    GROUP BY type
  `;

  pool.query(userRoleQuery, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      res.status(500).send('Internal server error');
      return;
    }

    const counts = {
      chef: 0,
      normal: 0,
      delivery: 0
    };

    results.forEach(row => {
      counts[row.type] = row.count;
    });

    res.status(200).send({counts: counts});
  });
});

module.exports = router;
