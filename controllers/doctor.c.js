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

        let Dentist = await doctorModel.viewDentists(req, res, next);

        res.render("doctor/viewDentists", {
            title: "View Dentists",
            Dentist: Dentist,
            logout: true
        })
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
    }
}