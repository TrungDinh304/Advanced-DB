const db = require('../utils/db');
const loginModel=require('../models/login.m');

module.exports = {

    addAppointment: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let { macuochen,phong,ngay,ca,nhasichinh,nhasiphu, mabenhan, trangthai, ghichu,ngaygui,madieutri } = req.body;
        console.log(macuochen,phong,ngay,ca,nhasichinh,nhasiphu, mabenhan, trangthai, ghichu,ngaygui,madieutri)

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaCuocHen', db.db.VarChar, macuochen);
        Request.input('Phong', db.db.VarChar, phong);
        Request.input('Ngay', db.db.Date, new Date(ngay));
        Request.input('Ca', db.db.Int, ca);
        Request.input('NS_khamchinh', db.db.VarChar, nhasichinh);
        Request.input('NS_khamphu', db.db.VarChar, nhasiphu);
        Request.input('MaBA', db.db.VarChar, mabenhan);
        Request.input('TrangThai', db.db.VarChar, trangthai);
        Request.input('GhiChu', db.db.VarChar, ghichu);
        Request.input('NgayGui', db.db.Date, new Date(ngaygui));
        Request.input('MaDT', db.db.VarChar, madieutri);
          
        
        //console.log(Request)

        const result1 = await Request.execute('sp_themCuocHen', (err, result) => {
            if (err) {
                console.log(err);
            }          
        });
        //console.log(result1);
    },
    addTreatmentPlan: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let { 
            madieutri,mota,ghichu,trangthai,mabenhan,mathanhtoan,madichvu,ngay,ca,nhasichinh,nhasiphu
        } = req.body;
        console.log(madieutri,mota,ghichu,trangthai,mabenhan,mathanhtoan,madichvu,ngay,ca,nhasichinh,nhasiphu)

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaDT', db.db.VarChar, madieutri);
        Request.input('MoTa', db.db.VarChar, mota);
        Request.input('GhiChu', db.db.VarChar, ghichu);
        Request.input('TrangThai', db.db.VarChar, trangthai);
        Request.input('MaBA', db.db.VarChar, mabenhan);
        Request.input('MaTT', db.db.VarChar, mathanhtoan);
        Request.input('MaDV', db.db.VarChar, madichvu);
        Request.input('Ngay', db.db.Date, new Date(ngay));
        Request.input('Ca', db.db.Int, ca);
        Request.input('NS_khamchinh', db.db.VarChar, nhasichinh);
        Request.input('NS_khamphu', db.db.VarChar, nhasiphu);
          
        const result1 = await Request.execute('sp_themKeHoachDieuTri', (err, result) => {
            if (err) {
                console.log(err);
            }          
        });
        //console.log(result1);
    },
    addPatient: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let { 
            mabenhan,hoten,ngaysinh,gioitinh,email,sodienthoai,diachi,tongtiendieutri,tongtiendieutridatra,tongquan
        } = req.body;
        console.log(mabenhan,hoten,ngaysinh,gioitinh,email,sodienthoai,diachi,tongtiendieutri,tongtiendieutridatra,tongquan)

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaBA', db.db.VarChar, mabenhan);
        Request.input('hoten', db.db.VarChar, hoten);
        Request.input('ngaysinh', db.db.Date, new Date(ngaysinh));
        Request.input('gioitinh', db.db.VarChar, gioitinh);
        Request.input('email', db.db.VarChar, email);
        Request.input('sodienthoai', db.db.VarChar, sodienthoai);
        Request.input('diachi', db.db.VarChar, diachi);
        Request.input('TongTienDieuTri', db.db.Int, tongtiendieutri);
        Request.input('TongTienDieuTri_datra', db.db.Int, tongtiendieutridatra);
        Request.input('TongQuan', db.db.VarChar, tongquan);
        
          
        const result1 = await Request.execute('sp_themBenhAn', (err, result) => {
            if (err) {
                console.log(err);
            }          
        });
        //console.log(result1);
    },
    addContraindications: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
        let { 
            mabenhan,sttccd,mota
        } = req.body;
        console.log(mabenhan,sttccd,mota)

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        Request.input('MaBA', db.db.VarChar, mabenhan);
        Request.input('sttCCD', db.db.Int, sttccd);
        Request.input('MoTa', db.db.VarChar, mota);
        
        
        const result1 = await Request.execute('sp_themThongTinChongChiDinh', (err, result) => {
            if (err) {
                console.log(err);
            }          
        });
        //console.log(result1);
    },
    viewTreatmentPlan: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
    
        
        console.log(req.query,req.body)
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);
    
        let  TimTheoMaBenhAn= req.query.TimTheoMaBenhAn;
        if ( TimTheoMaBenhAn== undefined)
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
    viewAppointmentByRoom: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');
    
        console.log(req.query,req.body)
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);
    
        let  TimTheoNgay= req.query.TimTheoNgay;
        let  TimTheoPhong= req.query.TimTheoPhong;
        if ( TimTheoNgay == undefined) return null;
        if ( TimTheoPhong == undefined) return null;

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
    
        console.log(req.query,req.body)
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);
    
        let  TimTheoNgay= req.query.TimTheoNgay;
        let  TimTheoBenhNhan= req.query.TimTheoBenhNhan;
        if ( TimTheoNgay == undefined) return null;
        if ( TimTheoBenhNhan == undefined) return null;

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
    
        console.log(req.query,req.body)
        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);
    
        let  TimTheoNgay= req.query.TimTheoNgay;
        let  TimTheoNhaSi= req.query.TimTheoNhaSi;
        if ( TimTheoNgay == undefined) return null;
        if ( TimTheoNhaSi == undefined) return null;

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
    },
    selectAppointment: async function (req, res, next) {
        if (!req.session.config)
            res.redirect('/');

        const pool = new db.db.ConnectionPool(req.session.config);
        const connection = await pool.connect();
        const Request = new db.db.Request(connection);

        //use request to query select*from phieuhen 
        const result1 = await Request.query('select * from PhieuHen');
        //get result from query

        return result1.recordset;
    }

}