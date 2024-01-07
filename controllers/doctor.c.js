const doctorModel = require('../models/doctor.m');

module.exports = {
    renderOption: async function renderOption(req, res, next) {
        if (!req.session.user)
            res.redirect('/');

        res.render("doctor/option", {
            title: "Doctor Option",
            logout: true
        });
    },

    renderAppointmentOption: async function renderAppointmentOption(req, res, next) {
        if (!req.session.user)
            res.redirect('/');

        res.render("doctor/appointmentOption", {
            title: "Appointment Option",
            logout: true
        })
    },

    renderViewDentists: async function renderViewDentists(req, res, next) {
        if (!req.session.user) {
            res.redirect('/');
        }

        const Dentist = await doctorModel.viewDentists(req, res, next);

        res.render("doctor/viewDentists", {
            title: "View Dentists",
            Dentist: Dentist,
            logout: true
        })
    },

    renderViewTreatmentPlan: async function renderAddTreatmentPlan(req, res, next) {
        if (!req.session.user)
            res.redirect('/');

        const KeHoachDieuTri = await doctorModel.viewTreatmentPlan(req, res, next);

        res.render("doctor/viewTreatmentPlan", {
            title: "View Treatment Plan",
            KeHoachDieuTri: KeHoachDieuTri,
            logout: true
        });
    },

    renderAddTreatmentPlan: async function renderAddTreatmentPlan(req, res, next) {
        if (!req.session.user)
            res.redirect('/');

        doctorModel.addTreatmentPlan(req, res, next);

        res.render("doctor/addTreatmentPlan", {
            title: "Add Treatment Plan",
            logout: true
        });
    },

    renderViewAppointmentByRoom: async function renderViewAppointmentByRoom(req, res, next) {
        if (!req.session.user)
            res.redirect('/');
        let CuocHen = null;
        CuocHen = await doctorModel.viewAppointmentByRoom(req, res, next);

        res.render("doctor/viewAppointmentByRoom", {
            title: "View AppointmentByRoom",
            CuocHen: CuocHen,
            logout: true
        });
    },
    renderViewAppointmentByPatient: async function renderViewAppointmentByPatient(req, res, next) {
        if (!req.session.user)
            res.redirect('/');
        let CuocHen = null;
        CuocHen = await doctorModel.viewAppointmentByPatient(req, res, next);

        res.render("doctor/viewAppointmentByPatient", {
            title: "View AppointmentByPatient",
            CuocHen: CuocHen,
            logout: true
        });
    },
    renderViewAppointmentByDoctor: async function renderViewAppointmentByDoctor(req, res, next) {
        if (!req.session.user)
            res.redirect('/');
        let CuocHen = null;
        CuocHen = await doctorModel.viewAppointmentByDoctor(req, res, next);

        res.render("doctor/viewAppointmentByDoctor", {
            title: "View AppointmentByDoctor",
            CuocHen: CuocHen,
            logout: true
        });
    },


    renderSelectPrescription: async function renderSelectPrescription(req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        const DonThuoc = await doctorModel.selectPrescription(req, res, next);

        res.render("doctor/viewPrescription", {
            title: "View Prescription",
            DonThuoc: DonThuoc,
            logout: true
        });
    },

    renderAddPrescription: async function renderAddPrescription(req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        await doctorModel.addPrescription(req, res, next);

        res.render("doctor/addPrescription", {
            title: "Add Prescription",
            DonThuoc: DonThuoc,
            logout: true
        });
    },

    renderDeletePrescription: async function renderDeletePrescription(req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        await doctorModel.deletePrescription(req, res, next);

        res.render("doctor/deletePrescription", {
            title: "Delete Prescription",
            logout: true
        });
    },

    renderUpdatePrescription: async function renderUpdatePrescription(req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        await doctorModel.updatePrescription(req, res, next);

        res.render("doctor/updatePrescription", {
            title: "View Prescription",
            logout: true
        })
    }
}