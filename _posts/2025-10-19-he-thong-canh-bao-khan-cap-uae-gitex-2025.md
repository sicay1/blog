---
layout: post
title: "Hệ thống cảnh báo khẩn cấp không dây tại UAE - Trải nghiệm thực tế tại Gitex 2025"
date: 2025-10-19
categories: [technology, uae, emergency-alert]
thumbnail: /assets/images/posts/gitex.png
excerpt: Khám phá hệ thống cảnh báo khẩn cấp không dây của UAE qua trải nghiệm thực tế trong tuần triển lãm Gitex 2025 tại Dubai.
---

Tuần này Dubai đang diễn ra triển lãm Gitex 2025, một sự kiện công nghệ lớn được tổ chức tại World Trade Center. Mặc dù hông tham gia, nhưng tất cả mọi người trong công ty đều nhận được một thông báo đặc biệt từ hệ thống cảnh báo khẩn cấp của UAE. 

## Wifi Alert

### Thông báo trên các thiết bị di động

Tất cả các thiết bị di động trong công ty đều nhận được thông báo cùng lúc, bao gồm cả Android và iPhone:

**Thông báo trên Android:**
![Android phone alert](/assets/images/posts/wifialert_android_screen_notify.jpg)

**Thông báo trên iPhone:**
![IOS phone alert](/assets/images/posts/wifialert_ios_screen_notify.png)

### Nguồn gốc thông báo từ đâu?

Ban đầu tôi nghĩ thông báo này đến từ SIM DU (nhà mạng địa phương) qua đường PSTN, hoặc có thể từ các ứng dụng chính phủ UAE như UAE PASS hay MOHRE. Tuy nhiên, điều thú vị là chiếc iPhone công ty (chủ yếu dùng để test game) không có SIM card và cũng không cài đặt bất kỳ ứng dụng chính phủ nào, chỉ kết nối WiFi công ty, mà nhiều khi mình bật `Airplane` để tiết kiệm pin nữa. Vậy mà Iphone mình vẫn nhận được thông báo (không nhớ rõ là hôm đó có bật Airplane hông nữa :see_no_evil: ).

## Cách thức hoạt động của hệ thống

### Trên iOS

Sau khi kiểm tra trong Settings, tôi phát hiện ra rằng iOS có sẵn tính năng này trong phần Notifications. Điều này có thể do Apple đã tích hợp sẵn cho các thiết bị bán tại UAE theo yêu cầu của chính phủ địa phương.

![IOS Settings](/assets/images/posts/wifialert_ios_1.png)
![IOS Notifications](/assets/images/posts/wifialert_ios_2.png)

### Trên Android

Tương tự, Android (máy mua tại Việt Nam) cũng có tính năng này trong phần Lock screen notification và Wireless Emergency Alerts:

![Android Settings](/assets/images/posts/wifialert_android_1.jpg)
![Android Screen Lock](/assets/images/posts/wifialert_android_2.jpg)
![Android Wireless Emergency Alerts](/assets/images/posts/wifialert_android_3.jpg)
![Android Emergency Alert History](/assets/images/posts/wifialert_android_4.jpg)

## Tìm hiểu về hệ thống cảnh báo khẩn cấp UAE

### [Cell Broadcast Technology](https://en.wikipedia.org/wiki/Cell_Broadcast)

Hệ thống cảnh báo khẩn cấp của UAE sử dụng công nghệ **Cell Broadcast**, một chuẩn quốc tế cho phép gửi thông báo đến tất cả các thiết bị di động trong một khu vực địa lý cụ thể mà không cần biết số điện thoại hay thông tin cá nhân của người dùng.

Tài liệu chính thức từ UAE 

https://tdra.gov.ae/-/media/About/Type-Approval/Technical-Standards-2021/TS-FS-001-Emergency-Broadcast.ashx

Mình Google tìm thấy bài báo nó về vụ alert này từ năm 2024

https://gulfnews.com/living-in-uae/safety-security/rain-in-uae-did-you-receive-a-public-safety-alert-here-is-all-you-need-to-know-about-the-national-early-warning-system-1.1700224017503

### Các loại cảnh báo

UAE triển khai nhiều loại cảnh báo khác nhau:

1. **Cảnh báo thời tiết khắc nghiệt** - Bão cát, mưa lớn, nhiệt độ cực cao
2. **Cảnh báo an ninh** - Các tình huống khẩn cấp về an ninh quốc gia
3. **Cảnh báo sức khỏe công cộng** - Như đã thấy trong thời kỳ COVID-19
4. **Cảnh báo giao thông** - Tai nạn nghiêm trọng, đóng cửa đường cao tốc
5. **Thông báo sự kiện lớn** - Như trong trường hợp Gitex 2025

### Ưu điểm của hệ thống

- **Phủ sóng toàn diện**: Không phụ thuộc vào SIM card hay ứng dụng cụ thể
- **Tốc độ cao**: Có thể gửi đến hàng triệu thiết bị trong vài giây
- **Không tốn data**: Sử dụng kênh truyền tín hiệu riêng biệt
- **Hoạt động offline**: Không cần kết nối internet

### So sánh với các nước khác

UAE là một trong những quốc gia tiên phong trong việc triển khai hệ thống cảnh báo khẩn cấp toàn diện:

- **Mỹ**: [WEA](https://www.fcc.gov/consumers/guides/wireless-emergency-alerts) (Wireless Emergency Alerts)
- **Nhật Bản**: J-Alert system
- **Hàn Quốc**: CBS (Cell Broadcast Service)
- **EU**: EU-Alert

## Kinh nghiệm và lời khuyên

### Cho người dùng tại UAE

1. **Không tắt thông báo**: Các cảnh báo này có thể cứu mạng trong tình huống khẩn cấp
2. **Hiểu các mức độ cảnh báo**: Học cách phân biệt giữa thông báo thông tin và cảnh báo khẩn cấp
3. **Chuẩn bị phương án ứng phó**: Có kế hoạch sẵn sàng cho các tình huống khẩn cấp

### Cho nhà phát triển

1. **Test ứng dụng**: Đảm bảo ứng dụng hoạt động tốt khi có emergency alert
2. **UX considerations**: Thiết kế giao diện không bị gián đoạn bởi alert
3. **Integration**: Có thể tích hợp với emergency API nếu cần thiết

## Kết luận

Hệ thống cảnh báo khẩn cấp không dây của UAE là một ví dụ xuất sắc về cách công nghệ có thể được sử dụng để bảo vệ người dân. Việc trải nghiệm trực tiếp trong tuần Gitex 2025 đã cho thấy tính hiệu quả và độ bao phủ ấn tượng của hệ thống này.

Với sự phát triển không ngừng của công nghệ và cam kết của chính phủ UAE trong việc xây dựng smart city, hệ thống này chắc chắn sẽ tiếp tục được cải tiến và mở rộng trong tương lai.