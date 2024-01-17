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
  const hash = await bcrypt.hash(req.body.password, saltRounds);
  try {
    const employee = helperFunctions.instantiateEmployee(req, hash);
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
  const hash = await bcrypt.hash(req.body.password, saltRounds);
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

/**
 * PUT /EmployeeService/inactive/:employeeID(\\d+)
 * @summary Deactivate an employee by updating their 'active' status to 0 in the database.
 * @response 200 - Successfully deactivate employee.
 * @response 400 - Bad request, invalid input.
 * @response 409 - Conflict, employee already active.
 * @response 500 - Internal server error.
 */
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

/**
 * PUT /EmployeeService/active/:employeeID(\\d+)
 * @summary Activate an employee by updating their 'active' status to 1 in the database.
 * @response 200 - Successfully deactivate employee.
 * @response 400 - Bad request, invalid input.
 * @response 409 - Conflict, employee is already inactive.
 * @response 500 - Internal server error.
 */
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

/**
 * PUT /EmployeeService/lock/:employeeID(\\d+)
 * @summary Lock an employee by updating their 'locked' status to 1 in the database.
 * @response 200 - Successfully updated employee.
 * @response 400 - Bad request, invalid input.
 * @response 409 - Conflict, employee is already locked.
 * @response 500 - Internal server error.
 */
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

/**
 * PUT /EmployeeService/unlock/:employeeID(\\d+)
 * @summary Unlock an employee by updating their 'locked' status to 0 in the database. status to 1 in the database.
 * @response 200 - Successfully updated employee.
 * @response 400 - Bad request, invalid input.
 * @response 409 - Conflict, employee is already unlocked.
 * @response 500 - Internal server error.
 */
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

/**
 * POST /login
 * @summary Authenticate a user login.
 * @response 200 - Successfully authenticated user..
 * @response 401 - Unauthorized, incorrect password.
 * @response 440 - Timeout, user session has expired.
 * @response 500 - Internal server error.
 */
app.post("/login", async (req, res) => {
  const { enteredPassword, storedHashedPassword, isTimeOut } = req.body;

  if (isTimeOut) {
    res.status(440).json({ err: errorMsg.TIME_OUT_ERROR, data: null });
    return;
  }

  const ok = await bcrypt.compare(enteredPassword, storedHashedPassword);

  if (!ok) {
    res.status(401).json({ err: errorMsg.UNAUTHORIZED_ERROR, data: null });
    return;
  }
  res.status(200).json({ err: null, data: true });
});

//---------------Invalid Routes---------------------------
/**
 * GET /EmployeeService/employees/:employeeID(\\d+)
 * @summary Retrieve a single employee by ID.
 * @response 405 - Method Not Allowed, retrieving a single employee is not allowed.
 */
app.get("/EmployeeService/employees/:employeeID(\\d+)", async (req, res) => {
  res.status(405).json({ err: errorMsg.SINGLE_ERROR, data: null });
  // const id = Number(req.params.employeeID);
  // try {
  //   const data = await ea.getEmployeeByID(id);

  //   if (!data) {
  //     res.status(404).json({ err: errorMsg.NOT_FOUND_ERROR, data: null });
  //     return;
  //   }
  //   res.status(200).json({ err: null, data: data });
  // } catch (err) {
  //   res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
  // }
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
