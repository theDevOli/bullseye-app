import Button from "../../component/Button/Button";
import Header from "../../component/Header/Header";
import Footer from "../../component/Footer/Footer";
import Error from "../../component/Error/Error";

import helperFunctions from "../../../Utils/helperFunctions";

import styles from "./Help.module.css";
import { NavLink } from "react-router-dom";
import { useEffect, useReducer } from "react";
import errorMsg from "../../../Utils/errorMsg";

const initialState = {
  name: "",
  newPassword: "",
  confirmPassword: "",
  error: null,
  hashPassword: "",
};

function reducer(state, action) {
  switch (action.type) {
    case "name":
      return { ...state, name: action.payload };
    case "newPassword":
      return { ...state, newPassword: action.payload };
    case "confirmPassword":
      return { ...state, confirmPassword: action.payload };
    case "missingOutput":
      return { ...state, error: action.payload };
    case "notMatched":
      return { ...state, error: action.payload };
    case "upperCase":
      return { ...state, error: action.payload };
    case "minLength":
      return { ...state, error: action.payload };
    case "special":
      return { ...state, error: action.payload };
    case "reset":
      return { ...state, hashPassword: state.payload };
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
  const [
    { name, newPassword, confirmPassword, error, hashPassword },
    dispatch,
  ] = useReducer(reducer, initialState);

  // useEffect(
  //   function () {
  //     async function changePassword() {
  //       const requestOptions = {
  //         method: "PUT",
  //         headers: {
  //           "Content-Type": "application/json",
  //         },
  //         body: JSON.stringify({
  //           password: hashPassword,
  //         }),
  //       };
  //       const res = await fetch(
  //         `127.0.0.1:8080/EmployeeService/employees/1`,
  //         requestOptions
  //       );
  //     }
  //   },
  //   [hashPassword]
  // );

  function resetPassword() {
    if (!name || !newPassword || !confirmPassword) {
      dispatch({
        type: "missingOutput",
        payload: errorMsg.MISSING_OUTPUT_ERROR,
      });
      return;
    }

    if (newPassword !== confirmPassword) {
      dispatch({
        type: "notMatched",
        payload: errorMsg.NOT_MATCHED_ERROR,
      });
      return;
    }

    if (!newPassword.match(/[A-Z]/)) {
      dispatch({
        type: "upperCase",
        payload: errorMsg.UPPERCASE_ERROR,
      });
    }

    if (!newPassword.length > 8) {
      dispatch({
        type: "minLength",
        payload: errorMsg.MIN_LEN_ERROR,
      });
    }

    if (!newPassword.match(/[!\@\#\$\%\^\&\*\(\)\-\+\=\?\<\>\.\,]/)) {
      dispatch({
        type: "special",
        payload: errorMsg.SPECIAL_ERROR,
      });
    }

    // if (!error) {
    //   const hash = helperFunctions.hashPassword(newPassword);
    //   dispatch({
    //     type: "reset",
    //     payload: hash,
    //   });
    // }
  }

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

      {error && <Error>{error}</Error>}

      <Footer />
    </div>
  );
}

export default Help;
