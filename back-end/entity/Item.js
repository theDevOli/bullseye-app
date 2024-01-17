/**
 * @module Audit
 */
export class Item {
  #itemID;
  #name;
  #sku;
  #description;
  #category;
  #weight;
  #caseSize;
  #costPrice;
  #retailPrice;
  #supplierID;
  #active;
  #notes;

  /**
   * Creates an instance of Item.
   * @param {string} itemID - Unique identifier for the item.
   * @param {string} name - Name of the item.
   * @param {string} sku - Stock Keeping Unit (SKU) for the item.
   * @param {string|null} description - Optional description of the item.
   * @param {string} category - Category to which the item belongs.
   * @param {number} weight - Weight of the item.
   * @param {number} caseSize - Size of the item's case.
   * @param {number} costPrice - Cost price of the item.
   * @param {number} retailPrice - Retail price of the item.
   * @param {string} supplierID - Unique identifier of the item's supplier.
   * @param {boolean} active - Indicates if the item is active or inactive.
   * @param {string|null} notes - Optional notes about the item.
   */
  constructor(
    itemID,
    name,
    sku,
    description = null,
    category,
    weight,
    caseSize,
    costPrice,
    retailPrice,
    supplierID,
    active,
    notes = null
  ) {
    this.#itemID = itemID;
    this.#name = name;
    this.#sku = sku;
    this.#description = description;
    this.#category = category;
    this.#weight = weight;
    this.#caseSize = caseSize;
    this.#costPrice = costPrice;
    this.#retailPrice = retailPrice;
    this.#supplierID = supplierID;
    this.#active = active;
    this.#notes = notes;
  }

  /**
   * Gets the item's unique identifier.
   * @returns {string} - The item's unique identifier.
   */
  getItemID() {
    return this.#itemID;
  }

  /**
   * Gets the name of the item.
   * @returns {string} - The name of the item.
   */
  getName() {
    return this.#name;
  }

  /**
   * Gets the Stock Keeping Unit (SKU) of the item.
   * @returns {string} - The Stock Keeping Unit (SKU) of the item.
   */
  getSku() {
    return this.#sku;
  }

  /**
   * Gets the optional description of the item.
   * @returns {string|null} - The optional description of the item.
   */
  getDescription() {
    return this.#description;
  }

  /**
   * Gets the category to which the item belongs.
   * @returns {string} - The category to which the item belongs.
   */
  getCategory() {
    return this.#category;
  }

  /**
   * Gets the weight of the item.
   * @returns {number} - The weight of the item.
   */
  getWeight() {
    return this.#weight;
  }

  /**
   * Gets the size of the item's case.
   * @returns {number} - The size of the item's case.
   */
  getCaseSize() {
    return this.#caseSize;
  }

  /**
   * Gets the cost price of the item.
   * @returns {number} - The cost price of the item.
   */
  getCostPrice() {
    return this.#costPrice;
  }

  /**
   * Gets the retail price of the item.
   * @returns {number} - The retail price of the item.
   */
  getRetailPrice() {
    return this.#retailPrice;
  }

  /**
   * Gets the unique identifier of the item's supplier.
   * @returns {string} - The unique identifier of the item's supplier.
   */
  getSupplierID() {
    return this.#supplierID;
  }

  /**
   * Indicates if the item is active or inactive.
   * @returns {boolean} - True if the item is active, false otherwise.
   */
  getActive() {
    return this.#active;
  }

  /**
   * Gets optional notes about the item.
   * @returns {string|null} - Optional notes about the item.
   */
  getNotes() {
    return this.#notes;
  }

  /**
   * Converts the Item object to a JSON object.
   * @returns {Object} A JSON object representing the Item's information.
   */
  toJSON() {
    return {
      itemID: this.#itemID,
      name: this.#name,
      sku: this.#sku,
      description: this.#description,
      category: this.#category,
      weight: this.#weight,
      caseSize: this.#caseSize,
      costPrice: this.#costPrice,
      retailPrice: this.#retailPrice,
      supplierID: this.#supplierID,
      active: this.#active,
      notes: this.#notes,
    };
  }
}
