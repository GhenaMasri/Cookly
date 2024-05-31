const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", (req, res) => {
  const { userId } = req.query;

  let query = `
    SELECT ci.*, mi.name, mi.image, sf.sub_quantity
    FROM cart_item ci
    INNER JOIN cart c ON ci.cart_id = c.id
    JOIN menu_item mi ON mi.id = ci.menu_item_id
    JOIN sub_food_quantity sf ON sf.id = ci.sub_quantity_id
    WHERE c.user_id = ?
  `;

  pool.execute(query, [userId], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      res.status(500).send("Internal server error");
      return;
    }
    res.status(200).send({ cartItems: results });
  });
});

module.exports = router;
