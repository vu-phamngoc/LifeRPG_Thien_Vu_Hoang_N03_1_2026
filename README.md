# 🎮 Life RPG – Ứng dụng quản lý nhiệm vụ trẻ em theo cơ chế Gamification

## 📌 Tổng quan dự án

Life RPG là ứng dụng quản lý nhiệm vụ dành cho trẻ em, được phát triển theo định hướng gamification nhằm tăng động lực học tập và hoàn thành công việc hằng ngày thông qua các cơ chế giống trò chơi như EXP, Level, Achievement và Reward.

Ứng dụng cho phép phụ huynh giao nhiệm vụ, theo dõi tiến độ và xác nhận kết quả hoàn thành của trẻ em. Sau khi nhiệm vụ được xác nhận, hệ thống sẽ tự động cộng điểm kinh nghiệm, cập nhật level và mở khóa các phần thưởng hoặc thành tựu tương ứng.

Dự án được xây dựng bằng Flutter với mục tiêu hỗ trợ đa nền tảng bao gồm Android, iOS và Web.

---

# 🎯 Mục tiêu dự án

Dự án được thực hiện với các mục tiêu chính sau:

- Xây dựng hệ thống quản lý nhiệm vụ dành riêng cho mô hình phụ huynh – trẻ em.
- Áp dụng cơ chế gamification để tăng tính tương tác và động lực cho trẻ em.
- Thiết kế quy trình xác nhận nhiệm vụ thông qua phụ huynh nhằm đảm bảo tính minh bạch.
- Phát triển ứng dụng Flutter theo kiến trúc rõ ràng, dễ mở rộng và dễ bảo trì.
- Thực hành quy trình phát triển ứng dụng thực tế với Flutter và Firebase.

---

# 🧩 Bài toán thực tế

Trong quá trình quản lý trẻ em, các công việc như học tập, làm bài tập hoặc hoàn thành việc nhà thường thiếu tính tương tác và động lực duy trì lâu dài.

Nhiều trẻ em có xu hướng xem các nhiệm vụ hằng ngày là bắt buộc và nhàm chán, dẫn đến việc khó hình thành tính tự giác.

Life RPG được xây dựng nhằm giải quyết vấn đề này bằng cách chuyển đổi các nhiệm vụ thường ngày thành trải nghiệm mang tính trò chơi hóa, nơi trẻ em có thể:

- Nhận EXP khi hoàn thành nhiệm vụ
- Tăng cấp độ (Level)
- Mở khóa Achievement
- Nhận phần thưởng
- Theo dõi tiến trình phát triển của bản thân

Đồng thời phụ huynh vẫn giữ vai trò quản lý và xác nhận kết quả thực hiện.

---

# 👨‍👩‍👧 Đối tượng sử dụng

## 👨‍👩‍👧‍👦 Phụ huynh

Phụ huynh là người quản lý chính của hệ thống với các chức năng:

- Tạo nhiệm vụ
- Giao nhiệm vụ cho trẻ em
- Theo dõi tiến độ
- Xác nhận hoặc từ chối nhiệm vụ
- Quản lý phần thưởng
- Theo dõi lịch sử hoạt động

## 🧒 Trẻ em

Trẻ em là người thực hiện nhiệm vụ với các chức năng:

- Xem danh sách nhiệm vụ
- Báo cáo hoàn thành nhiệm vụ
- Theo dõi EXP và Level
- Xem Achievement
- Xem phần thưởng và lịch sử hoạt động

---

# 🚀 Định hướng phát triển dự án

Dự án được phát triển theo định hướng:

```txt
MVP trước → Hoàn thiện logic → Firebase → UI/UX nâng cao
```

Trong giai đoạn đầu, dự án tập trung vào việc hoàn thiện luồng hoạt động chính và kiến trúc hệ thống trước khi triển khai các chức năng nâng cao.

---

# 🔄 Luồng hoạt động chính

## 👨‍👩‍👧 Luồng phụ huynh

```txt
Đăng nhập
→ Quản lý danh sách con
→ Tạo nhiệm vụ
→ Giao nhiệm vụ
→ Xem nhiệm vụ đã gửi hoàn thành
→ Approve / Reject
→ Theo dõi EXP, Reward và Activity Log
```

## 🧒 Luồng trẻ em

```txt
Đăng nhập
→ Xem nhiệm vụ được giao
→ Báo cáo hoàn thành nhiệm vụ
→ Chờ phụ huynh xác nhận
→ Nhận EXP và Reward
→ Theo dõi Level và Achievement
```

---

# 📋 Trạng thái nhiệm vụ

Mỗi nhiệm vụ trong hệ thống sẽ trải qua các trạng thái sau:

| Trạng thái | Ý nghĩa |
|---|---|
| `pending` | Nhiệm vụ vừa được tạo |
| `submitted` | Trẻ em đã báo cáo hoàn thành |
| `approved` | Phụ huynh xác nhận hoàn thành |
| `rejected` | Phụ huynh từ chối xác nhận |

Đây là luồng xử lý trung tâm của toàn bộ hệ thống.

---

# 🏗️ Kiến trúc hệ thống

Dự án được tổ chức theo hướng phân tách rõ ràng giữa giao diện, dữ liệu và business logic nhằm đảm bảo khả năng mở rộng lâu dài.

## 📁 Cấu trúc thư mục chính

```txt
lib/
├── main.dart
├── app.dart
├── core/
├── models/
├── providers/
├── services/
├── screens/
│   ├── auth/
│   ├── parent/
│   ├── child/
│   └── shared/
└── routes/
```

---

# ⚙️ Thành phần chính của hệ thống

## 📦 Models

Chứa cấu trúc dữ liệu của hệ thống:

- ParentModel
- ChildModel
- TaskModel
- AchievementModel
- RewardModel
- ActivityModel

## 🔄 Providers

Quản lý state và business logic của ứng dụng.

## 🔌 Services

Làm việc với Firebase Authentication và Firestore.

## 🖥️ Screens

Quản lý giao diện người dùng theo từng nhóm chức năng.

---

# 🛠️ Công nghệ sử dụng

| Công nghệ | Vai trò |
|---|---|
| Flutter | Xây dựng giao diện đa nền tảng |
| Dart | Ngôn ngữ lập trình chính |
| Provider | Quản lý state |
| Firebase Authentication | Xác thực người dùng |
| Cloud Firestore | Lưu trữ dữ liệu realtime |

---

# 📅 Kế hoạch triển khai

## Giai đoạn 1 – Hoàn thiện cấu trúc project

- Refactor thư mục
- Chuẩn hóa kiến trúc
- Hoàn thiện routing
- Chạy ổn định trên Web

## Giai đoạn 2 – Hoàn thiện chức năng cơ bản

- Login / Register
- Parent Dashboard
- Child Home
- Task CRUD
- Submit Task
- Approve / Reject Task

## Giai đoạn 3 – Gamification System

- EXP System
- Level System
- Achievement
- Reward
- Activity Log

## Giai đoạn 4 – Firebase Integration

- Firebase Authentication
- Cloud Firestore
- Realtime Update

## Giai đoạn 5 – UI/UX & Animation

- Thiết kế giao diện hoàn chỉnh
- Animation Level Up
- Achievement Badge
- Responsive UI
- Dark Mode

## Giai đoạn 6 – Testing & Deployment

- Kiểm thử toàn bộ hệ thống
- Build Android APK
- Build iOS
- Demo và hoàn thiện báo cáo

---

# ⭐ Chức năng trọng tâm của dự án

Các chức năng cốt lõi bao gồm:

- Quản lý nhiệm vụ giữa phụ huynh và trẻ em
- Xác nhận hoàn thành nhiệm vụ
- Hệ thống EXP và Level
- Achievement và Reward
- Activity Tracking
- Gamification UI

---

# 🔮 Định hướng mở rộng trong tương lai

Trong các phiên bản tiếp theo, dự án có thể mở rộng thêm:

- Notification realtime
- Daily Quest
- Weekly Challenge
- Leaderboard
- Multiplayer Family System
- Cloud Sync
- AI Suggestion for Tasks
- Gamification Analytics

---

# 🎯 Mục tiêu cuối cùng

Hoàn thiện ứng dụng Life RPG như một nền tảng hỗ trợ phụ huynh quản lý trẻ em theo hướng tích cực, hiện đại và mang tính tương tác cao thông qua gamification.

Ứng dụng hướng đến trải nghiệm vừa mang tính giáo dục vừa tạo động lực phát triển thói quen tốt cho trẻ em trong môi trường gia đình.

---

# 📱 Nền tảng hỗ trợ

- Android
- iOS
- Web

---

# 👨‍💻 Trạng thái dự án

```txt
Đang trong quá trình phát triển và hoàn thiện kiến trúc hệ thống.
```