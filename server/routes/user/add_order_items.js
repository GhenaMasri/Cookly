const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.post("/", async (req, res) => {
  const { userId, kitchenId, cartId, cartItems } = req.body;

  if (!userId || !kitchenId || !cartId || !Array.isArray(cartItems) || cartItems.length === 0) {
    return res.status(400).send("Missing required fields or cartItems is empty");
  }

  try {
    const insertOrderQuery = `
        INSERT INTO orders (user_id, kitchen_id, cart_id)
        VALUES (?, ?, ?)
      `;

    pool.query(insertOrderQuery, [userId, kitchenId, cartId], (err, results) => {
        if (err) {
          console.error("Error executing query:", err.stack);
          return res.status(500).send("Error executing query");
        } else {
            const newOrderId = results.insertId;
            const insertOrderItemQuery = `
                INSERT INTO order_item (order_id, menu_item_id, quantity, price, notes, sub_quantity_id)
                VALUES ${cartItems.map(() => "(?, ?, ?, ?, ?, ?)").join(",")}
            `;
            const orderItemsData = cartItems.flatMap(item => [
                newOrderId,
                item.menu_item_id,
                item.quantity,
                item.price,
                item.notes,
                item.sub_quantity_id
            ]);

            pool.execute(insertOrderItemQuery, orderItemsData, (err, orderItemsResult) => {
                if (err) {
                    console.error("Error executing query:", err.stack);
                    return res.status(500).send("Error executing query");
                } else {
                    const cartItemIds = cartItems.map(item => item.id);
                    const deleteCartItemQuery = `
                        DELETE FROM cart_item WHERE id IN (?)
                    `;
                    pool.execute(deleteCartItemQuery, cartItemIds, (err, deleteCartItemsResult) => {
                        if (err) {
                            console.error("Error executing query:", err.stack);
                            return res.status(500).send("Error executing query");
                        }
                        res.status(200).send({ orderId: newOrderId });
                    });
                }
            });
        }
      }
    );
  } catch (err) {
    console.error("Error executing query:", err.stack);
    res.status(500).send("Error executing query");
  }
});

module.exports = router;
