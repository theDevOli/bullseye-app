import { NavLink } from "react-router-dom";
import { useReducer, useEffect } from "react";

import Button from "../../component/Button/Button";
import Footer from "../../component/Footer/Footer";
import Header from "../../component/Header/Header";

import styles from "./Login.module.css";

const initialState = {
  user: "",
  users: [],
  password: "",
  position: 0,
  isLocked: false,
  attempt: 3,
  isLogin: false,
  showError: false,
};

/**
 * This contains all logic related to the Login
 * @param {*} state - The current state.
 * @param {*} action - The dispatched action to update the state.
 */
function reducer(state, action) {
  if (state.isLocked) return state;
  switch (action.type) {
    case "getUsers":
      return { ...state, users: action.payload };
    case "typeUser":
      return { ...state, user: action.payload };
    case "typePassword":
      return { ...state, password: action.payload };
    case "login":
      console.log(state.users);
      const [currentUser] = state.users.filter(
        (u) => u.username === state.user
      );
      const isMatch =
        currentUser?.username === state.user &&
        currentUser?.password === state.password;
      return {
        ...state,
        attempt: state.attempt - 1,
        isLogin: isMatch,
        isLocked: state.attempt <= 1 ? true : false,
      };
    default:
      throw new Error("Invalid action type");
  }
}

/**
 * Login page for user authentication.
 * @function
 * @returns {JSX.Element} - The rendered Login page.
 */
function Login() {
  useEffect(function () {
    async function getUsers() {
      const res = await fetch("http://localhost:8080/employees");
      let data = await res.json();
      data = data.data;
      const users = data.map((user) => {
        return {
          username: user.email.split("@")[0],
          password: user.password,
          active: user.active,
          locked: user.locked,
        };
      });
      dispatch({ type: "getUsers", payload: users });
    }
    getUsers();
  }, []);
  const [{ isLocked }, dispatch] = useReducer(reducer, initialState);
  return (
    <div className={styles.login}>
      <Header type="loginHeader">Login</Header>

      <div className={styles.loginBox}>
        <h1>Login</h1>

        <div className={styles.input}>
          <label htmlFor="userName">Username:</label>
          <input
            type="text"
            id="userName"
            disabled={isLocked}
            onChange={(e) =>
              dispatch({ type: "typeUser", payload: e.target.value })
            }
          />
        </div>

        <div className={styles.input}>
          <label htmlFor="password">Password:</label>
          <input
            type="password"
            id="password"
            disabled={isLocked}
            onChange={(e) =>
              dispatch({ type: "typePassword", payload: e.target.value })
            }
          />
        </div>
        {/* <a>Forgot password?</a> */}
        <NavLink to="help">Forgot your password</NavLink>
        <Button
          disabled={isLocked}
          type="primary"
          onClick={() => dispatch({ type: "login" })}
        >
          Login
        </Button>
      </div>
      <Footer />
    </div>
  );
}

export default Login;
