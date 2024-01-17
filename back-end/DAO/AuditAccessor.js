import dotenv from "dotenv";

import helperFunctions from "../../Utils/helperFunctions.js";
import Connectiondb from "../db/Conectiondb.js";
import Audit from "../entity/Audit.js";

dotenv.config({ path: "../../.env" });

const host = process.env.MYSQL_HOST;
const port = process.env.MYSQL_PORT;
const user = process.env.MYSQL_USER;
const password = process.env.MYSQL_PASSWORD;
const database = process.env.MYSQL_DATABASE;

/**
 * Fetches all audit entries from the database.
 * @returns {Promise<Array<Audit>>} An array of Audit objects representing all audit entries.
 */
export async function getAllAudit() {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  let results = [];
  try {
    const [rows] = await pool.query(`SELECT * FROM txnaudit`);
    // console.log(rows);
    rows.forEach((row) => {
      // console.log(row, "row");
      const audit = new Audit(
        row.txnAuditID,
        row.txnID,
        row.txnType,
        row.status,
        row.txnDate,
        row.SiteID,
        row.deliveryID,
        row.siteID,
        row.notes
      );
      // console.log(audit.getAuditID(), "audit");
      results.push(audit);
    });
    // console.log(results);
    return results;
  } catch (e) {
    console.error(e);
    return results;
  } finally {
    conn.closePool();
  }
}

/**
 *Retrieves an audit entry from the database by ID.
 * @param {number} id - The ID of the audit entry to retrieve.
 * @returns {Promise<Audit | null>} An Audit object if found, otherwise null.
 */
export async function getAuditByID(id) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [row] = await pool.query(
      `SELECT * FROM txnaudit WHERE txnAuditID =?`,
      [id]
    );
    if (row.length === 0) return null;
    const audit = new Audit(
      row[0].txnAuditID,
      row[0].txnID,
      row[0].txnType,
      row[0].status,
      row[0].txnDate,
      row[0].SiteID,
      row[0].deliveryID,
      row[0].siteID,
      row[0].notes
    );
    return audit;
  } catch (e) {
    console.error(e);
    return null;
  } finally {
    conn.closePool();
  }
}

/**
 * Checks if an audit entry exists in the database.
 * @param {Audit} audit - The Audit object to check for existence.
 * @returns {Promise<boolean>} True if the audit entry exists, false if not found or an error occurs.
 */
export async function auditExists(audit) {
  try {
    const id = audit.getAuditID();
    const databaseAudit = await getAuditByID(id);
    return databaseAudit !== null;
  } catch (e) {
    console.error(e);
    return false;
  }
}

/**
 * Adds an audit entry to the database.
 * @param {Audit} audit - The Audit object to be added.
 * @returns {Promise<boolean>} True if the audit entry is added successfully, false if it already exists or an error occurs.
 */
export async function addAudit(audit) {
  const ok = await auditExists(audit);
  if (ok) return false;

  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();

  try {
    const {
      auditID,
      transactionID,
      type,
      status,
      date,
      siteID,
      deliveryID,
      // employeeID,
      notes,
    } = helperFunctions.getAuditData(audit);
    const [result] = await pool.query(
      `INSERT INTO txnaudit (txnAuditID, txnID, txnType, status, txnDate, SiteID,deliveryID, notes) VALUES(?,?,?,?,?,?,?,?);`,
      [
        auditID,
        transactionID,
        type,
        status,
        date,
        siteID,
        deliveryID,
        // employeeID,
        notes,
      ]
    );
    return result.insertId !== undefined;
  } catch (e) {
    console.error(e);
  } finally {
    conn.closePool();
  }
}
// const data = await getAllAudit();
// console.log(data, "data");
const aa = { getAllAudit, getAuditByID, auditExists, addAudit };

export default aa;
