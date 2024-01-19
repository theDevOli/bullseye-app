import Employee from "../entity/Employee.js";
import Audit from "../entity/Audit.js";
// import bcrypt from "bcrypt";

// const saltRounds = 10;

/**
 *Retrieves employee data in a structured format.
 * @param {Employee} employee - The employee object containing data.
 * @returns {Object} - An object containing employee data.
 */
function getEmployeeData(employee) {
  return {
    employeeID: employee.getEmployeeID(),
    username: employee.getUsername(),
    firstName: employee.getFirstName(),
    lastName: employee.getLastName(),
    email: employee.getEmail(),
    active: employee.getActive(),
    positionID: employee.getPositionID(),
    siteID: employee.getSiteID(),
    locked: employee.getLocked(),
    empPassword: employee.getPassword(),
    notes: employee.getNotes(),
  };
}

/**
 *Retrieves audit data in a structured format.
 * @param {Audit} audit - The audit object containing data.
 * @returns {Object} - An object containing audit data.
 */
function getAuditData(audit) {
  let date = new Date().toISOString().split("T")[0];
  return {
    auditID: audit.getAuditID(),
    transactionID: audit.getTransactionID(),
    type: audit.getType(),
    status: audit.getStatus(),
    // date: audit.getDate(),
    date,
    siteID: audit.getSiteID(),
    deliveryID: audit.getDeliveryID(),
    // employeeID:audit.getEmployeeID(),
    notes: audit.getNotes(),
  };
}
/**
 *
 * @param {*} req - The HTTP request object.
 * @returns {Employee} - An instance of the Employee class.
 */
function instantiateEmployee(req, hash) {
  const body = req.body;
  return new Employee(
    body.employeeID,
    body.username,
    body.firstName,
    body.lastName,
    body.email,
    body.active,
    body.positionID,
    body.siteID,
    body.locked,
    hash,
    body.notes
  );
}

/**
 * Creates an Employee object with invalid data, except for the id.
 *
 * @param {Object} req - The request object containing parameters.
 * @returns {Employee} - A dummy Employee object.
 */
function dummyEmployee(req) {
  const id = Number(req.params.employeeID);
  return new Employee(
    id,
    "username",
    "firstName",
    "lastName",
    "email",
    1,
    1,
    1
  );
}

const helperFunctions = {
  getEmployeeData,
  getAuditData,
  instantiateEmployee,
  dummyEmployee,
};

export default helperFunctions;
