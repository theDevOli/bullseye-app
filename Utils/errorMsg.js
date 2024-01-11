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
 *@description Message: "Conflict: There are the same data on our system, please provide different data."
 */
const CONFLICT_ADD_ERROR =
  "Conflict: There are the same data on our system, please provide different data.";

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
 *Unsupported bulk operation error message
 *@type {string}
 *@constant
 *@description Message: "Not supported operation: Bulk operations are not supported."
 */
const BULK_ERROR =
  "Not supported operation: Bulk operations are not supported.";

/**
 *Unsupported single operation error message
 *@type {string}
 *@constant
 *@description Message: "Internal Server Error.  Please contact the network administrator"
 */
const SINGLE_ERROR =
  "Not supported operation: single operations are not supported";

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
  BULK_ERROR,
  SINGLE_ERROR,
};

export default errorMsg;
