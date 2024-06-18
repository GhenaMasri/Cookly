const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.put("/", async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).send("userId field is required");
  }

  try {
    const reportsNumQuery = "SELECT reports_num FROM reports WHERE user_id = ?";
    const [reportsNumResult] = await pool.promise().execute(reportsNumQuery, [userId]);
    if (reportsNumResult.length > 0) {
      const reportsNum = reportsNumResult[0].reports_num + 1;
      let updateQuery, queryParams;

      if (reportsNum === 3) {
        const currentDate = new Date();
        const pendDate = new Date(currentDate.setDate(currentDate.getDate() + 3));
        const isPend = 1;
        updateQuery = "UPDATE reports SET reports_num = ?, pend_date = ?, is_pend = ? WHERE user_id = ?";
        queryParams = [reportsNum, pendDate, isPend, userId];
        // delete user points
        const pointsQuery = "UPDATE user SET points = ? WHERE id = ?";
        await pool.promise().execute(pointsQuery, [0, userId]);
      } else {
        updateQuery = "UPDATE reports SET reports_num = ? WHERE user_id = ?";
        queryParams = [reportsNum, userId];
      }

      await pool.promise().execute(updateQuery, queryParams);
      res.status(200).send("User reports updated successfully");
    } else {
      const query = "INSERT INTO reports (user_id, reports_num) VALUES (?, ?)";
      await pool.promise().execute(query, [userId, 1]);
      res.status(200).send("user inserted into reports table successfully");
    }
  } catch (error) {
    console.error("Error updating status:", error);
    res.status(500).send("Internal server error");
  }
});

module.exports = router;
