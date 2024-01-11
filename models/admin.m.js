const db = require('../utils/db');
const loginModel = require('../models/login.m');

// Model: trường hợp mà backend bị sai liên quan đến database có thể vào đây hoặc sửa script sql.

module.exports = {
    viewPersonalScheduleBydate: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        console.log(req.query)
        console.log(req.body)
        console.log('parram', req.params)
        
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);


        let Ngay = req.query.Ngay;
        
        if (Ngay == undefined) return null;

        Request.input('Ngay', db.db.Date, new Date(Ngay));


        try {
            const result1 = await Request.execute('sp_XemLichCaNhan_TheoNgay');
            //console.log(result1.recordset);
            return result1.recordset;
        } catch (err) {
            console.log(err);
            return null;
        }
    },

    SelectMedicine: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);


        try {
            const result1 = await Request.execute('sp_XemDanhSachThuoc');
            //console.log(result1.recordset);
            return result1.recordset;
        } catch (err) {
            console.log(err);
            return null;
        }
    },

    AddMedicine: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        console.log(req.body)
        
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        let MaThuoc = req.body.MaThuoc;
        let TenThuoc = req.body.TenThuoc;
        let HanSD = req.body.HanSD;
        let DonGia = req.body.DonGia;
        let DonViTinh = req.body.DonViTinh;
        let SoLuong = req.body.SoLuong;
        let GhiChu = req.body.GhiChu;
        if(MaThuoc == undefined) return null;

        Request.input('MaThuoc', db.db.VarChar, MaThuoc);
        Request.input('TenThuoc', db.db.NVarChar, TenThuoc);
        Request.input('HanSD', db.db.Date, new Date(HanSD));
        Request.input('DonGia', db.db.Int, DonGia);
        Request.input('DonViTinh', db.db.NVarChar, DonViTinh);
        Request.input('SoLuongTon', db.db.Int, SoLuong);
        Request.input('GhiChu', db.db.NVarChar, GhiChu);
        
    
        try {
            const result1 = await Request.execute('sp_ThemThuoc');
            //console.log(result1.recordset);
            return result1.recordset;
        } catch (err) {
            console.log(err);
            return null;
        }
    },
    
}