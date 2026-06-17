# ProjectName_Thien_Vu_Hoang_N03_1_2026
# Nhóm sinh viên
Nguyễn Hoàng Thiên - 23010139

Phạm Ngọc Vũ - 23010192

Trần Mạnh Hoàng - 23010290

# 📌 DEVELOPMENT ROADMAP – LIFE RPG

## 🎯 Mục tiêu roadmap

Tài liệu này mô tả chi tiết thứ tự triển khai dự án Life RPG theo từng giai đoạn nhằm đảm bảo:

- Dự án có kiến trúc rõ ràng
- Logic phát triển hợp lý
- Dễ quản lý tiến độ
- Dễ mở rộng trong tương lai
- Phù hợp quy trình phát triển ứng dụng thực tế

---

# 🚩 GIAI ĐOẠN 1 – ỔN ĐỊNH NỀN TẢNG DỰ ÁN

## 📌 Mục tiêu

Hoàn thiện kiến trúc project và đảm bảo ứng dụng chạy ổn định trên Web trước khi triển khai chức năng chính.

---

## ✅ Công việc 1.1 – Refactor Project Structure

### Nội dung thực hiện

- Chuẩn hóa cấu trúc thư mục
- Tách models, providers, services, screens
- Xóa file trùng lặp
- Sửa toàn bộ import lỗi
- Tách giao diện Parent và Child

### Kết quả cần đạt

flutter analyze 

## ✅ Công việc 1.2 – Chuẩn hóa App Entry

### Nội dung thực hiện

- Rút gọn main.dart
- Tạo app.dart
- Thiết lập MaterialApp
- Tạo theme chung
- Tạo routing cơ bản

### Kết quả cần đạt

```txt
main.dart → app.dart → splash_screen
```

---

## ✅ Công việc 1.3 – Chạy Web ổn định

### Nội dung thực hiện

Chạy project bằng:

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

### Kết quả cần đạt

- App không crash
- Có thể debug bằng browser
- Navigation hoạt động ổn định

---

# 🚩 GIAI ĐOẠN 2 – XÂY DỰNG KHUNG GIAO DIỆN

## 📌 Mục tiêu

Hoàn thiện toàn bộ navigation và giao diện cơ bản của hệ thống.

---

## ✅ Công việc 2.1 – Splash Screen

### Nội dung thực hiện

- Thiết kế logo app
- Loading animation
- Chuyển sang Login Screen

### Kết quả cần đạt

```txt
Splash → Login
```

---

## ✅ Công việc 2.2 – Login / Register

### Nội dung thực hiện

- Login UI
- Register UI
- Form validation
- Điều hướng cơ bản

### Kết quả cần đạt

```txt
Đăng nhập giả lập hoạt động
```

---

## ✅ Công việc 2.3 – Role Select Screen

### Nội dung thực hiện

Tạo màn hình lựa chọn vai trò:

- Parent
- Child

### Kết quả cần đạt

```txt
Điều hướng đúng theo vai trò người dùng
```

---

## ✅ Công việc 2.4 – Parent Screens

### Nội dung thực hiện

Hoàn thiện:

- Parent Dashboard
- Create Task Screen
- Verify Task Screen
- Manage Child Screen
- Reward Management Screen

### Kết quả cần đạt

```txt
Parent có giao diện quản lý hoàn chỉnh
```

---

## ✅ Công việc 2.5 – Child Screens

### Nội dung thực hiện

Hoàn thiện:

- Child Home Screen
- Child Task Screen
- Child Profile Screen
- Achievement Screen

### Kết quả cần đạt

```txt
Child có giao diện trải nghiệm riêng
```

---

# 🚩 GIAI ĐOẠN 3 – XÂY DỰNG DATA MODEL

## 📌 Mục tiêu

Chuẩn hóa dữ liệu để đảm bảo dễ mở rộng và tích hợp Firebase.

---

## ✅ Công việc 3.1 – Parent Model

### Thuộc tính chính

```txt
id
name
email
childrenIds
createdAt
```

---

## ✅ Công việc 3.2 – Child Model

### Thuộc tính chính

```txt
id
name
avatar
exp
level
totalReward
createdAt
```

---

## ✅ Công việc 3.3 – Task Model

### Thuộc tính chính

```txt
id
parentId
childId
title
description
difficulty
expReward
rewardAmount
status
createdAt
submittedAt
verifiedAt
```

---

## ✅ Công việc 3.4 – Achievement Model

### Thuộc tính chính

```txt
id
title
description
condition
reward
icon
```

---

## ✅ Công việc 3.5 – Activity Model

### Thuộc tính chính

```txt
id
type
content
timestamp
```

---

# 🚩 GIAI ĐOẠN 4 – TASK MANAGEMENT SYSTEM

## 📌 Mục tiêu

Xây dựng logic quản lý nhiệm vụ trước khi tích hợp Firebase.

---

## ✅ Công việc 4.1 – Task CRUD Local

### Nội dung thực hiện

- Add Task
- Update Task
- Delete Task
- Display Task List

### Kết quả cần đạt

```txt
Task CRUD local hoạt động ổn định
```

---

## ✅ Công việc 4.2 – Child Submit Task

### Logic

```txt
pending → submitted
```

### Kết quả cần đạt

```txt
Child có thể gửi nhiệm vụ hoàn thành
```

---

## ✅ Công việc 4.3 – Parent Verify Task

### Logic

```txt
submitted → approved / rejected
```

### Đây là business logic quan trọng nhất của dự án.

### Kết quả cần đạt

```txt
Parent có thể approve hoặc reject nhiệm vụ
```

---

# 🚩 GIAI ĐOẠN 5 – GAMIFICATION SYSTEM

## 📌 Mục tiêu

Triển khai hệ thống RPG cho ứng dụng.

---

## ✅ Công việc 5.1 – EXP System

### Nội dung thực hiện

- Cộng EXP khi approve task
- Hiển thị EXP Bar

### Kết quả cần đạt

```txt
Approve task → EXP tăng
```

---

## ✅ Công việc 5.2 – Level System

### Logic mẫu

```txt
100 EXP = Level 2
200 EXP = Level 3
300 EXP = Level 4
```

### Kết quả cần đạt

```txt
Level tăng tự động theo EXP
```

---

## ✅ Công việc 5.3 – Achievement System

### Achievement mẫu

- Hoàn thành task đầu tiên
- Hoàn thành 5 task
- Đạt Level 3
- Đạt 500 EXP

### Kết quả cần đạt

```txt
Achievement unlock hoạt động chính xác
```

---

## ✅ Công việc 5.4 – Reward System

### Nội dung thực hiện

- Reward theo task
- Tổng reward
- Reward history

### Kết quả cần đạt

```txt
Child xem được lịch sử phần thưởng
```

---

## ✅ Công việc 5.5 – Activity Log

### Nội dung ghi log

- Task completed
- Level up
- Achievement unlocked
- Reward received

### Kết quả cần đạt

```txt
Hiển thị lịch sử hoạt động đầy đủ
```

---

# 🚩 GIAI ĐOẠN 6 – FIREBASE INTEGRATION

## 📌 Mục tiêu

Đồng bộ hệ thống local với backend realtime.

---

## ✅ Công việc 6.1 – Firebase Setup

### Nội dung thực hiện

- Firebase project
- FlutterFire CLI
- firebase_options.dart

---

## ✅ Công việc 6.2 – Firebase Authentication

### Nội dung thực hiện

- Login
- Register
- Logout
- Session Management

---

## ✅ Công việc 6.3 – Firestore Database

### Collections

```txt
parents
children
tasks
activities
achievements
rewards
verification_logs
```

---

## ✅ Công việc 6.4 – Realtime Sync

### Kết quả cần đạt

```txt
Parent và Child realtime dữ liệu
```

---

# 🚩 GIAI ĐOẠN 7 – UI/UX & ANIMATION

## 📌 Mục tiêu

Hoàn thiện trải nghiệm người dùng.

---

## ✅ Công việc 7.1 – UI Design

### Parent UI

- Chuyên nghiệp
- Dễ quản lý

### Child UI

- Nhiều màu sắc
- Phong cách game hóa

---

## ✅ Công việc 7.2 – Animation

### Nội dung thực hiện

- EXP animation
- Level Up animation
- Achievement popup

---

## ✅ Công việc 7.3 – Responsive

### Thiết bị hỗ trợ

- Web
- Android
- iOS

---

# 🚩 GIAI ĐOẠN 8 – TESTING & DEPLOYMENT

## 📌 Mục tiêu

Đưa ứng dụng vào trạng thái demo hoàn chỉnh.

---

## ✅ Công việc 8.1 – System Testing

### Nội dung kiểm thử

- Login/Register
- Create Task
- Submit Task
- Approve/Reject
- EXP
- Level
- Reward
- Achievement
- Activity Log

---

## ✅ Công việc 8.2 – Android Build

```bash
flutter build apk
```

---

## ✅ Công việc 8.3 – iOS Build

```bash
flutter build ios
```

---

# 📌 THỨ TỰ ƯU TIÊN TRIỂN KHAI

```txt
1. Chạy app ổn định
2. Navigation
3. Task CRUD
4. Submit / Approve
5. EXP / Level
6. Firebase
7. UI đẹp
8. Animation
9. Build Mobile
```

---

# 🎯 MVP CẦN HOÀN THÀNH

```txt
✔ Login/Register
✔ Parent Dashboard
✔ Child Home
✔ Parent tạo task
✔ Child submit task
✔ Parent approve task
✔ EXP tăng
✔ Level tăng
✔ Achievement unlock
✔ Reward history
✔ Activity log
✔ Firebase realtime
```

---

# 📌 TRẠNG THÁI DỰ ÁN
Đã hoang thành