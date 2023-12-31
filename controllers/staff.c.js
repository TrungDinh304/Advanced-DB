const staffModel = require('../models/staff.m');

module.exports = {
    renderOption: async function renderOption(req, res, next) {
        if (!req.session.user)
            res.redirect('/');
        res.render("staff/option", {
            title: "Staff Option",
            logout:true
        });
    },
    renderEditAppointment: async function renderEditAppointment(req, res, next) {
        if (!req.session.user)
            res.redirect('/');

        const PhieuHen = await staffModel.selectAppointment(req, res, next);
        

        res.render("staff/editAppointment", {
            title: "Staff Edit Appointment",
            PhieuHen: PhieuHen,
            logout:true
        });
    },
    // addAppointment: async function addAppointment(req, res, next) {
    //     staffModel.addAppointment(req, res, next);
    //     res.redirect('/staff/addAppointment');
    // },
    rederAddAppointment: async function renderAddAppointment(req, res, next) {
        if(!req.session.user)
            res.redirect('/');
  
        staffModel.addAppointment(req, res, next);
        
        res.render("staff/addAppointment", {
            title: "Add Appointment",
            logout:true
        });
    },
    rederAddTreatmentPlan: async function renderAddTreatmentPlan(req, res, next) {
        if(!req.session.user)
            res.redirect('/');
  
        staffModel.addTreatmentPlan(req, res, next);
        
        res.render("staff/addTreatmentPlan", {
            title: "Add TreatmentPlan",
            logout:true
        });
    },
    rederAddPatient: async function renderAddPatient(req, res, next) {
        if(!req.session.user)
            res.redirect('/');
  
        staffModel.addPatient(req, res, next);
        
        res.render("staff/addPatient", {
            title: "Add Patient",
            logout:true
        });
    },
    rederAddContraindications: async function renderAddContraindications(req, res, next) {
        if(!req.session.user)
            res.redirect('/');
  
        staffModel.addContraindications(req, res, next);
        
        res.render("staff/addContraindications", {
            title: "Add Contraindications",
            logout:true
        });
    },
    renderViewTreatmentPlan: async function renderViewTreatmentPlan(req, res, next) {
        if(!req.session.user)
            res.redirect('/');
        let KeHoachDieuTri = null;
        KeHoachDieuTri = await staffModel.viewTreatmentPlan(req, res, next);
        
        res.render("staff/viewTreatmentPlan", {
            title: "View TreatmentPlan",
            KeHoachDieuTri: KeHoachDieuTri,
            logout:true
        });
    },
    renderViewAppointmentByRoom: async function renderViewAppointmentByRoom(req, res, next) {
        if(!req.session.user)
            res.redirect('/');
        let CuocHen = null;
        CuocHen = await staffModel.viewAppointmentByRoom(req, res, next);
        
        res.render("staff/viewAppointmentByRoom", {
            title: "View AppointmentByRoom",
            CuocHen: CuocHen,
            logout:true
        });
    },
    renderViewAppointmentByPatient: async function renderViewAppointmentByPatient(req, res, next) {
        if(!req.session.user)
            res.redirect('/');
        let CuocHen = null;
        CuocHen = await staffModel.viewAppointmentByPatient(req, res, next);
        
        res.render("staff/viewAppointmentByPatient", {
            title: "View AppointmentByPatient",
            CuocHen: CuocHen,
            logout:true
        });
    },
    renderViewAppointmentByDoctor: async function renderViewAppointmentByDoctor(req, res, next) {
        if(!req.session.user)
            res.redirect('/');
        let CuocHen = null;
        CuocHen = await staffModel.viewAppointmentByDoctor(req, res, next);
        
        res.render("staff/viewAppointmentByDoctor", {
            title: "View AppointmentByDoctor",
            CuocHen: CuocHen,
            logout:true
        });
    },
}