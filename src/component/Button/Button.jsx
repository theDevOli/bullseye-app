import PropTypes from "prop-types";
import styles from "./Button.module.css";

/**
 * Reusable Button component.
 * @function
 * @param {Object} props - Component properties.
 * @param {ReactNode} props.children - The content inside the button.
 * @param {Function} props.onClick - The function to be called on button click.
 * @param {string} props.type - The type of button (e.g., "primary", "back").
 * @returns {JSX.Element} - The rendered Button component.
 */
function Button({ children, onClick, type }) {
  return (
    <button onClick={onClick} className={`${styles.btn} ${styles[type]}`}>
      {children}
    </button>
  );
}

/**
 * Prop types for the Button component to enforce type checking.
 * @static
 */
Button.propTypes = {
  children: PropTypes.node.isRequired,
  onClick: PropTypes.func,
  type: PropTypes.string.isRequired,
};

export default Button;
