// /** Đầu tiên bạn tạo một instance của class SpeedSMSAPI với tham số là api
// ccess token của bạn.
// */
// SpeedSMSAPI api = new SpeedSMSAPI("Your access token");
// /**
// * Để lấy thông tin về tài khoản như: email, số dư tài khoản bạn sử dụng hàm
// getUserInfo()
// */
// String userInfo = api.getUserInfo();
// /* * Hàm getUserInfo() sẽ trả về một json như sau:
// * /
// {"email": "test@speedsms.vn", "balance": 100000.0, "currency": "VND"}

// /** Để gửi SMS bạn sử dụng hàm sendSMS như sau:
// */
// String phone = "8491xxxxx";
// String content = "test sms";
// int type = sms_type
// /**
// sms_type có các giá trị như sau:
// 2: tin nhắn gửi bằng đầu số ngẫu nhiên
// 3: tin nhắn gửi bằng brandname
// 4: tin nhắn gửi bằng brandname mặc định (Verify hoặc Notify)
// 5: tin nhắn gửi bằng app android
// */
// String sender = "brandname";
// /**
// brandname là tên thương hiệu hoặc số điện thoại đã đăng ký với SpeedSMS hoặc
// android deviceId của bạn
// */

// String response = api.sendSMS(phone, content, type, sender);
// /**hàm sendSMS sẽ trả về một json string như sau:*/
// {
// "status": "success", "code": "00",
// "data": {
// "tranId": 123456, "totalSMS": 1,
// "totalPrice": 250, "invalidPhone": []
// }
// }
// */
// // Trong trường hợp gửi sms bị lỗi, hàm sendSMS sẽ trả về json string như
// sau:
// {
// "status": "error", "code": "error code", "message" : "error description",
// "invalidPhone": ["danh sách sdt lỗi"]
// }