import express from "express";
import AuditService from "./AuditService.js";
import EmployeeService from "./EmployeeService.js";

const app = express();

// You can still use middleware or configure global settings here

// Import and use the combined API routes
app.use("/api", AuditService);
app.use("/api", EmployeeService);

// Your other routes or configurations can go here

app.listen(8080, () => console.log("Server listening on port 8080"));
