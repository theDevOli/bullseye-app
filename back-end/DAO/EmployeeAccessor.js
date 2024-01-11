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

// console.log(host, port, user, password, database);
// const host = "127.0.0.1";
// const port = "3306";
// const user = "root";
// const password = "doliveira";
// const database = "bullseyedb2024";

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

export async function employeeExist(employee) {
  try {
    const id = employee.getEmployeeID();
    console.log(id);
    const row = await getEmployeeByID(id);
    console.log(row);
    return row;
  } catch (e) {
    console.error(e);
  }
}

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

async function activeInactiveEmployee(employee) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();

  const employeeID = employee.getEmployeeID();
  console.log(employeeID);
  const databaseEmployee = await getEmployeeByID(employeeID);
  console.log(
    databaseEmployee.getActive(),
    databaseEmployee.getFirstName(),
    Object.keys(databaseEmployee).length
  );
  let newStatus = !Boolean(databaseEmployee.getActive());
  console.log(newStatus);
  newStatus = Number(newStatus);
  console.log(newStatus);

  try {
    const [result] = await pool.query(
      `UPDATE employee SET active = ? WHERE employeeID =?`,
      [newStatus, employeeID]
    );
    console.log(result);
    return result.affectedRows === 1;
  } catch (e) {
  } finally {
    conn.closePool();
  }
}

const ea = { getAllEmployees, getEmployeeByID, employeeExist, addEmployee };

export default ea;

const empTest = new Employee(
  4,
  "P@ssw0rd-",
  "Eduardo",
  "Concepcion",
  "econcepcion@bullseye.ca",
  1,
  3,
  0,
  1
);

// await getEmployeeByID(1);
// const res = await activeInactiveEmployee(empTest);
// console.log(res);
// // const emps = await getAllEmployees();
// // console.log(emps);

const res = await addEmployee(empTest);
console.log(res);
