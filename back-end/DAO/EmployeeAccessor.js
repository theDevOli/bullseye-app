import dotenv from "dotenv";

import helperFunctions from "../../Utils/helperFunctions.js";
import Connectiondb from "../db/Conectiondb.js";
import Employee from "../entity/Employee.js";

dotenv.config({ path: "../../.env" });

const host = process.env.MYSQL_HOST;
const port = process.env.MYSQL_PORT;
const user = process.env.MYSQL_USER;
const password = process.env.MYSQL_PASSWORD;
const database = process.env.MYSQL_DATABASE;

/**
 * Fetches all employees from the database.
 * @returns {Promise<Array<Employee>>} An array of Employee objects.
 */
export async function getAllEmployees() {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [rows] = await pool.query("SELECT * FROM employee");
    let results = [];
    rows.forEach((row) => {
      const employee = new Employee(
        row.employeeID,
        row.Password,
        row.FirstName,
        row.LastName,
        row.Email,
        row.active,
        row.PositionID,
        row.siteID,
        row.locked,
        row.notes
      );
      console.log(row);
      results.push(employee);
    });
    // console.log(re)
    return results;
  } catch (e) {
    console.error(e);
  } finally {
    conn.closePool();
  }
}

/**
 * Retrieves an employee from the database by id.
 * @param {number} id - employeeID.
 * @returns {Promise<Employee>} An Employee object.
 */
export async function getEmployeeByID(id) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [row] = await pool.query(
      `SELECT * FROM employee WHERE employeeID=?`,
      [id]
    );
    const employee = new Employee(
      row[0].employeeID,
      row[0].Password,
      row[0].FirstName,
      row[0].LastName,
      row[0].Email,
      row[0].active,
      row[0].PositionID,
      row[0].siteID,
      row[0].locked,
      row[0].notes
    );
    return employee;
  } catch (e) {
    console.error(e);
  } finally {
    conn.closePool();
  }
}

/**
 * Checks if an employee exists in the database.
 * @param {Employee} employee - The employee object.
 * @returns {Promise<boolean>} True if exists employee, false if not found.
 */
export async function employeeExist(employee) {
  try {
    const id = employee.getEmployeeID();
    const databaseEmployee = await getEmployeeByID(id);
    return databaseEmployee !== undefined;
  } catch (e) {
    console.error(e);
  }
}

/**
 * Adds an employee to the database.
 * @param {Employee} employee - The employee object to be added.
 * @returns {Promise<boolean>} True if the employee is added successfully, false otherwise.
 */
export async function addEmployee(employee) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  const {
    employeeID,
    empPassword,
    firstName,
    lastName,
    email,
    active,
    positionID,
    siteID,
    locked,
    notes,
  } = helperFunctions.getEmployeeData(employee);
  try {
    const [result] = await pool.query(
      `INSERT INTO employee (employeeID, password, firstName, lastName, email, active, locked, siteID, positionID, notes) VALUES(?,?,?,?,?,?,?,?,?,?)`,
      [
        employeeID,
        empPassword,
        firstName,
        lastName,
        email,
        active,
        locked,
        siteID,
        positionID,
        notes,
      ]
    );
    console.log(result);
    return result.insertId !== undefined;
  } catch (e) {
    console.error(e);
  } finally {
    conn.closePool();
  }
}

/**
 * Toggles active/inactive status of an employee in the database.
 * @param {Employee} employee - The employee object.
 * @returns {Promise<boolean>} True if the status is updated successfully, false otherwise.
 */
async function activeInactiveEmployee(employee) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();

  const employeeID = employee.getEmployeeID();
  const databaseEmployee = await getEmployeeByID(employeeID);

  let newStatus = !Boolean(databaseEmployee.getActive());
  newStatus = Number(newStatus);

  try {
    const [result] = await pool.query(
      `UPDATE employee SET active = ? WHERE employeeID =?`,
      [newStatus, employeeID]
    );
    return result.affectedRows === 1;
  } catch (e) {
  } finally {
    conn.closePool();
  }
}

/**
 * Updates an existing employee in the database.
 * @param {Employee} employee - The updated employee object.
 * @returns {Promise<boolean>} True if the employee is updated successfully, false otherwise.
 */
async function updateEmployee(employee) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();

  if (
    !employee.getPassword() &&
    !employee.getFirstName() &&
    !employee.getLastName() &&
    !employee.getEmail() &&
    !employee.getSiteID() &&
    !employee.getPositionID() &&
    !employee.getNotes()
  )
    return;
  const employeeID = employee.getEmployeeID();
  const databaseEmployee = await getEmployeeByID(employeeID);

  const empPassword = employee.getPassword()
    ? employee.getPassword()
    : databaseEmployee.getPassword();
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
  const notes = employee.getNotes()
    ? employee.getNotes()
    : databaseEmployee.getNotes();

  try {
    const [result] = await pool.query(
      `UPDATE employee SET
      password = ?,
      firstName = ?,
      lastName = ?,
      email = ?,
      siteID = ?,
      positionID = ?,
      notes = ? WHERE employeeID =?`,
      [
        empPassword,
        firstName,
        lastName,
        email,
        siteID,
        positionID,
        notes,
        employeeID,
      ]
    );
    return result.affectedRows === 1;
  } catch (e) {
  } finally {
    conn.closePool();
  }
}

/**
 * Toggles locked/unlocked status of an employee in the database.
 * @param {Employee} employee - The employee object.
 * @returns {Promise<boolean>} True if the status is updated successfully, false otherwise.
 */
async function lockEmployee(employee) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();

  const employeeID = employee.getEmployeeID();
  const databaseEmployee = await getEmployeeByID(employeeID);

  let newStatus = !Boolean(databaseEmployee.getLocked());
  newStatus = Number(newStatus);

  try {
    const [result] = await pool.query(
      `UPDATE employee SET locked = ? WHERE employeeID =?`,
      [newStatus, employeeID]
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
  activeInactiveEmployee,
  updateEmployee,
  lockEmployee,
};

export default ea;
