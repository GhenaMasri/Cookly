const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", (req, res) => {
  const { city, category } = req.query;

  let query = `
        SELECT kc.id, kc.category, COUNT(k.id) AS kitchen_count, kc.image
        FROM kitchen_category kc
        LEFT JOIN kitchen k ON kc.id = k.category_id
  `;

  const queryParams = [];
  const conditions = [];

  if (city) {
    conditions.push("k.city = ?");
    queryParams.push(city);
  }

  if (category) {
    conditions.push("k.category_id = ?");
    queryParams.push(category);
  }

  if (conditions.length > 0) {
    query += " WHERE " + conditions.join(" AND ");
  }

  query += ` GROUP BY kc.id, kc.category HAVING kitchen_count > 0;`;

  pool.execute(query, queryParams, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ kitchensCount: results });
  });
});

module.exports = router;
