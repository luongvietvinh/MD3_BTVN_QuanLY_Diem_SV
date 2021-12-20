
alter  table sinhvien
modify hocbong int  ;


-- Câu 1: Liệt kê danh sách các lớp của khoa, thông tin cần Malop, TenLop, MaKhoa
select khoa.* , lop.* from khoa join lop on khoa.makhoa = lop.makhoa;

-- Câu 2: Lập danh sách sinh viên gồm: MaSV, HoTen, HocBong
select sinhvien.masinhvien , sinhvien.hoten , sinhvien.hocbong from sinhvien;

-- Câu 3: Lập danh sách sinh viên có học bổng. Danh sách cần MaSV, Nu, HocBong

select sinhvien.masinhvien , sinhvien.gioitinh , sinhvien.hocbong from sinhvien
where sinhvien.hocbong is not null;

-- Câu 5: Lập danh sách sinh viên có họ ‘Trần’

select sinhvien.* from sinhvien
where sinhvien.hoten like 'tran%';

-- Câu 6: Lập danh sách sinh viên nữ có học bổng
select sinhvien.masinhvien, sinhvien.hoten , sinhvien.gioitinh,sinhvien.hocbong from sinhvien
where sinhvien.gioitinh like 'nu%' and sinhvien.hocbong is not null;
-- Câu 7: Lập danh sách sinh viên nữ hoặc danh sách sinh viên có học bổng
select sinhvien.masinhvien, sinhvien.hoten , sinhvien.gioitinh,sinhvien.hocbong from sinhvien
where sinhvien.gioitinh = 'nu' or sinhvien.hocbong  is not null;

-- Câu 8: Lập danh sách sinh viên có năm sinh từ 1978 đến 1985. Danh sách cần các thuộc tính của quan hệ SinhVien
select sinhvien.* from sinhvien
where year(ngaysinh) >=1978 and year(ngaysinh) <= 1991;

-- Câu 9: Liệt kê danh sách sinh viên được sắp xếp tăng dần theo MaSV
select sinhvien.* from sinhvien
order by masinhvien ;

-- Câu 10: Liệt kê danh sách sinh viên được sắp xếp giảm dần theo HocBong
select sinhvien.* from sinhvien
where hocbong is not null 
order by  hocbong desc ;

-- Ví du 12: Lập danh sách sinh viên có học bổng của khoa CNTT. Thông tin cần: MaSV, 
select sinhvien.hoten , khoa.tenkhoa, sinhvien.hocbong from sinhvien
join lop on sinhvien.malop = lop.malopid
join khoa on lop.makhoa = khoa.makhoa
where hocbong is not null and tenkhoa = "cntt"
group by tenkhoa;

-- Câu 14: Cho biết số sinh viên của mỗi lớp
select row_number()over() as 'STT',    lop.tenlop ,count(sinhvien.malop) as 'so luong sv' from lop 
join sinhvien on lop.malopid = sinhvien.malop
group by lop.tenlop;
-- Câu 15: Cho biết số lượng sinh viên của mỗi khoa.

select row_number()over() as 'STT',    khoa.tenkhoa ,count(sinhvien.malop) as 'so luong sv' 
from sinhvien 
join lop on lop.malopid = sinhvien.malop
join khoa on lop.makhoa = khoa.makhoa
group by khoa.tenkhoa;

-- Câu 16: Cho biết số lượng sinh viên nữ của mỗi khoa.

select row_number()over() as 'STT',    khoa.tenkhoa ,count(sinhvien.malop) as 'so luong sv nu cua moi khoa ' 
from sinhvien 
join lop on lop.malopid = sinhvien.malop
join khoa on lop.makhoa = khoa.makhoa
where sinhvien.gioitinh = 'nu' 
group by khoa.tenkhoa;

-- Câu 17: Cho biết tổng tiền học bổng của mỗi lớp

select row_number() over () as ' STT', lop.tenlop, concat( format (sum(sinhvien.hocbong),0) , '$') as ' tongtienhocbong'
from lop join sinhvien on lop.malopid = sinhvien.malop
where hocbong is not null
group by tenlop;

-- Câu 18: Cho biết tổng số tiền học bổng của mỗi khoa

  select row_number() over () as ' STT', khoa.tenkhoa, 
  concat( format (sum(sinhvien.hocbong),0) , '$')as ' tong tien hoc bong'
from sinhvien join lop on lop.malopid = sinhvien.malop
join khoa on lop.makhoa = khoa.makhoa
group by tenkhoa;

#Câu 19: Lập danh sánh những khoa có nhiều hơn 100 sinh viên. Danh sách cần: MaKhoa, TenKhoa, Soluong

#Câu22: Lập danh sách sinh viên có học bổng cao nhất
select sinhvien.* from sinhvien;
select sinhvien.hoten, concat(format( max(sinhvien.hocbong),0) ,'$ ') 
as "hoc-bong" from sinhvien;



-- Câu 23: Lập danh sách sinh viên có điểm thi môn CSDL cao nhất
select sinhvien.hoten,monhoc.tenMH, max(ketqua.diemthi) from sinhvien
join ketqua on sinhvien.masinhvien = ketqua.masinhvien
join monhoc on ketqua.maMH = monhoc.maMH
where monhoc.tenMH = "csdl"
group by hoten;

-- Câu 25: Cho biết những khoa nào có nhiều sinh viên nhất

select row_number() over() as'stt', khoa.tenkhoa , count(sinhvien.masinhvien) as "soLuongSV" from sinhvien
join lop on sinhvien.malop = lop.malopid
join khoa on lop.makhoa = khoa.makhoa
group by tenkhoa
having count (masinhvien) >= all(select count(masinhvien) from sinhvien
join lop on sinhvien.malop = lop.malopid
join khoa on lop.makhoa = khoa.makhoa )
;
SELECT Khoa.MaKhoa, TenKhoa, Count(sinhvien.masinhvien) AS SoLuongSV
FROM (Khoa INNER JOIN Lop ON Khoa.MaKhoa = Lop.MaKhoa) JOIN SinhVien ON Lop.MaLop = SinhVien.MaLop
GROUP BY Khoa.MaKhoa
HaVing Count(masinhvien)>=All(Select Count(masinhvien) From 
((SinhVien Inner Join Lop On Lop.Malopid=SinhVien.Malop)Inner Join Khoa On Khoa.MaKhoa = Lop.MaKhoa )
Group By Khoa.Makhoa);
SELECT SinhVien.masinhvien, HoTen, DiemThi
FROM SinhVien INNER JOIN KetQua ON SinhVien.masinhvien = KetQua.masinhvien
WHERE KetQua.MaMH= ‘CSDL’ AND DiemThi>=ALL(SELECT DiemThi FROM KetQua WHERE MaMH = ‘CSDL’)






-- dem sl sinh vien
#select  count(masinhvien) as "tong sl sing vien" from sinhvien;



