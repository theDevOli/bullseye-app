import express from "express";
import cors from "cors";

import errorMsg from "../../Utils/errorMsg.js";
import ea from "../DAO/EmployeeAccessor.js";
import helperFunctions from "../../Utils/helperFunctions.js";

import bcrypt from "bcrypt";
const saltRounds = 10;

const app = express();

app.use(cors());

app.use(express.json());

//===================API Routings============================

//---------------Valid Routes---------------------------

/**
 * GET /EmployeeService/employees
 * @summary Get a list of all employees.
 * @response 200 - Successful response with employee data.
 * @response 500 - Internal server error.
 */
app.get("/EmployeeService/employees", async (req, res) => {
  try {
    const data = await ea.getAllEmployees();
    res.status(200).json({ err: null, data: data });
  } catch (err) {
    res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
  }
});

/**
 * POST EmployeeService/employees/:employeeID
 * @summary Add a new employee.
 * @response 201 - Successfully added employee.
 * @response 400 - Bad request, invalid input.
 * @response 409 - Conflict, employee with the same ID already exists.
 * @response 500 - Internal server error.
 */
app.post("/EmployeeService/employees/:employeeID(\\d+)", async (req, res) => {
  try {
    const employee = helperFunctions.instantiateEmployee(req);
    try {
      const ok = await ea.addEmployee(employee);
      if (ok) {
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
 * PUT /EmployeeService/employees/:employeeID
 * @summary Update an existing employee.
 * @response 200 - Successfully updated employee.
 * @response 400 - Bad request, invalid input.
 * @response 404 - Not found, employee with the specified ID does not exist.
 * @response 500 - Internal server error.
 */
app.put("/EmployeeService/employees/:employeeID(\\d+)", async (req, res) => {
  const hash = await hashPassword(req.body.password);
  try {
    const employee = helperFunctions.instantiateEmployee(req, hash);

    try {
      const ok = await ea.updateEmployee(employee);
      if (ok) {
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

// /**
//  * PUT /EmployeeService/employees/inactive/:employeeID
//  * @summary Toggle the active/inactive status of any employee.
//  * @response 200 - Successfully updated employee.
//  * @response 400 - Bad request, invalid input.
//  * @response 404 - Not found, employee with the specified ID does not exist.
//  * @response 500 - Internal server error.
//  */
// app.put(
//   "/EmployeeService/employees/inactive/:employeeID(\\d+)",
//   async (req, res) => {
//     const dummyEmployee = helperFunctions.dummyEmployee(req);

//     try {
//       try {
//         const ok = await ea.activeInactiveEmployee(dummyEmployee);

//         if (ok) {
//           res.status(200).json({ err: null, data: true });
//           return;
//         }
//         res.status(404).json({ err: errorMsg.NOT_FOUND_ERROR, data: null });
//       } catch (e) {
//         res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
//       }
//     } catch (e) {
//       res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
//     }
//   }
// );

app.put("/EmployeeService/inactive/:employeeID(\\d+)", async (req, res) => {
  const dummyEmployee = helperFunctions.dummyEmployee(req);

  try {
    try {
      const ok = await ea.inactiveEmployee(dummyEmployee);
      console.log(ok);
      if (ok) {
        res.status(200).json({ err: null, data: true });
        return;
      }
      res.status(409).json({ err: errorMsg.CONFLICT_ADD_ERROR, data: null });
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (e) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

app.put("/EmployeeService/active/:employeeID(\\d+)", async (req, res) => {
  const dummyEmployee = helperFunctions.dummyEmployee(req);

  try {
    try {
      const ok = await ea.activeEmployee(dummyEmployee);

      if (ok) {
        res.status(200).json({ err: null, data: true });
        return;
      }
      res.status(409).json({ err: errorMsg.CONFLICT_ADD_ERROR, data: null });
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (e) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

/**
 * PUT /EmployeeService/employees/lock/:employeeID
 * @summary Toggle the locked/unlocked status of any employee.
 * @response 200 - Successfully updated employee.
 * @response 400 - Bad request, invalid input.
 * @response 404 - Not found, employee with the specified ID does not exist.
 * @response 500 - Internal server error.
 */
app.put(
  "/EmployeeService/employees/lock/:employeeID(\\d+)",
  async (req, res) => {
    const dummyEmployee = helperFunctions.dummyEmployee(req);

    const ok = await ea.lockEmployee(dummyEmployee);
    try {
      try {
        if (ok) {
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
  }
);

app.put("/EmployeeService/lock/:employeeID(\\d+)", async (req, res) => {
  const dummyEmployee = helperFunctions.dummyEmployee(req);

  const ok = await ea.lockEmployee(dummyEmployee);
  try {
    try {
      if (ok) {
        res.status(200).json({ err: null, data: true });
        return;
      }
      res.status(409).json({ err: errorMsg.CONFLICT_ADD_ERROR, data: null });
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (e) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

app.put("/EmployeeService/unlock/:employeeID(\\d+)", async (req, res) => {
  const dummyEmployee = helperFunctions.dummyEmployee(req);

  const ok = await ea.unlockEmployee(dummyEmployee);
  try {
    try {
      if (ok) {
        res.status(200).json({ err: null, data: true });
        return;
      }
      res.status(409).json({ err: errorMsg.CONFLICT_ADD_ERROR, data: null });
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (e) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

//---------------Invalid Routes---------------------------
app.get("/EmployeeService/employees/:employeeID(\\d+)", async (req, res) => {
  // res.status(405).json({ err: errorMsg.SINGLE_ERROR, data: null });
  const id = Number(req.params.employeeID);
  try {
    const data = await ea.getEmployeeByID(id);

    if (!data) {
      res.status(404).json({ err: errorMsg.NOT_FOUND_ERROR, data: null });
      return;
    }
    res.status(200).json({ err: null, data: data });
  } catch (err) {
    res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
  }
});

/**
 * DELETE /employees/:employeeID
 * @summary Delete an employee by ID.
 * @response 405 - Method Not Allowed, deleting a single employee is not allowed.
 */
app.delete("/EmployeeService/employees/:employeeID(\\d+)", async (req, res) => {
  res.status(405).json({ err: errorMsg.SINGLE_ERROR, data: null });
});

/**
 * DELETE /employees
 * @summary Delete all employees.
 * @response 405 - Method Not Allowed, bulk delete is not allowed.
 */
app.delete("/EmployeeService/employees", async (req, res) => {
  res.status(405).json({ err: errorMsg.BULK_ERROR, data: null });
});

/**
 * POST /employees
 * @summary Add a new employee (bulk).
 * @response 405 - Method Not Allowed, bulk add is not allowed.
 */
app.post("/EmployeeService/employees", async (req, res) => {
  res.status(405).json({ err: errorMsg.BULK_ERROR, data: null });
});

/**
 * PUT /employees
 * @summary Update an employee (bulk).
 * @response 405 - Method Not Allowed, bulk update is not allowed.
 */
app.put("/EmployeeService/employees", async (req, res) => {
  res.status(405).json({ err: errorMsg.BULK_ERROR, data: null });
});

app.listen(8080, () => console.log("Server listening on port 8080"));

async function hashPassword(plainPassword) {
  try {
    const hash = await bcrypt.hash(plainPassword, saltRounds);
    console.log("Hashed Password:", hash);
    return hash;
  } catch (err) {
    console.error("Error hashing password:", err);
  }
}
