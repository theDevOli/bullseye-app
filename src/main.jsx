import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { AuthProvider } from "./contexts/AuthContext.jsx";
import Dashboard from "./component/Dashboard/Dashboard.jsx";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <AuthProvider>
      {/* <App /> */}
      <Dashboard />
    </AuthProvider>
  </React.StrictMode>
);
