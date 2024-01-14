import PropTypes from "prop-types";
import { createContext, useContext, useEffect, useReducer } from "react";

const AuthContext = createContext();

const initialState = {
  user: null,
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
    case "logout":
      return { ...state, initialState };
    default:
      throw new Error("Invalid action type");
  }
}
function AuthProvider({ children }) {
  const [{ user, users, isLocked }, dispatch] = useReducer(
    reducer,
    initialState
  );

  function login(username, password) {}

  function logout() {
    dispatch({ type: "logout" });
  }

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

  return <AuthContext.Provider>{children}</AuthContext.Provider>;
}

function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined)
    throw new Error("AuthContext was used outside of the AuthProvider");
  return context;
}

export { AuthProvider, useAuth };
/**
 * Prop types for the AuthProvider component to enforce type checking.
 * @static
 */
AuthProvider.propTypes = {
  children: PropTypes.element,
};
