const express = require("express");
const pool = require("../../db");
const router = express.Router();

router.post("/", (req, res) => {
  const { userId, token } = req.body;

  pool.query(
    `UPDATE user 
    SET fcm_token = ? 
    WHERE id = ? `, [token, userId], (err) => {
      if (err) {
        return res.status(500).send("Server error");
      }
      res.status(200).send("Token saved");
    }
  );
});

module.exports = router;
