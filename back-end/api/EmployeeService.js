import express from "express";

import errorMsg from "../../Utils/errorMsg.js";
import ea from "../DAO/EmployeeAccessor.js";
import helperFunctions from "../../Utils/helperFunctions.js";

const app = express();

app.use(express.json());

//===================API Routings============================

//---------------Valid Routes---------------------------

/**
 * GET /employees
 * @summary Get a list of all employees.
 * @response 200 - Successful response with employee data.
 * @response 500 - Internal server error.
 */
app.get("/employees", async (req, res) => {
  try {
    console.log(req);
    const data = await ea.getAllEmployees();
    res.status(200).json({ err: null, data: data });
  } catch (err) {
    res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
  }
});

/**
 * POST /employees/:employeeID
 * @summary Add a new employee.
 * @response 201 - Successfully added employee.
 * @response 400 - Bad request, invalid input.
 * @response 409 - Conflict, employee with the same ID already exists.
 * @response 500 - Internal server error.
 */
app.post("/employees/:employeeID(\\d+)", async (req, res) => {
  try {
    const employee = helperFunctions.instantiateEmployee(req);
    try {
      const hasEmployee = await ea.employeeExist(employee);
      console.log(hasEmployee);
      if (!hasEmployee) {
        await ea.addEmployee(employee);
        res.status(201).json({ err: null, data: true });
        return;
      }

      res.status(409).json({ err: errorMsg.CONFLICT_ADD_ERROR, data: null });
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (err) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

/**
 * PUT /employees/:employeeID
 * @summary Update an existing employee.
 * @response 200 - Successfully updated employee.
 * @response 400 - Bad request, invalid input.
 * @response 404 - Not found, employee with the specified ID does not exist.
 * @response 500 - Internal server error.
 */
app.put("/employees/:employeeID(\\d+)", async (req, res) => {
  try {
    const employee = helperFunctions.instantiateEmployee(req);

    try {
      const hasEmployee = await ea.employeeExist(employee);
      if (hasEmployee) {
        await ea.updateEmployee(employee);
        res.status(200).json({ err: null, data: true });
        return;
      }
      res.status(404).json({ err: errorMsg.NOT_FOUND_ERROR, data: null });
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (e) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

//---------------Special Routes---------------------------

/**
 * PUT /employees/inactive/:employeeID
 * @summary Toggle the active/inactive status of any employee.
 * @response 200 - Successfully updated employee.
 * @response 400 - Bad request, invalid input.
 * @response 404 - Not found, employee with the specified ID does not exist.
 * @response 500 - Internal server error.
 */
app.put("/employees/inactive/:employeeID(\\d+)", async (req, res) => {
  try {
    const employee = helperFunctions.instantiateEmployee(req);
    try {
      const hasEmployee = await ea.employeeExist(employee);
      if (hasEmployee) {
        await ea.activeInactiveEmployee(employee);
        res.status(200).json({ err: null, data: true });
        return;
      }
      res.status(404).json({ err: errorMsg.NOT_FOUND_ERROR, data: null });
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (e) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

/**
 * PUT /employees/lock/:employeeID
 * @summary Toggle the locked/unlocked status of any employee.
 * @response 200 - Successfully updated employee.
 * @response 400 - Bad request, invalid input.
 * @response 404 - Not found, employee with the specified ID does not exist.
 * @response 500 - Internal server error.
 */
app.put("/employees/lock/:employeeID(\\d+)", async (req, res) => {
  try {
    const employee = helperFunctions.instantiateEmployee(req);
    try {
      const hasEmployee = await ea.employeeExist(employee);
      if (hasEmployee) {
        await ea.lockEmployee(employee);
        res.status(200).json({ err: null, data: true });
        return;
      }
      res.status(404).json({ err: errorMsg.NOT_FOUND_ERROR, data: null });
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (e) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

//---------------Invalid Routes---------------------------
app.get("/employees/:employeeID(\\d+)", async (req, res) => {
  res.status(405).json({ err: errorMsg.SINGLE_ERROR, data: null });
});

/**
 * DELETE /employees/:employeeID
 * @summary Delete an employee by ID.
 * @response 405 - Method Not Allowed, deleting a single employee is not allowed.
 */
app.delete("/employees/:employeeID(\\d+)", async (req, res) => {
  res.status(405).json({ err: errorMsg.SINGLE_ERROR, data: null });
});

/**
 * DELETE /employees
 * @summary Delete all employees.
 * @response 405 - Method Not Allowed, bulk delete is not allowed.
 */
app.delete("/employees", async (req, res) => {
  res.status(405).json({ err: errorMsg.BULK_ERROR, data: null });
});

/**
 * POST /employees
 * @summary Add a new employee (bulk).
 * @response 405 - Method Not Allowed, bulk add is not allowed.
 */
app.post("/employees", async (req, res) => {
  res.status(405).json({ err: errorMsg.BULK_ERROR, data: null });
});

/**
 * PUT /employees
 * @summary Update an employee (bulk).
 * @response 405 - Method Not Allowed, bulk update is not allowed.
 */
app.put("/employees", async (req, res) => {
  res.status(405).json({ err: errorMsg.BULK_ERROR, data: null });
});

app.listen(8080, () => console.log("Server listening on port 8080"));
