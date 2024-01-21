import dotenv from "dotenv";

import helperFunctions from "../Utils/helperFunctions.js";
import Connectiondb from "../db/Conectiondb.js";
import Employee from "../entity/Employee.js";

dotenv.config({ path: "../.env" });

const host = process.env.MYSQL_HOST;
const port = process.env.MYSQL_PORT;
const user = process.env.MYSQL_USER;
const password = process.env.MYSQL_PASSWORD;
const database = process.env.MYSQL_DATABASE;

/**
 * Fetches all employees from the database.
 * @returns {Promise<Array<Employee>>} An array of Employee objects.
 */
async function getAllEmployees() {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  let results = [];
  try {
    const [rows] = await pool.query("SELECT * FROM employee");
    rows.forEach((row) => {
      const employee = new Employee(
        row.employeeID,
        row.username,
        row.FirstName,
        row.LastName,
        row.Email,
        row.active,
        row.PositionID,
        row.siteID,
        row.locked,
        row.Password,
        row.notes
      );
      results.push(employee);
    });
    return results;
  } catch (e) {
    console.error(e);
    return results;
  } finally {
    conn.closePool();
  }
}

/**
 * Retrieves an employee from the database by id.
 * @param {number} id - employeeID.
 * @returns {Promise<Audit | null>} An Employee object if found, otherwise null.
 */
async function getEmployeeByID(id) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [row] = await pool.query(
      `SELECT * FROM employee WHERE employeeID=?`,
      [id]
    );
    if (row.length === 0) return null;
    const employee = new Employee(
      row[0]?.employeeID,
      row[0]?.username,
      row[0]?.FirstName,
      row[0]?.LastName,
      row[0]?.Email,
      row[0]?.active,
      row[0]?.PositionID,
      row[0]?.siteID,
      row[0]?.locked,
      row[0]?.Password,
      row[0]?.notes
    );

    return employee;
  } catch (e) {
    console.error(e);
    return null;
  } finally {
    conn.closePool();
  }
}

/**
 * Checks if an employee exists in the database.
 * @param {Employee} employee - The employee object.
 * @returns {Promise<boolean>} True if exists employee, false if not found.
 */
async function employeeExist(employee) {
  try {
    const id = employee.getEmployeeID();
    const databaseEmployee = await getEmployeeByID(id);

    return databaseEmployee !== null;
  } catch (e) {
    console.error(e);
    return false;
  }
}

/**
 * Adds an employee to the database.
 * @param {Employee} employee - The employee object to be added.
 * @returns {Promise<boolean>} True if the employee is added successfully, false otherwise.
 */
async function addEmployee(employee) {
  const ok = await employeeExist(employee);
  if (ok) return false;
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  const {
    employeeID,
    username,
    firstName,
    lastName,
    email,
    active,
    positionID,
    siteID,
    locked,
    empPassword,
    notes,
  } = helperFunctions.getEmployeeData(employee);

  try {
    const [result] = await pool.query(
      `INSERT INTO employee (employeeID, username, FirstName, LastName, Email, active, PositionID, siteID, locked, Password) VALUES(?,?,?,?,?,?,?,?,?,?)`,
      [
        employeeID,
        username,
        firstName,
        lastName,
        email,
        active,
        positionID,
        siteID,
        locked,
        empPassword,
      ]
    );

    return result.insertId !== undefined;
  } catch (e) {
    console.error(e);
    return false;
  } finally {
    conn.closePool();
  }
}

/**
 * Checks if an employee is active based on their employee ID.
 * @param {Employee} employee - The employee object.
 * @returns {Promise<boolean>} - Returns true if the employee is active, false otherwise.
 */
async function isActive(employee) {
  const id = employee.getEmployeeID();
  const ok = employeeExist(employee);
  if (!ok) return false;
  const employeeDatabase = await getEmployeeByID(id);
  return 1 === employeeDatabase.getActive();
}

/**
 * Activates an employee by updating their 'active' status to 1 in the database.
 * @param {Employee} employee - The employee object.
 * @returns {Promise<boolean>} - Returns true if the employee is successfully activated, false otherwise.
 */
async function activeEmployee(employee) {
  const ok = await isActive(employee);
  if (!ok) return false;
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  const employeeID = employee.getEmployeeID();
  try {
    const [result] = await pool.query(
      `UPDATE employee SET active = ? WHERE employeeID =?`,
      [1, employeeID]
    );
    return result.affectedRows === 1;
  } catch (e) {
    console.error(e);
    return false;
  } finally {
    conn.closePool();
  }
}

/**
 * Deactivates an employee by updating their 'active' status to 0 in the database.
 * @param {Employee} employee - The employee object.
 * @returns {Promise<boolean>} - Returns true if the employee is successfully deactivated, false otherwise.
 */
async function inactiveEmployee(employee) {
  const ok = await isActive(employee);
  if (!ok) return false;
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  const employeeID = employee.getEmployeeID();
  try {
    const [result] = await pool.query(
      `UPDATE employee SET active = ? WHERE employeeID =?`,
      [0, employeeID]
    );
    return result.affectedRows === 1;
  } catch (e) {
    console.error(e);
    return false;
  } finally {
    conn.closePool();
  }
}

// /**
//  * Toggles active/inactive status of an employee in the database.
//  * @param {Employee} employee - The employee object.
//  * @returns {Promise<boolean>} True if the status is updated successfully, false otherwise.
//  */
// async function activeInactiveEmployee(employee) {
//   const ok = await employeeExist(employee);
//   if (!ok) return false;
//   const conn = new Connectiondb(host, port, user, password, database);
//   const pool = conn.getPool();

//   const employeeID = employee.getEmployeeID();
//   const databaseEmployee = await getEmployeeByID(employeeID);

//   let newStatus = !Boolean(databaseEmployee.getActive());
//   newStatus = Number(newStatus);

//   try {
//     const [result] = await pool.query(
//       `UPDATE employee SET active = ? WHERE employeeID =?`,
//       [newStatus, employeeID]
//     );
//     return result.affectedRows === 1;
//   } catch (e) {
//     console.error(e);
//     return false;
//   } finally {
//     conn.closePool();
//   }
// }

/**
 * Updates an existing employee in the database.
 * @param {Employee} employee - The updated employee object.
 * @returns {Promise<boolean>} True if the employee is updated successfully, false otherwise.
 */
async function updateEmployee(employee) {
  const ok = await employeeExist(employee);
  if (!ok) return false;

  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();

  // if (
  //   !employee.getUsername() &&
  //   !employee.getFirstName() &&
  //   !employee.getLastName() &&
  //   !employee.getEmail() &&
  //   !employee.getSiteID() &&
  //   !employee.getPositionID() &&
  //   !employee.getPassword()
  // )
  //   return;
  const employeeID = employee.getEmployeeID();
  const databaseEmployee = await getEmployeeByID(employeeID);

  const username = employee.getUsername()
    ? employee.getUsername()
    : databaseEmployee.getUsername();
  const firstName = employee.getFirstName()
    ? employee.getFirstName()
    : databaseEmployee.getFirstName();
  const lastName = employee.getLastName()
    ? employee.getLastName()
    : databaseEmployee.getLastName();
  const email = employee.getEmail()
    ? employee.getEmail()
    : databaseEmployee.getEmail();
  const siteID = employee.getSiteID()
    ? employee.getSiteID()
    : databaseEmployee.getSiteID();
  const positionID = employee.getPositionID()
    ? employee.getPositionID()
    : databaseEmployee.getPositionID();
  const empPassword = employee.getPassword()
    ? employee.getPassword()
    : databaseEmployee.getPassword();
  const notes = employee.getNotes()
    ? employee.getNotes()
    : databaseEmployee.getNotes();

  try {
    // employeeID, Password, username, FirstName, LastName, Email, active, PositionID, siteID, locked
    const [result] = await pool.query(
      `UPDATE employee SET username = ?, 
      FirstName = ?, 
      LastName = ?, 
      Email = ?, 
      siteID = ?, 
      PositionID = ?, 
      Password = ?,
      notes = ? 
      WHERE employeeID =?`,
      [
        username,
        firstName,
        lastName,
        email,
        siteID,
        positionID,
        empPassword,
        notes,
        employeeID,
      ]
    );
    return result.affectedRows === 1;
  } catch (e) {
    console.error(e);
    return false;
  } finally {
    conn.closePool();
  }
}

/**
 * Checks if an employee is locked based on their employee ID.
 * @param {Employee} employee - The Employee object to check for locked status.
 * @returns {Promise<boolean>} True if the employee is locked, false otherwise or if an error occurs.
 */
async function isLocked(employee) {
  const id = employee.getEmployeeID();
  const ok = employeeExist(employee);
  if (!ok) return false;
  const employeeDatabase = await getEmployeeByID(id);
  return 1 === employeeDatabase.getLocked();
}

/**
 * Locks an employee by updating their 'locked' status to 1 in the database.
 * @param {Employee} employee - The Employee object to be locked.
 * @returns {Promise<boolean>} True if the employee is successfully locked, false otherwise or if an error occurs.
 */
async function lockEmployee(employee) {
  const ok = await isLocked(employee);
  console.log(ok);
  if (ok) return false;
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  const employeeID = employee.getEmployeeID();
  try {
    const [result] = await pool.query(
      `UPDATE employee SET locked = ? WHERE employeeID =?`,
      [1, employeeID]
    );
    return result.affectedRows === 1;
  } catch (e) {
  } finally {
    conn.closePool();
  }
}

/**
 * Unlocks an employee by updating their 'locked' status to 0 in the database.
 * @param {Employee} employee - The Employee object to be unlocked.
 * @returns {Promise<boolean>} True if the employee is successfully unlocked, false otherwise or if an error occurs.
 */
async function unlockEmployee(employee) {
  const ok = await isLocked(employee);
  console.log(ok);
  if (ok) return false;
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  const employeeID = employee.getEmployeeID();
  try {
    const [result] = await pool.query(
      `UPDATE employee SET locked = ? WHERE employeeID =?`,
      [0, employeeID]
    );
    return result.affectedRows === 1;
  } catch (e) {
  } finally {
    conn.closePool();
  }
}

const ea = {
  getAllEmployees,
  getEmployeeByID,
  employeeExist,
  addEmployee,
  // activeInactiveEmployee,
  updateEmployee,
  activeEmployee,
  inactiveEmployee,
  lockEmployee,
  unlockEmployee,
  // changeEmployeePassword,
};

export default ea;
