/**
 * @module Audit
 */
export default class Audit {
  #auditID;
  #transactionID;
  #type;
  #status;
  #date;
  #siteID;
  #deliveryID;
  //   #employeeID;
  #notes;

  /**
   * Create an instance of the Audit class.
   * @param {number} auditID - The unique ID of the audit.
   * @param {number} transactionID - The ID of the related transaction.
   * @param {string} type - The type of audit.
   * @param {string} status - The status of the audit.
   * @param {date} date - The date of the audit.
   * @param {number} siteID - The ID of the related site.
   * @param {number|null} deliveryID - The ID of the related delivery (optional).
   * @param {string|null} notes - Additional notes related to the audit (optional).
   */
  constructor(
    auditID,
    transactionID,
    type,
    status,
    date,
    siteID,
    deliveryID = null,
    // employeeID = null,
    notes = null
  ) {
    this.#auditID = auditID;
    this.#transactionID = transactionID;
    this.#type = type;
    this.#status = status;
    this.#date = date;
    this.#siteID = siteID;
    this.#deliveryID = deliveryID;
    // this.#employeeID = employeeID;
    this.#notes = notes;
  }

  /**
   * Get the audit ID.
   * @returns {number} The audit ID.
   */
  getAuditID() {
    return this.#auditID;
  }

  /**
   * Get the transaction ID.
   * @returns {number} The transaction ID.
   */
  getTransactionID() {
    return this.#transactionID;
  }

  /**
   * Get the audit type.
   * @returns {string} The audit type.
   */
  getType() {
    return this.#type;
  }

  /**
   * Get the audit status.
   * @returns {string} The audit status.
   */
  getStatus() {
    return this.#status;
  }

  /**
   * Get the audit date.
   * @returns {string} The audit date.
   */
  getDate() {
    return this.#date;
  }

  /**
   * Get the site ID.
   * @returns {number} The site ID.
   */
  getSiteID() {
    return this.#siteID;
  }

  /**
   * Get the delivery ID (optional).
   * @returns {number|null} The delivery ID or null if not available.
   */
  getDeliveryID() {
    return this.#deliveryID;
  }

  //   getEmployeeID() {
  //     return this.#employeeID;
  //   }

  /**
   * Get additional notes related to the audit (optional).
   * @returns {string|null} Additional notes or null if not available.
   */
  getNotes() {
    return this.#notes;
  }

  /**
   * Write the audit data to a specified URL using a POST request.
   * @param {Audit} audit - The Audit object to be written.
   * @param {string} url - The URL to which the audit data should be written.
   * @returns {Promise<boolean>} A Promise that resolves to the response data.
   */
  static async writeAudit(audit, url) {
    const postData = {
      auditID: audit.getAuditID(),
      transactionID: audit.getTransactionID(),
      type: audit.getType(),
      status: audit.getStatus(),
      date: audit.getDate(),
      siteID: audit.getSiteID(),
      deliveryID: audit.getDeliveryID(),
      //   employeeID: audit.getEmployeeID(),
      notes: audit.getNotes(),
    };
    const requestOptions = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(postData),
    };
    const req = await fetch(url, requestOptions);
    const data = await req.json();
    return data;
  }

  /**
   * Converts the Audit object to a JSON object.
   * @returns {Object} A JSON object representing the employee's information.
   */
  toJSON() {
    return {
      auditID: this.#auditID,
      transactionID: this.#transactionID,
      type: this.#type,
      status: this.#status,
      date: this.#date,
      siteID: this.#siteID,
      deliveryID: this.#deliveryID,
      notes: this.#notes,
    };
  }
}
