-- task 2 Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên 
-- bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự.
SELECT 
  ho_ten 
FROM 
  nhan_vien 
WHERE 
  (ho_ten regexp '^[HTK]') 
  AND (
    char_length(ho_ten)<= 15
  );

-- task 3 Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi 
-- và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
-- cach 1
SELECT 
  *, 
  year(
    CURDATE()
  ) - year(ngay_sinh) AS tuoi 
FROM 
  khach_hang 
WHERE 
  (
    year(
      CURDATE()
    ) - year(ngay_sinh) BETWEEN 18 
    AND 50
  ) 
  AND (
    dia_chi like '% Đà Nẵng' 
    OR dia_chi like '% Quảng Trị'
  );
-- cach 2
SELECT 
  * 
FROM 
  khach_hang 
WHERE 
  (
    timestampdiff(
      YEAR, 
      ngay_sinh, 
      curdate()
    ) BETWEEN 18 
    AND 50
  ) 
  AND (
    dia_chi like '%Đà Nẵng%' 
    OR dia_chi like '%Quảng Trị%'
  );
 
-- task 4 Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần. 
-- Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt phòng của khách hàng. 
-- Chỉ đếm những khách hàng nào có Tên loại khách hàng là “Diamond”.
SELECT 
  kh.ma_khach_hang, 
  kh.ho_ten, 
  count(kh.ma_khach_hang) so_lan_dat_phong 
FROM 
  khach_hang kh 
  INNER JOIN hop_dong hd ON kh.ma_khach_hang = hd.ma_khach_hang 
  INNER JOIN loai_khach lk ON kh.ma_loai_khach = lk.ma_loai_khach 
WHERE 
  lk.ten_loai_khach = 'Diamond' 
GROUP BY 
  kh.ma_khach_hang 
ORDER BY 
  so_lan_dat_phong;

-- task 5 Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, 
-- ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien 
--  (Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, 
--  với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) cho tất cả các khách hàng đã từng đặt phòng. 
--  (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra).
SELECT 
  kh.ma_khach_hang, 
  kh.ho_ten, 
  lk.ten_loai_khach, 
  hd.ma_hop_dong, 
  dv.ten_dich_vu, 
  hd.ngay_lam_hop_dong, 
  hd.ngay_ket_thuc, 
  (
    ifnull(dv.chi_phi_thue, 0)
  )+ sum(
    ifnull(hdct.so_luong, 0)* ifnull(dvdk.gia, 0)
  ) tong_tien 
FROM 
  khach_hang kh 
  LEFT JOIN hop_dong hd ON kh.ma_khach_hang = hd.ma_khach_hang 
  LEFT JOIN loai_khach lk ON kh.ma_loai_khach = lk.ma_loai_khach 
  LEFT JOIN hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong 
  LEFT JOIN dich_vu_di_kem dvdk ON hdct.ma_dich_vu_di_kem = dvdk.ma_dich_vu_di_kem 
  LEFT JOIN dich_vu dv ON hd.ma_dich_vu = dv.ma_dich_vu 
GROUP BY 
  hd.ma_hop_dong, 
  kh.ma_khach_hang;