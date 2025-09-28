---
layout: post
title: "Optimizing video size with FFmpeg for better web performance"
date: 2025-09-28
category: Web
thumbnail: /assets/images/posts/ffmpeg-reduce-video-size.png
excerpt: Learn how to optimize video files for web performance using FFmpeg, reducing file size while maintaining quality for better loading times.
---

When building a website with video content, file size plays a crucial role in loading performance. In this post, I'll share my experience optimizing a background video for my blog, reducing it from 53MB to just 1MB while maintaining acceptable quality.

## Planning the Optimization

The goal was to improve the blog's loading time by reducing the video file size. Here's what we aimed to achieve:

1. Maintain acceptable visual quality for a background video
2. Reduce file size significantly
3. Keep smooth motion for a good user experience

## The Optimization Process

### Step 1: Initial Compression (53MB → 8MB)

First, we reduced the video from 53MB to 8MB with these FFmpeg parameters:

```bash
ffmpeg -i video-bg.mp4 -vf "scale=1280:-1" -c:v libx264 -crf 28 -preset slow -movflags +faststart output.mp4
```

Parameters explained:
- `scale=1280:-1`: Resize to 1280px width, maintaining aspect ratio
- `crf 28`: Moderate compression quality (lower number means better quality)
- `preset slow`: Slower encoding for better compression
- `movflags +faststart`: Optimize for web playback

### Step 2: Further Compression (8MB → 2.5MB)

Next, we reduced it further from 8MB to 2.5MB:

```bash
ffmpeg -i video-bg.mp4 -vf "scale=960:-1,fps=24" -c:v libx264 -crf 32 -preset slow -movflags +faststart output.mp4
```

Parameters explained:
- `scale=960:-1`: Resize to 960px width, maintaining aspect ratio
- `fps=24`: Reduce framerate to 24fps
- `crf 32`: Compression quality (range 0-51, higher means more compression)
- `preset slow`: Slower encoding for better compression
- `movflags +faststart`: Optimize for web playback

### Step 2: Further Optimization (2.5MB → 1MB)

For even smaller file size, we adjusted the parameters:

```bash
ffmpeg -i video-bg.mp4 -vf "scale=854:-1,fps=20" -c:v libx264 -crf 35 -preset slow -movflags +faststart output.mp4
```

Changes made:
- Reduced resolution to 854px width
- Lowered framerate to 20fps
- Increased CRF to 35 for higher compression

## Size Comparison

Here's how the file size changed through optimization:
1. Original: 53MB (3840x2160, 25fps)
2. First compression: 8MB (1280x720, 25fps)
3. Second compression: 2.5MB (960x540, 24fps)
4. Ultra compressed: 1MB (854x480, 20fps)

## Web Performance Tips

To further improve video loading performance, consider:

1. CDN Implementation
   - Use a Content Delivery Network to serve videos from locations closer to users
   - Reduces latency and improves loading times

2. Video Caching
   - Set appropriate cache headers:

    ```nginx
    location ~* \.(?:mp4|webm)$ {
        expires 1y;
        add_header Cache-Control "public, no-transform";
    }
    ```

   - Helps returning visitors load content faster

3. Lazy Loading
   - Load video only when needed
   - Use loading="lazy" attribute for video elements
   
    ```html
    <video loading="lazy" autoplay muted loop>
        <source src="video-bg.mp4" type="video/mp4">
    </video>
    ```

4. Responsive Video
   - Serve different video sizes based on screen size
   - Use media queries to load appropriate versions

## Conclusion

By optimizing our video file, we achieved:
- 98% reduction in file size (53MB → 1MB)
- Maintained acceptable quality for background video
- Improved page load performance

Remember to always balance quality and file size based on your specific needs. For background videos, you can be more aggressive with compression since the video isn't the main focus.