/**
 * @module errorMsg
 * @description This contains all error messages that will be displayed to the user.
 */

/**
 *Server error message
 *@type {string}
 *@constant
 *@description Message: "Internal Server Error.  Please contact the network administrator"
 */
const SERVER_ERROR =
  "Internal Server Error: Please contact the network administrator.";

/**
 *Conflict error message
 *@type {string}
 *@constant
 *@description Message: "Conflict: The resource you are trying to create/update already exists or does not exist. Please provide unique data or check the existing resource.
"
 */
const CONFLICT_ADD_ERROR =
  "Conflict: The resource you are trying to create already exists. Please check your data or use a different set of information.";

/**
 *Bad request error message
 *@type {string}
 *@constant
 *@description Message: "Bad Request: The request could not be understood or was missing required parameters."
 */
const BAD_REQUEST_ERROR =
  "Bad Request: The request could not be understood or was missing required parameters.";

/**
 *Not found error message
 *@type {string}
 *@constant
 *@description Message: "Not found: The request could not be found."
 */
const NOT_FOUND_ERROR = "Not found: The request could not be found.";

/**
 * Object that encapsulates all error messages provided by the module.
 * @type {object}
 * @exports errorMsg
 */
const errorMsg = {
  SERVER_ERROR,
  CONFLICT_ADD_ERROR,
  BAD_REQUEST_ERROR,
  NOT_FOUND_ERROR,
};

export default errorMsg;
