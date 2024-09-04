const db = require('../utils/db');
const loginModel = require('../models/login.m');

// Model: trường hợp mà backend bị sai liên quan đến database có thể vào đây hoặc sửa script sql.

module.exports = {
    viewDentists: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        console.log(req.query, req.body);
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        let MaNS = req.query.MaNS;
        if (MaNS == undefined) return null;

        Request.input('MaNS', db.db.VarChar, MaNS);

        try {
            const result1 = await Request.execute('sp_XemNhaSi');
            //console.log(result1.recordset);
            return result1.recordset;
        } catch (err) {
            console.log(err);
            return null;
        }
    },

    viewTreatmentPlan: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        console.log(req.query, req.body)
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        let TimTheoMaBenhAn = req.query.TimTheoMaBenhAn;
        if (TimTheoMaBenhAn == undefined)
            return null;

        Request.input('MaBA', db.db.VarChar, TimTheoMaBenhAn);

        try {
            const result1 = await Request.execute('sp_xemKeHoachDieuTri');
            //console.log(result1.recordset);
            return result1.recordset;
        } catch (err) {
            console.log(err);
            return null;
        }
    },

    addTreatmentPlan: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let {
            madieutri, mota, ghichu, trangthai, mabenhan, madichvu, ngay, ca, nhasichinh, nhasiphu
        } = req.body;
        console.log(madieutri, mota, ghichu, trangthai, mabenhan, madichvu, ngay, ca, nhasichinh, nhasiphu)

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaDT', db.db.VarChar, madieutri);
        Request.input('MoTa', db.db.VarChar, mota);
        Request.input('GhiChu', db.db.VarChar, ghichu);
        Request.input('TrangThai', db.db.VarChar, trangthai);
        Request.input('MaBA', db.db.VarChar, mabenhan);
        Request.input('MaDV', db.db.VarChar, madichvu);
        Request.input('Ngay', db.db.Date, new Date(ngay));
        Request.input('Ca', db.db.Int, ca);
        Request.input('Chinh', db.db.VarChar, nhasichinh);
        Request.input('Phu', db.db.VarChar, nhasiphu);

        const result1 = await Request.execute('sp_ThemKeHoachDieuTri', (err, result) => {
            if (err) {
                console.log(err);
            }
        });
        //console.log(result1);
    },

    addTeethDetail: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let {
            MaDT, MaRang, MaBeMat
        } = req.body;
        console.log(MaDT, MaRang, MaBeMat);

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaDT', db.db.VarChar, MaDT);
        Request.input('MaRang', db.db.VarChar, MaRang);
        Request.input('MaBeMat', db.db.VarChar, MaBeMat);

        const result1 = await Request.execute('sp_ThemCTRang', (err, result) => {
            if (err) {
                console.log(err);
            }
        });
    },

    deleteTeethDetail: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let {
            MaDT, MaRang, MaBeMat
        } = req.body;
        console.log(MaDT, MaRang, MaBeMat);

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaDT', db.db.VarChar, MaDT);
        Request.input('MaRang', db.db.VarChar, MaRang);
        Request.input('MaBeMat', db.db.VarChar, MaBeMat);

        const result1 = await Request.execute('sp_XoaCTRang', (err, result) => {
            if (err) {
                console.log(err);
            }
        });
    },

    selectPrescription: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let MaDT = req.query.MaDT;

        if (MaDT == undefined)
            return null;

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaDT', db.db.VarChar, MaDT);

        const result1 = await Request.query('SELECT * FROM ChiTietDonThuoc WHERE MaDT = @MaDT', (err, result) => {
            if (err) {
                console.log(err);
            }
            return result1.recordset;
        });
    },

    addPrescription: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let {
            MaDT, MaThuoc, SL, Lieu
        } = req.body;
        console.log(MaDT, MaThuoc, SL, Lieu);

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaDT', db.db.VarChar, MaDT);
        Request.input('MaThuoc', db.db.VarChar, MaThuoc);
        Request.input('SL', db.db.Int, SL);
        Request.input('Lieu', db.db.NVarChar, Lieu);

        const result1 = await Request.execute('sp_ThemDonThuoc', (err, result) => {
            if (err) {
                console.log(err);
            }
        });
    },

    deletePrescription: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let { MaDT, MaThuoc } = req.body;
        console.log(MaDT, MaThuoc);
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaDT', db.db.VarChar, MaDT);
        Request.input('MaThuoc', db.db.VarChar, MaThuoc);
        const result1 = await Request.execute('sp_XoaDonThuoc', (err, result) => {
            if (err) {
                console.log(err);
            }
        });
    },

    updatePrescription: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let { MaDT, MaThuoc, SL, Lieu } = req.body;
        console.log(MaDT, MaThuoc);
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaDT', db.db.VarChar, MaDT);
        Request.input('MaThuoc', db.db.VarChar, MaThuoc);
        Request.input('SL', db.db.Int, SL);
        Request.input('Lieu', db.db.NVarChar, Lieu);
        const result1 = await Request.execute('sp_SuaDonThuoc', (err, result) => {
            if (err) {
                console.log(err);
            }
        });
    },

    viewAppointmentByRoom: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        console.log(req.query, req.body)
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        let TimTheoNgay = req.query.TimTheoNgay;
        let TimTheoPhong = req.query.TimTheoPhong;
        if (TimTheoNgay == undefined) return null;
        if (TimTheoPhong == undefined) return null;

        Request.input('Ngay', db.db.Date, new Date(TimTheoNgay));
        Request.input('Phong', db.db.VarChar, TimTheoPhong);


        try {
            const result1 = await Request.execute('sp_locCuocHenTheoPhongKham');
            //console.log(result1.recordset);
            return result1.recordset;
        } catch (err) {
            console.log(err);
            return null;
        }
    },
    viewAppointmentByPatient: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        console.log(req.query, req.body)
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        let TimTheoNgay = req.query.TimTheoNgay;
        let TimTheoBenhNhan = req.query.TimTheoBenhNhan;
        if (TimTheoNgay == undefined) return null;
        if (TimTheoBenhNhan == undefined) return null;

        Request.input('Ngay', db.db.Date, new Date(TimTheoNgay));
        Request.input('MaBA', db.db.VarChar, TimTheoBenhNhan);


        try {
            const result1 = await Request.execute('sp_locCuocHenTheoBenhNhan');
            //console.log(result1.recordset);
            return result1.recordset;
        } catch (err) {
            console.log(err);
            return null;
        }
    },
    viewAppointmentByDoctor: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        console.log(req.query, req.body)
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        let TimTheoNgay = req.query.TimTheoNgay;
        let TimTheoNhaSi = req.query.TimTheoNhaSi;
        if (TimTheoNgay == undefined) return null;
        if (TimTheoNhaSi == undefined) return null;

        Request.input('Ngay', db.db.Date, new Date(TimTheoNgay));
        Request.input('NhaSi', db.db.VarChar, TimTheoNhaSi);


        try {
            const result1 = await Request.execute('sp_locCuocHenTheoNhaSi');
            //console.log(result1.recordset);
            return result1.recordset;
        } catch (err) {
            console.log(err);
            return null;
        }
    }
}