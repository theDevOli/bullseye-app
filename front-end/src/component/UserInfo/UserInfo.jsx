import styles from "./UserInfo.module.css";

import { useAuth } from "../../contexts/AuthContext";
function UserInfo() {
  const { user } = useAuth();
  return (
    <div className={styles.info}>
      <div>
        <span>User: </span>
        <span>{user?.firstName}</span>
      </div>
      <div>
        <span>Location: </span>
        <span>{user?.position}</span>
      </div>
    </div>
  );
}

export default UserInfo;
