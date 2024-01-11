import express from "express";

import errorMsg from "../../Utils/errorMsg.js";
import ea from "../DAO/EmployeeAccessor.js";

const app = express();

//===================API Routings============================
app.get("/employees", async (req, res) => {
  try {
    console.log(req);
    const data = await ea.getAllEmployees();
    res.status(200).json({ err: null, data: data });
  } catch (err) {
    res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
  }
});

app.listen(8080, () => console.log("Server listening on port 8080"));
