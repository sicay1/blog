---
layout: post
title: "Giải quyết lỗi Podman Compose trên macOS: Operation not permitted khi mount volume"
date: 2025-10-12
category: DevOps
thumbnail: /assets/images/posts/podman.jpg
excerpt: Chia sẻ kinh nghiệm giải quyết lỗi 'operation not permitted' khi sử dụng Podman Compose trên macOS, từ việc cài đặt lại đến di chuyển thư mục project.
---

Khi làm việc với Podman trên macOS, tôi gặp phải lỗi khi chạy `podman compose up` với một container Apache đơn giản. Lỗi này liên quan đến việc mount volume và quyền truy cập. Dưới đây là quá trình tôi giải quyết từng bước.

## Mô tả lỗi

Lỗi xuất hiện khi chạy `podman compose up`:

```
✘ Container my-apache-server  Error response from daemon: make cli opts(): making volume ...                              0.2s 
Error response from daemon: make cli opts(): making volume mountpoint for volume /Users/tonytruong/Documents/podman/httpd_example/myweb: mkdir /Users/tonytruong/Documents: operation not permitted
Error: executing /usr/local/bin/docker-compose up: exit status 1
```

File `compose.yml` của tôi khá cơ bản:

```yaml
version: '3.8' # Specify the Docker Compose file format version

services:
  web: # Define a service named 'web'
    image: httpd:latest # Use the latest official httpd image from Docker Hub
    container_name: my-apache-server # Give the container a custom name
    ports:
      - "80:80" # Map host port 80 to container port 80
    volumes:
      - ./myweb:/usr/local/apache2/htdocs
    restart: always # Ensure the container restarts automatically if it stops
```

## Quá trình giải quyết

### Bước 1: Kiểm tra cài đặt Podman

Ban đầu, tôi nghi ngờ nguyên nhân do cài Podman Desktop bằng Homebrew. Tôi đã gỡ bỏ và cài lại từ binary chính thức trên trang chủ Podman. Tuy nhiên, chạy lại `podman compose up` vẫn gặp lỗi tương tự.

### Bước 2: Kiểm tra quyền file

Tôi tìm hiểu và thấy lỗi liên quan đến quyền truy cập file. Đã thử `chmod 777` trên thư mục liên quan, nhưng không giải quyết được vấn đề.

### Bước 3: Kiểm tra Podman machine

Tôi nghĩ có thể do Podman machine khi khởi tạo cần mount volume từ `$HOME`. Đã thử tạo lại Podman machine bằng `podman machine reset` và `podman machine init`, nhưng lỗi vẫn tiếp diễn.

### Bước 4: Thử các giải pháp từ AI

AI gợi ý thêm `userns_mode: keep-id` vào file compose.yml:

```yaml
services:
  web:
    # ... other configs
    userns_mode: keep-id
```

Nhưng vẫn không hiệu quả.

### Bước 5: Di chuyển thư mục project

Cuối cùng, AI đề xuất lưu project ở vị trí khác ngoài thư mục Documents. Tôi đã di chuyển thư mục chứa file compose từ `/Users/tonytruong/Documents/podman/httpd_example/` đến `/Users/tonytruong/folder1/`. Sau khi chạy lại `podman compose up`, mọi thứ hoạt động bình thường.

## Nguyên nhân và bài học

Nguyên nhân chính là do macOS có các hạn chế về quyền truy cập đối với thư mục Documents khi Podman cố gắng tạo mount point. Việc di chuyển project ra ngoài vùng này đã giải quyết vấn đề.

Bài học rút ra: Khi gặp lỗi permission với Podman trên macOS, hãy xem xét vị trí lưu trữ project và thử di chuyển ra ngoài các thư mục được bảo vệ như Documents, Desktop, Downloads.

## Kết luận

Việc giải quyết lỗi này giúp tôi hiểu sâu hơn về cách Podman tương tác với hệ thống file trên macOS. Hy vọng chia sẻ này hữu ích cho ai đang gặp vấn đề tương tự.