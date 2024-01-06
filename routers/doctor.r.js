const app = require("express");
const router = app.Router();


const doctorController = require('../controllers/doctor.c');
router.get("/", doctorController.renderOption);
//router.get("/editAppointment", staffController.renderEditAppointment);

router.get("/viewDentists", doctorController.renderViewDentists);

router.get("/addTreatmentPlan", doctorController.renderAddTreatmentPlan);
router.post("/addTreatmentPlan", doctorController.renderAddTreatmentPlan);

router.get("/viewAppointmentByDoctor", doctorController.renderViewAppointmentByDoctor);
router.get("/viewAppointmentByPatient", doctorController.renderViewAppointmentByPatient);
router.get("/viewAppointmentByRoom", doctorController.renderViewAppointmentByRoom);


module.exports = router;