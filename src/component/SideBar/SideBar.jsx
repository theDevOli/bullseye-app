import PropTypes from "prop-types";
import Button from "../Button/Button";
import styles from "./SideBar.module.css";

function SideBar({ children }) {
  return (
    <div className={styles.sidebar}>
      {children.map((el) => (
        <Button type="logout" key={el}>
          {el}
        </Button>
      ))}
    </div>
  );
}

/**
 * Prop types for the SideBar component to enforce type checking.
 * @static
 */
SideBar.propTypes = {
  children: PropTypes.node,
};
export default SideBar;
