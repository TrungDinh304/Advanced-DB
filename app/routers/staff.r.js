const app = require("express");
const router = app.Router();


const staffController = require('../controllers/staff.c');
router.get("/", staffController.renderOption);
//router.get("/editAppointment", staffController.renderEditAppointment);

router.get("/addAppointment", staffController.rederAddAppointment);
router.post("/addAppointment", staffController.rederAddAppointment);

router.get("/addTreatmentPlan", staffController.rederAddTreatmentPlan);
router.post("/addTreatmentPlan", staffController.rederAddTreatmentPlan);

router.get("/addPatient", staffController.rederAddPatient);
router.post("/addPatient", staffController.rederAddPatient);

router.get("/addContraindications", staffController.rederAddContraindications);
router.post("/addContraindications", staffController.rederAddContraindications);

router.get("/viewTreatmentPlan", staffController.renderViewTreatmentPlan);
router.get("/viewAppointmentByRoom", staffController.renderViewAppointmentByRoom);
router.get("/viewAppointmentByPatient", staffController.renderViewAppointmentByPatient);
router.get("/viewAppointmentByDoctor", staffController.renderViewAppointmentByDoctor);

module.exports = router;