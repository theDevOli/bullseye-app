import PropTypes from "prop-types";
import Header from "../Header/Header";
import SideBar from "../SideBar/SideBar";
import DashboardContent from "../DashboardContent/DashboardContent";
import styles from "./Dashboard.module.css";
function Dashboard({ name, btns }) {
  return (
    <>
      <Header type="dashboard">{name}</Header>
      <div className={styles.dashboard}>
        <SideBar>{btns}</SideBar>
        <DashboardContent />
      </div>
    </>
  );
}

/**
 * Prop types for the Dashboard component to enforce type checking.
 * @static
 */
Dashboard.propTypes = {
  name: PropTypes.string.isRequired,
  btns: PropTypes.array.isRequired,
};
export default Dashboard;
