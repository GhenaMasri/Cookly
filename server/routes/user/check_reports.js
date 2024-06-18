const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).send("userId is required");
  }

  try {
    const [rows] = await pool.promise().execute(
      `SELECT is_pend, pend_date FROM reports WHERE user_id = ?`,
      [userId]
    );

    if (rows.length === 0) {
      return res.status(200).send({ isPend: false });
    }

    const isPend = rows[0].is_pend;
    const pendDate = new Date(rows[0].pend_date);
    const currentDate = new Date();

    if (isPend === 0) {
        return res.status(200).send({ isPend: false });
    } else {
        if (pendDate < currentDate) {
            await pool.promise().execute(
                "DELETE FROM reports WHERE user_id = ?",
                [userId]
            );
            return res.status(200).send({ isPend: false });
        } else {
            return res.status(200).send({ isPend: true });
        }
    }
  } catch (error) {
    console.error("Error checking reporting:", error);
    return res.status(500).send("Internal server error");
  }
});

module.exports = router;
