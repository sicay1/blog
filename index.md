---
layout: home
---  

<div class="minimal-landing">
  <video autoplay muted loop id="bgVideo" playsinline>
    <source src="./assets/video-bg.mp4" type="video/mp4">
  </video>
  
  <div class="content-wrapper">
    <div class="center-content">
      <h1>{{ site.author.name }}</h1>
      <div class="divider"></div>
      <p class="description">Exploring the intersection of technology and creativity through thoughtful code, innovative solutions, and continuous learning.</p>
      <p class="description">{{ site.author.description }}</p>
      <div class="cta-container">
        <a href="./blog" class="primary-cta">My Blog</a>
        <a href="{{ site.author.github }}" class="secondary-cta">About Me</a>
      </div>
    </div>
    <div class="scroll-indicator">
      <div class="mouse">
        <div class="wheel"></div>
      </div>
      <div class="arrow"></div>
    </div>
  </div>
</div>
