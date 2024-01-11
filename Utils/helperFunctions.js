import Employee from "../back-end/entity/Employee";
function getEmployeeData(employee) {
  return {
    employeeID: employee.getEmployeeID(),
    empPassword: employee.getPassword(),
    firstName: employee.getFirstName(),
    lastName: employee.getLastName(),
    email: employee.getEmail(),
    active: employee.getActive(),
    positionID: employee.getPositionID(),
    siteID: employee.getSiteID(),
    locked: employee.getLocked(),
    notes: employee.getNotes(),
  };
}

function instantiateEmployee(req) {
  const body = req.body;
  return new Employee(
    body.employeeID,
    body.password,
    body.firstName,
    body.lastName,
    body.email,
    body.active,
    body.positionID,
    body.siteID,
    body.locked,
    body.notes
  );
}
const helperFunctions = { getEmployeeData, instantiateEmployee };

export default helperFunctions;
