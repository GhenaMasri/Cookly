const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", (req, res) => {
  const { city, category_id } = req.query;

  if(!city) {
    res.status(400).send("City field is required");
    return;
  }

  let query = `
    SELECT 
      id, 
      name AS kitchen_name, 
      logo,
      contact,
      is_active,
      CASE 
        WHEN rates_num = 0 THEN 0 
        ELSE rate / rates_num 
      END AS rate
    FROM kitchen 
    WHERE city = ?
  `;

  const queryParams = [city];

  if (category_id) {
    query += " AND category_id = ?";
    queryParams.push(category_id);
  }

  pool.execute(query, queryParams, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ kitchens: results });
  });
});

module.exports = router;
