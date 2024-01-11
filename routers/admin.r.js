const app = require("express");
const router = app.Router();


const adminController = require('../controllers/admin.c');
//const doctorController = require('../controllers/doctor.c');
router.get("/", adminController.renderOption);

//router.get("/appointmentOption", doctorController.renderAppointmentOption);
//router.get("/editAppointment", staffController.renderEditAppointment);

//router.get("/viewDentists", doctorController.renderViewDentists);

router.get("/viewPersonalScheduleBydate",adminController.renderSelectPersonalScheduleBydate);

router.get("/Medicine", adminController.renderAddMedicine);
router.post("/Medicine",adminController.renderAddMedicine);

router.get("/UpdateMedicine", adminController.renderUpdateMedicine);
router.post("/UpdateMedicine",adminController.renderUpdateMedicine);

router.get("/RemoveMedicine", adminController.renderRemoveMedicine);
router.post("/RemoveMedicine",adminController.renderRemoveMedicine);

module.exports = router;