import Button from "../../component/Button/Button";
import Header from "../../component/Header/Header";
import Footer from "../../component/Footer/Footer";

import styles from "./Help.module.css";
import { NavLink } from "react-router-dom";
import { useReducer, useState } from "react";

const initialState = {
  name: "",
  newPassword: "",
  confirmPassword: "",
  error: null,
};

function reducer(state, action) {
  switch (action.type) {
    case "name":
      return { ...state, name: action.payload };
    case "newPassword":
      return { ...state, newPassword: action.payload };
    case "confirmPassword":
      return { ...state, confirmPassword: action.payload };
    default:
      throw new Error("Unknown action");
  }
}
/**
 * Help page for user authentication.
 * @function
 * @returns {JSX.Element} - The rendered Help page.
 */
function Help() {
  const [{ name, newPassword, confirmPassword }, dispatch] = useReducer(
    reducer,
    initialState
  );
  function resetPassword() {}
  return (
    <div className={styles.help}>
      <Header type="loginHeader">Reset Password</Header>

      <div className={styles.helpBox}>
        <h1>Reset Password</h1>

        <div>
          <label htmlFor="userName">Username:</label>
          <input
            type="text"
            id="userName"
            onChange={(e) =>
              dispatch({ type: "name", payload: e.target.value })
            }
          />
        </div>

        <div>
          <label htmlFor="new-password">New password:</label>
          <input
            type="password"
            id="new-password"
            onChange={(e) =>
              dispatch({ type: "newPassword", payload: e.target.value })
            }
          />
        </div>
        <div>
          <label htmlFor="confirm-password">Confirm password:</label>
          <input
            type="password"
            id="confirm-password"
            onChange={(e) =>
              dispatch({ type: "confirmPassword", payload: e.target.value })
            }
          />
        </div>
        <div className={styles.btn}>
          <Button type="primary" onClick={resetPassword}>
            Reset
          </Button>
          <Button type="back">
            <NavLink to="/" className={styles.navLink}>
              Exit
            </NavLink>
          </Button>
        </div>
      </div>
      <Footer />
    </div>
  );
}

export default Help;
