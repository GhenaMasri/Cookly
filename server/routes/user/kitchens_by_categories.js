const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", (req, res) => {
  const query = `
        SELECT kc.id, kc.category, COUNT(k.id) AS kitchen_count, kc.image
        FROM kitchen_category kc
        LEFT JOIN kitchen k ON kc.id = k.category_id
        GROUP BY kc.id, kc.category;
    `;

  pool.execute(query, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({"kitchensCount": results});
  });
});

module.exports = router;
