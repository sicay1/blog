---
layout: post
title: "Phân tích one line command tocdo.net"
date: 2025-10-26
categories: [networking, web-development, curl, nginx]
thumbnail: /assets/images/251006/server_dis.jpg
excerpt: Khám phá cách tocdo.net phân biệt giữa curl và browser để trả về nội dung khác nhau, từ việc debug server lag đến reverse engineering một website thú vị.
---

Tuần này server mình gặp vấn đề, nhiều người chơi bị lag và mất kết nối. Ban đầu tôi nghĩ nguyên nhân là do con cá mập 🤔 ([như tin tức này](https://thanhnien.vn/cap-quang-bien-apg-lai-gap-su-co-185251020093130971.htm)). Thông thường việc này chỉ ảnh hưởng trong thời gian ngắn vì các ISP cần định tuyến lại băng thông. Server mình thì ở VN và người chơi cũng ở VN, nên con cá mập ngoài biển thì đâu ảnh hưởng gì. Nhưng sau 2-3 ngày vấn đề vẫn tiếp diễn, mình đã liên hệ với bộ phận hỗ trợ của nhà cung cấp server.

## Các lệnh mà bên hổ trợ đã sử dụng

Họ yêu cầu chạy một số lệnh và gửi kết quả cho họ (1 phần do mình không muốn họ vào server, và 1 phần thì họ kiu cung cấp ultraview, trong khi mình xài MacOS 😆). Tóm tắt các lệnh bao gồm:
- Ping gateway
- Ping một số IP từ các ISP khác nhau ở VN (FPT, VNPT, Viettel)
- Ping tới 8.8.8.8
- Chạy speedtest-cli

Sau khi xong việc với supporter, tôi nghĩ tại sao không có một bash script để làm việc này tự động? Sau khi google, tôi tìm được website [tocdo.net](https://tocdo.net/) - chính xác là thứ tôi đang tìm kiếm.

## Tìm hiểu Website tocdo.net

Website này cung cấp một lệnh một dòng để test tốc độ:

```bash
curl -Lso- tocdo.net | bash
```

Nhưng khoan đã... 🤔

1. Script này có an toàn để chạy không?
2. Khi tôi mở tocdo.net, nó hiển thị một trang web HTML, vậy bash script ở đâu? Tại sao curl khác với Chrome?
3. Có thể tạo request đến https://tocdo.net trong Postman và nhận response là bash script không?

![Postman request]({{ site.url }}/assets/images/251006/postman1.png)

## Bí mật đằng sau tocdo.net

cURL với browser khác nhau quan trọng nhất là **user-agent**, Mình thử test bằng Postman.

### Test với Postman

Sử dụng header mặc định của Postman:
![Postman default header]({{ site.url }}/assets/images/251006/postman1.png)

Xóa tất cả header:
![Postman no header]({{ site.url }}/assets/images/251006/postman2.png)

Sử dụng custom header:
![Postman custom header]({{ site.url }}/assets/images/251006/postman3.png)

**tất cả đều trả về html**

Theo response header trả về thì họ sử dụng `nginx server`.

![Nginx server]({{ site.url }}/assets/images/251006/postman_server_nginx.png)

### Phát hiện quan trọng về HTTP vs HTTPS

Sau 30 phút thử nghiệm và google + hỏi AI, tôi phát hiện ra rằng curl mặc định sẽ gọi HTTP.

Test mở bằng HTTP:
![Chrome console HTTP]({{ site.url }}/assets/images/251006/chrome_console.png)

**Postman với setting không redirect:**
![Postman redirect setting]({{ site.url }}/assets/images/251006/postman_redirect_setting.png)

![Postman no redirect]({{ site.url }}/assets/images/251006/postman_noredirect.png)

### Flow của tocdo.net

Vậy luồng hoạt động có thể sẽ là:

```
HTTP → redirect HTTPS → user-agent → curl  → response bash script
                                   → other → response website

HTTPS → luôn response website
```

### Kiểm nghiệm

Postman với HTTP redirect off:

![Postman HTTP redirect off]({{ site.url }}/assets/images/251006/postman_http_redirectoff.png)

Postman với HTTP redirect on:

![Postman HTTP redirect on]({{ site.url }}/assets/images/251006/postman_http_redirecton.png)

Test với curl HTTP:

![Curl HTTP]({{ site.url }}/assets/images/251006/curl_http.png)

Test với curl HTTPS:

![Curl HTTPS]({{ site.url }}/assets/images/251006/curl_https.png)

## Tự tạo một hệ thống tương tự

Dựa trên những gì đã phân tích, tôi (này là nhờ AI viết nhá 😅, chưa test luôn) sẽ tạo một nginx config tương tự để hiểu rõ hơn cách thức hoạt động.

### Nginx Configuration

```nginx
server {
    listen 80;
    server_name localhost;
    
    location / {
        # Check if user-agent contains 'curl'
        if ($http_user_agent ~* curl) {
            return 200 'echo "This is a bash script for curl users"\necho "Running speed test..."\necho "Your IP: $(curl -s ifconfig.me)"\necho "Test completed!"';
            add_header Content-Type text/plain;
        }
        
        # For all other user agents, serve the website
        try_files $uri $uri/ /index.html;
    }
}

server {
    listen 443 ssl;
    server_name localhost;
    
    # SSL configuration (self-signed for demo)
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    
    location / {
        # Always serve website for HTTPS requests
        try_files $uri $uri/ /index.html;
    }
}
```

### Docker Compose Setup

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
      - ./static-pages:/usr/share/nginx/html
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - setup-ssl

  setup-ssl:
    image: alpine/openssl
    volumes:
      - ./ssl:/ssl
    command: >
      sh -c "
        if [ ! -f /ssl/nginx.key ]; then
          openssl req -x509 -nodes -days 365 -newkey rsa:2048 
          -keyout /ssl/nginx.key 
          -out /ssl/nginx.crt 
          -subj '/C=VN/ST=HCM/L=HCM/O=Test/CN=localhost'
        fi
      "
```

### Static Pages

**static-pages/index.html (Website cho browser):**
```html
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Speed - Website</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        .container { max-width: 800px; margin: 0 auto; }
        .highlight { background-color: #f0f8ff; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Website Test Speed</h1>
        <div class="highlight">
            <h2>Cách sử dụng:</h2>
            <p>Để chạy test speed, sử dụng lệnh:</p>
            <code>curl -Lso- localhost | bash</code>
        </div>
        <p>Website này phân biệt giữa curl và browser để trả về nội dung khác nhau!</p>
    </div>
</body>
</html>
```

## Kết luận và hướng phát triển

Qua trang tocdo.net, tôi đã hiểu được:

1. **Cách phân biệt user-agent**: Nginx có thể check user-agent để trả về nội dung khác nhau (bài viết giải thích về user agent https://vietnix.vn/user-agent/)
2. **HTTP vs HTTPS routing**: Có thể sử dụng protocol khác nhau cho mục đích khác nhau  
3. **Security considerations**: one line command khá tiện nhưng cần cẩn thận khi chạy, nhất là các script từ internet

Mình sẽ tiếp tục nghiên cứu về script của tocdo.net, có thể sẽ có ý tưởng để cải thiện hay nâng cấp 😇📖.