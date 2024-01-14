import Employee from "../back-end/entity/Employee.js";

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
 *
 * @param {*} req - The HTTP request object.
 * @returns {Employee} - An instance of the Employee class.
 */
function instantiateEmployee(req) {
  const body = req.body;
  return new Employee(
    body.employeeID,
    body.username,
    body.FirstName,
    body.LastName,
    body.Email,
    body.active,
    body.PositionID,
    body.siteID,
    body.locked,
    body.password,
    body.notes
  );
}

/**
 * Makes an AJAX request with the specified HTTP method.
 * @param {string} url - URL for the API
 * @param {string} method - HTTP method (GET, POST, DELETE, PUT)
 * @param {object} [data] - Data to send in the request body for POST and PUT requests
 * @returns {Promise<string>} - Data from the API
 */
export async function ajaxRequest(url, method, data = null) {
  const options = {
    method: method,
    headers: {
      "Content-Type": "application/json",
    },
    body: data ? JSON.stringify(data) : null,
  };

  const response = await fetch(url, options);
  const result = await response.text();
  return result;
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
  instantiateEmployee,
  dummyEmployee,
  ajaxRequest,
};

export default helperFunctions;
