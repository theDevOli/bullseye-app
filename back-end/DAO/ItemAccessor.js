import dotenv from "dotenv";

import helperFunctions from "../Utils/helperFunctions.js";
import Connectiondb from "../db/Conectiondb.js";
import Item from "../entity/Item.js";

dotenv.config({ path: "../.env" });

const host = process.env.MYSQL_HOST;
const port = process.env.MYSQL_PORT;
const user = process.env.MYSQL_USER;
const password = process.env.MYSQL_PASSWORD;
const database = process.env.MYSQL_DATABASE;

/**
 * Fetches all item entries from the database.
 * @returns {Promise<Array<Item>>} An array of Item objects representing all item entries.
 */
async function getAllItems() {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  let results = [];
  try {
    const [rows] = await pool.query(`SELECT * FROM item`);
    rows.forEach((row) => {
      const item = new Item(
        row.itemID,
        row.name,
        row.sku,
        row.description,
        row.category,
        parseFloat(row.weight),
        row.caseSize,
        parseFloat(row.costPrice),
        parseFloat(row.retailPrice),
        row.supplierID,
        row.active,
        row.notes
      );
      results.push(item);
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
 * Retrieves an item from the database by id.
 * @param {number} id - itemID.
 * @returns {Promise<Item | null>} An item object if found, otherwise null.
 */
async function getItemByID(id) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [row] = await pool.query(`SELECT * FROM item WHERE itemID =?`, [id]);
    if (row.length === 0) return null;
    const item = new Item(
      row[0]?.itemID,
      row[0]?.name,
      row[0]?.sku,
      row[0]?.description,
      row[0]?.category,
      parseFloat(row[0]?.weight),
      row[0]?.caseSize,
      parseFloat(row[0]?.costPrice),
      parseFloat(row[0]?.retailPrice),
      row[0]?.supplierID,
      row[0]?.active,
      row[0]?.notes
    );
    return item;
  } catch (e) {
    console.error(e);
    return null;
  } finally {
    conn.closePool();
  }
}

/**
 * Checks if an item exists in the database.
 * @param {Item} item - The item object.
 * @returns {Promise<boolean>} True if exists item, false if not found.
 */
async function itemExists(item) {
  try {
    const id = item?.getItemID();
    const databaseItem = await getItemByID(id);
    return databaseItem !== null;
  } catch (e) {
    console.error(e);
    return false;
  }
}

/**
 * Adds an item to the database.
 * @param {Item} item - The item object to be added.
 * @returns {Promise<boolean>} True if the item is added successfully, false otherwise.
 */
async function addItem(item) {
  const ok = await itemExists(item);
  if (ok) return false;

  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();

  const {
    itemID,
    name,
    sku,
    description,
    category,
    weight,
    caseSize,
    costPrice,
    retailPrice,
    supplierID,
    active,
    notes,
  } = helperFunctions.getItemData(item);

  try {
    const [result] = await pool.query(
      `INSERT INTO item (itemID, name, sku, description, category, weight, costPrice, retailPrice, supplierID, active, notes, caseSize) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)`,
      [
        itemID,
        name,
        sku,
        description,
        category,
        weight,
        costPrice,
        retailPrice,
        supplierID,
        active,
        notes,
        caseSize,
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
 * Updates an existing item in the database.
 * @param {Item} item - The updated item object.
 * @returns {Promise<boolean>} True if the item is updated successfully, false otherwise.
 */
async function updateItem(item) {
  const ok = await itemExists(item);
  if (!ok) return false;
  const databaseItem = await getItemByID(item.getItemID());

  const itemID = item.getItemID() ? item.getItemID() : databaseItem.getItemID();
  const name = item.getName() ? item.getName() : databaseItem.getName();
  const sku = item.getSku() ? item.getSku() : databaseItem.getSku();
  const description = item.getDescription()
    ? item.getDescription()
    : databaseItem.getDescription();
  const category = item.getCategory()
    ? item.getCategory()
    : databaseItem.getCategory();
  const weight = item.getWeight() ? item.getWeight() : databaseItem.getWeight();
  const costPrice = item.getCostPrice()
    ? item.getCostPrice()
    : databaseItem.getCostPrice();
  const retailPrice = item.getRetailPrice()
    ? item.getRetailPrice()
    : databaseItem.getRetailPrice();
  const supplierID = item.getSupplierID()
    ? item.getSupplierID()
    : databaseItem.getSupplierID();
  const notes = item.getNotes() ? item.getNotes() : databaseItem.getNotes();
  const caseSize = item.getCaseSize()
    ? item.getCaseSize()
    : databaseItem.getCaseSize();

  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [result] = await pool.query(
      `UPDATE item SET  name = ?,
                        sku = ?,
                        description = ?,
                        category = ?,
                        weight = ?,
                        costPrice = ?,
                        retailPrice = ?,
                        supplierID = ?,
                        notes = ?,
                        caseSize = ?
                  WHERE itemID = ?`,
      [
        name,
        sku,
        description,
        category,
        weight,
        costPrice,
        retailPrice,
        supplierID,
        notes,
        caseSize,
        itemID,
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
 * Checks if an item is active based on their item ID.
 * @param {Item} item - The item object.
 * @returns {Promise<boolean>} - Returns true if the item is active, false otherwise.
 */
async function isActive(item) {
  const ok = await itemExists(item);
  if (!ok) return false;

  const databaseItem = await getItemByID(item.getItemID());
  return databaseItem.getActive() === 1;
}

/**
 * Activates an item by updating their 'active' status to 1 in the database.
 * @param {Item} item - The item object.
 * @returns {Promise<boolean>} - Returns true if the item is successfully activated, false otherwise.
 */
async function activeItem(item) {
  const ok = await isActive(item);
  if (ok) return false;

  const databaseItem = await getItemByID(item.getItemID());
  const itemID = databaseItem.getItemID();

  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [result] = await pool.query(
      `UPDATE item SET  active = 1
                  WHERE itemID = ?`,
      [itemID]
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
 * Inactive an item by updating their 'active' status to 0 in the database.
 * @param {Item} item - The item object.
 * @returns {Promise<boolean>} - Returns true if the item is successfully activated, false otherwise.
 */
async function inactiveItem(item) {
  const ok = await isActive(item);
  if (!ok) return false;

  const databaseItem = await getItemByID(item.getItemID());
  const itemID = databaseItem.getItemID();

  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [result] = await pool.query(
      `UPDATE item SET  active = 0
                  WHERE itemID = ?`,
      [itemID]
    );
    return result.affectedRows === 1;
  } catch (e) {
    console.error(e);
    return false;
  } finally {
    conn.closePool();
  }
}

// const data = await getAllItems();
// const data = await getItemByID(1009);
const item = new Item(
  1009,
  "TEST",
  "60099",
  '24" x 24" piece of synthetic ice',
  "Sports Equipment",
  2.0,
  100,
  15.0,
  44.99,
  77777,
  0
);

const ia = {
  getAllItems,
  getItemByID,
  addItem,
  updateItem,
  activeItem,
  inactiveItem,
};

export default ia;
