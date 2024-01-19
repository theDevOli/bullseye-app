import styles from "./Footer.module.css";

/**
 * Footer component displaying copyright information.
 * @function
 * @returns {JSX.Element} - The rendered Footer component.
 */
function Footer() {
  const year = new Date().getFullYear();
  return (
    <footer>
      <div className={styles.copyright}>
        <h2>&copy; {year} Bullseye. All rights reserved.</h2>
      </div>
    </footer>
  );
}

export default Footer;
