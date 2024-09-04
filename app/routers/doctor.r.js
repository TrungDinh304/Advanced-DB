const app = require("express");
const router = app.Router();


const doctorController = require('../controllers/doctor.c');
router.get("/", doctorController.renderOption);

router.get("/appointmentOption", doctorController.renderAppointmentOption);
//router.get("/editAppointment", staffController.renderEditAppointment);

router.get("/viewDentists", doctorController.renderViewDentists);

router.get("/viewTreatmentPlan", doctorController.renderViewTreatmentPlan);
router.get("/addTreatmentPlan", doctorController.renderAddTreatmentPlan);
router.post("/addTreatmentPlan", doctorController.renderAddTreatmentPlan);

router.get("/viewAppointmentByDoctor", doctorController.renderViewAppointmentByDoctor);
router.get("/viewAppointmentByPatient", doctorController.renderViewAppointmentByPatient);
router.get("/viewAppointmentByRoom", doctorController.renderViewAppointmentByRoom);

router.get("/viewTreatmentPlan/viewPrescription", doctorController.renderSelectPrescription);

router.get("/viewTreatmentPlan/addPrescription", doctorController.renderAddPrescription);
router.post("/viewTreatmentPlan/addPrescription", doctorController.renderAddPrescription);

router.get("/viewTreatmentPlan/updatePrescription", doctorController.renderUpdatePrescription);
router.post("/viewTreatmentPlan/updatePrescription", doctorController.renderUpdatePrescription);

router.get("/viewTreatmentPlan/deletePrescription", doctorController.renderDeletePrescription);
router.post("/viewTreatmentPlan/deleterescription", doctorController.renderDeletePrescription);

module.exports = router;