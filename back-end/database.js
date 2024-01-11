import { host, port, user, password, database } from "../Utils/processEnv.js";
import Connectiondb from "./db/Conectiondb.js";

const conn = new Connectiondb(host, port, user, password, database);
const pool = conn.getPool();

async function executeQuery() {
  try {
    const [rows] = await pool.query("select * from employee");
    console.log(rows);
    return rows;
  } catch (e) {
    console.error(e);
  } finally {
    // conn.closePool();
  }
}

executeQuery();

async function executeQueryById(id) {
  try {
    const [rows] = await pool.query(
      `select * from employee where  employeeID=?`,
      [id]
    );
    console.log(rows);
    return rows;
  } catch (e) {
    console.error(e);
  } finally {
    conn.closePool();
  }
}

async function createEmployee(
  employeeID,
  username,
  password,
  firstName,
  lastName,
  email,
  active,
  locked,
  siteID,
  positionID
) {
  try {
    const [result] = await pool.query(
      `INSERT INTO employee (employeeID, username, password, firstName, lastName, email, active, locked,siteID, positionID) VALUES(?,?,?,?,?,?,?,?,?,?)`,
      [
        employeeID,
        username,
        password,
        firstName,
        lastName,
        email,
        active,
        locked,
        siteID,
        positionID,
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
