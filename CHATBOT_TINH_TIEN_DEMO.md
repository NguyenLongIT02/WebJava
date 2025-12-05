# 🛒 Chatbot Tính Tiền Tự Động - Demo

## ✨ Tính năng mới: Tự động tính tiền khi mua hàng

### 📝 Các trường hợp xử lý:

#### 1️⃣ Mua với số lượng cụ thể
**Input:** "Mua 5 quả táo"

**Output:**
```
🛒 **Đơn hàng của bạn:**

• Táo x 5 = $75
💰 **Tổng cộng: $75**

📦 Còn lại: 95 sản phẩm
🚚 Giao hàng trong 2h!

Để đặt hàng, vui lòng:
1️⃣ Thêm vào giỏ hàng trên website
2️⃣ Hoặc gọi: 0988 123 456
```

---

#### 2️⃣ Mua nhiều → Tự động giảm giá 10%
**Input:** "Mua 20 quả táo"

**Output:**
```
🛒 **Đơn hàng của bạn:**

• Táo x 20 = $300
🎉 Giảm giá 10%: -$30
💰 **Tổng cộng: $270**

📦 Còn lại: 80 sản phẩm
🚚 Giao hàng trong 2h!

Để đặt hàng, vui lòng:
1️⃣ Thêm vào giỏ hàng trên website
2️⃣ Hoặc gọi: 0988 123 456
```

---

#### 3️⃣ Mua không có số lượng
**Input:** "Mua táo"

**Output:**
```
🛒 Bạn muốn mua bao nhiêu **Táo**?
💰 Giá: $15/sản phẩm
📦 Còn: 100 sản phẩm

Ví dụ: "Mua 5 táo"
```

---

#### 4️⃣ Mua nhưng không nói sản phẩm
**Input:** "Mua 5"

**Output:**
```
🤔 Bạn muốn mua sản phẩm nào? Vui lòng cho tôi biết tên sản phẩm.
Ví dụ: "Mua 5 quả táo"
```

---

#### 5️⃣ Chỉ hỏi cách mua
**Input:** "Đặt hàng như thế nào?"

**Output:**
```
🛒 **Cách đặt hàng:**

1️⃣ Chọn sản phẩm trên website
2️⃣ Thêm vào giỏ hàng
3️⃣ Điền thông tin giao hàng
4️⃣ Chọn thanh toán & xác nhận

📞 Hoặc gọi: **0988 123 456** để đặt qua điện thoại!
```

---

## 🎯 Logic hoạt động:

```
User: "Mua 5 quả táo"
  ↓
1. Phát hiện từ khóa "mua"
  ↓
2. Tìm số lượng: "5"
  ↓
3. Tìm sản phẩm: "táo"
  ↓
4. Tính tiền: 5 x $15 = $75
  ↓
5. Kiểm tra giảm giá:
   - Nếu >$200 → giảm 10%
   - Nếu ≤$200 → không giảm
  ↓
6. Hiển thị kết quả
```

---

## 🧪 Test Cases:

| Input | Kết quả mong đợi |
|-------|------------------|
| "Mua 5 quả táo" | Tính tiền: $75 |
| "Mua 20 quả táo" | Tính tiền: $300 - $30 = $270 |
| "Đặt 3 kg cà chua" | Tính tiền cà chua x3 |
| "Mua táo" | Hỏi số lượng |
| "Mua 10" | Hỏi sản phẩm nào |
| "Đặt hàng" | Hướng dẫn đặt hàng |

---

## 💡 Ưu điểm:

✅ **Tự động tính tiền** - không cần user tự tính
✅ **Áp dụng giảm giá** - tự động giảm 10% nếu >$200
✅ **Thông minh** - phân biệt được các trường hợp khác nhau
✅ **Nhanh** - trả lời ngay lập tức (<100ms)
✅ **Thân thiện** - gợi ý rõ ràng nếu thiếu thông tin

---

## 🚀 Hãy test ngay!

Restart server và thử:
1. "Mua 5 quả táo"
2. "Mua 20 quả táo" (để thấy giảm giá)
3. "Đặt 3 kg cà chua"
4. "Mua táo" (không số lượng)
