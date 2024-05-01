const express = require("express");
const router = express.Router();
const pool = require("./db");

router.post("/", (req, res) => {
  var { firstName, lastName, email, password, phone, userType } = req.body;
  
  if (userType == "Normal") {
    userType = "normal";
  } else {
    userType = "chef";
  }

  const emailQuery = "SELECT * FROM user WHERE email = ?";
  pool.execute(emailQuery, [email], (error, results, fields) => {
    if (results.length > 0) {
      res.status(400).send("Email already exists");
      return;
    } else {
      const phoneQuery = "SELECT * FROM user WHERE phone = ?";
      pool.execute(phoneQuery, [phone], (error, results, fields) => {
        if (results.length > 0) {
          res.status(400).send("Phone number already exists");
          return;
        } else {
          const query = 'INSERT INTO user (first_name, last_name, email, password, phone, type) VALUES (?, ?, ?, ?, ?, ?)';

          pool.execute(query, [firstName, lastName, email, password, phone, userType], (error, results, fields) => {
            if (error) {
              console.error('Error inserting values:', error);
              res.status(500).send('Error inserting values');
              return;
            }
            res.status(200).send('Sign up successful');
          });
        }
      });
    }
  });
});

module.exports = router;
