import PropTypes from "prop-types";
import Header from "../Header/Header";
import Logout from "../Logout/Logout";
function Dashboard({ children }) {
  return (
    <div>
      <Header type="dashboard">Admin</Header>
      {/* <UserInfo /> */}
    </div>
  );
}

/**
 * Prop types for the Button component to enforce type checking.
 * @static
 */
Dashboard.propTypes = {
  //   children: PropTypes.node.isRequired,
  children: PropTypes.node,
};
export default Dashboard;
