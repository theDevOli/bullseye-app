import styles from "./Logout.module.css";
import Button from "../Button/Button";
import { useAuth } from "../../contexts/AuthContext";

function Logout() {
  const { logout } = useAuth();
  return (
    <div className={styles.logout}>
      <span>5:00</span>
      <Button type="logout" onClick={logout}>
        Logout
      </Button>
    </div>
  );
}

export default Logout;
