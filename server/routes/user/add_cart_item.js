const express = require('express');
const router = express.Router();
const pool = require('../../db');

router.post('/', async (req, res) => {
  const { userId, menuItemId, quantity, price, notes } = req.body;

  if (!userId || !menuItemId || !quantity || !price) {
    return res.status(400).send("userId, menuItemId, and quantity are required");
  }

  try {
    const [cart] = await pool.promise().execute(
      'SELECT id FROM cart WHERE user_id = ? AND id NOT IN (SELECT cart_id FROM orders)',
      [userId]
    );

    let cartId;

    if (cart.length > 0) {
      cartId = cart[0].id;
    } else {
      const [newCart] = await pool.promise().execute(
        'INSERT INTO cart (user_id) VALUES (?)',
        [userId]
      );
      cartId = newCart.insertId;
    }

    await pool.promise().execute(
      'INSERT INTO cart_item (cart_id, menu_item_id, quantity, price, notes) VALUES (?, ?, ?, ?, ?)',
      [cartId, menuItemId, quantity, price, notes]
    );

    res.status(200).send("Menu item added to cart successfully");
  } catch (error) {
    console.error("Error adding menu item to cart:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
