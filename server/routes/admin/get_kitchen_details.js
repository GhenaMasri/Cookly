const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).send("id parameter is required");
  }

  try {
    const kitchenQuery = `
      SELECT 
        k.name AS kitchen_name,
        k.logo,
        k.description,
        k.city,
        k.street,
        k.contact,
        kc.category,
        k.order_system,
        k.special_orders,
        CASE 
            WHEN k.rates_num = 0 THEN 0 
            ELSE k.rate / k.rates_num 
        END AS rate,
        k.status,
        k.subscription_type,
        k.subscription_expiry,
        k.is_Active
      FROM kitchen k
      INNER JOIN kitchen_category kc ON kc.id = k.category_id
      WHERE k.id = ?`;

    const [kitchenResults] = await pool.promise().execute(kitchenQuery, [id]);

    if (kitchenResults.length === 0) {
      return res.status(404).send("Kitchen not found");
    }

    const KitchenInfo = kitchenResults[0];

    const kitchenItemsQuery = `
      SELECT 
        mi.name AS item_name,
        mi.image,
        mi.price,
        fq.quantity,
        fc.category
      FROM menu_item mi
      INNER JOIN food_quantity fq ON fq.id = mi.quantity_id
      INNER JOIN food_category fc ON fc.id = mi.category_id
      WHERE mi.kitchen_id = ?`;

    const [kitchenItemsResults] = await pool.promise().execute(kitchenItemsQuery, [id]);

    res.status(200).send({ kitchenInfo: KitchenInfo, kitchenItems: kitchenItemsResults });
  } catch (error) {
    console.error("Error executing query:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
