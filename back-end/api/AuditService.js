import express from "express";
import cors from "cors";

import errorMsg from "../Utils/errorMsg.js";
import aa from "../DAO/AuditAccessor.js";
import Audit from "../entity/Audit.js";

// const app = express();
const router = express.Router();

router.use(cors());

router.use(express.json());

//---------------VALID-ROUTING-------------
/**
 * GET /AuditService/audits
 * @summary Get a list of all audits.
 * @response 200 - Successful response with audit data.
 * @response 500 - Internal server error.
 */
router.get("/AuditServices/audits", async (req, res) => {
  try {
    const data = await aa.getAllAudit();
    res.status(200).json({ err: null, data: data });
  } catch (e) {
    res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
  }
});

router.post("/AuditServices/audits/:auditID(\\d+)", async (req, res) => {
  try {
    const body = req.body;
    const audit = new Audit(
      body.txnAuditID,
      body.txnID,
      body.txnType,
      body.status,
      body.txnDate,
      body.SiteID,
      body.deliveryID,
      body.siteID,
      body.notes
    );
    const ok = await aa.addAudit(audit);
    if (!ok) {
      res.status(409).json({ err: errorMsg.CONFLICT_ADD_ERROR, data: null });
      return;
    }
    res.status(201).json({ err: null, data: true });
    try {
    } catch (e) {
      res.status(500).json({ err: errorMsg.SERVER_ERROR, data: null });
    }
  } catch (e) {
    res.status(400).json({ err: errorMsg.BAD_REQUEST_ERROR, data: null });
  }
});

export default router;
