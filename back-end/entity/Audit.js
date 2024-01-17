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

  constructor(
    auditID,
    transactionID = null,
    type = null,
    status = null,
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
  getAuditID() {
    return this.#auditID;
  }

  getTransactionID() {
    return this.#transactionID;
  }

  getType() {
    return this.#type;
  }

  getStatus() {
    return this.#status;
  }

  getDate() {
    return this.#date;
  }

  getSieID() {
    return this.#siteID;
  }

  getDeliveryID() {
    return this.#deliveryID;
  }

  //   getEmployeeID() {
  //     return this.#employeeID;
  //   }

  getNotes() {
    return this.#notes;
  }

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
}
