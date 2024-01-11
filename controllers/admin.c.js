const adminModel = require('../models/admin.m');

module.exports = {
    renderOption: async function renderOption(req, res, next) {
        if (!req.session.user)
            res.redirect('/');

        res.render("admin/option", {
            title: "Admin Option",
            logout: true
        });
    },

    
    renderSelectPersonalScheduleBydate: async function renderSelectPrescription(req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        const LichCaNhan = await adminModel.viewPersonalScheduleBydate(req, res, next);
        
        res.render("admin/viewPersonalScheduleBydate", {
            title: "View Personal Schedule",
            LichCaNhan: LichCaNhan,
            logout: true
        });
    },

    
    renderAddMedicine: async function renderAddMedicine(req, res, next) {
        if (!req.session.user)
            res.redirect('/');

        const Thuoc = await adminModel.SelectMedicine(req, res, next);
        
        adminModel.AddMedicine(req,res,next);
        
        res.render("admin/Medicine", {
            title: "Them Thuoc",
            Thuoc: Thuoc,

            logout: true
        })
    },

    
}