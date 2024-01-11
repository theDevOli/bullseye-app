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

const helperFunctions = { getEmployeeData };

export default helperFunctions;
