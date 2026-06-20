/* ============================================================
   MEDIUM-STYLE ARTICLE — INTERACTIVITY
   All interactive features: scroll animations, counters,
   clap button, chat demo, reading progress, etc.
   ============================================================ */

document.addEventListener('DOMContentLoaded', () => {

  // ------- READING PROGRESS BAR -------
  const progressBar = document.getElementById('readingProgress');
  const article = document.getElementById('articleContainer');

  function updateReadingProgress() {
    const articleRect = article.getBoundingClientRect();
    const articleTop = articleRect.top + window.scrollY;
    const articleHeight = articleRect.height;
    const windowHeight = window.innerHeight;
    const scrolled = window.scrollY - articleTop;
    const total = articleHeight - windowHeight;
    const progress = Math.min(Math.max((scrolled / total) * 100, 0), 100);
    progressBar.style.width = progress + '%';
  }

  // ------- NAV SCROLL SHADOW -------
  const nav = document.getElementById('topNav');

  function updateNavShadow() {
    if (window.scrollY > 10) {
      nav.classList.add('scrolled');
    } else {
      nav.classList.remove('scrolled');
    }
  }

  // ------- SCROLL-TRIGGERED ANIMATIONS (Intersection Observer) -------
  const observerOptions = {
    root: null,
    rootMargin: '0px 0px -80px 0px',
    threshold: 0.15
  };

  const animationObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        // Don't unobserve — allows re-trigger if user scrolls back
      }
    });
  }, observerOptions);

  // Observe all animatable elements
  const animatables = [
    ...document.querySelectorAll('.service-card'),
    ...document.querySelectorAll('.tech-item'),
    ...document.querySelectorAll('.impact-card'),
    ...document.querySelectorAll('.feature-item'),
    ...document.querySelectorAll('.db-table'),
    ...document.querySelectorAll('.timeline-item'),
    ...document.querySelectorAll('.flow-step'),
    ...document.querySelectorAll('.fade-in-up'),
  ];

  animatables.forEach(el => animationObserver.observe(el));

  // ------- STATS COUNTER ANIMATION -------
  const statsSection = document.getElementById('statsSection');
  let statsAnimated = false;

  const statsObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting && !statsAnimated) {
        statsAnimated = true;
        animateCounters();
      }
    });
  }, { threshold: 0.3 });

  if (statsSection) {
    statsObserver.observe(statsSection);
  }

  function animateCounters() {
    const counters = document.querySelectorAll('.stat-number');
    counters.forEach(counter => {
      const target = parseInt(counter.getAttribute('data-target'));
      const duration = 2000;
      const startTime = performance.now();

      function updateCounter(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);

        // Ease-out cubic
        const eased = 1 - Math.pow(1 - progress, 3);
        const current = Math.round(eased * target);

        counter.textContent = current;

        if (progress < 1) {
          requestAnimationFrame(updateCounter);
        }
      }

      requestAnimationFrame(updateCounter);
    });
  }

  // ------- CHAT MOCKUP ANIMATION -------
  const mockChat = document.getElementById('mockChat');
  let chatAnimated = false;

  const chatObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting && !chatAnimated) {
        chatAnimated = true;
        animateChatMessages();
      }
    });
  }, { threshold: 0.3 });

  if (mockChat) {
    chatObserver.observe(mockChat);
  }

  function animateChatMessages() {
    const messages = mockChat.querySelectorAll('.mock-message');
    messages.forEach((msg, index) => {
      const delay = parseInt(msg.getAttribute('data-delay')) || 0;
      if (delay > 0 || index === 0) {
        setTimeout(() => {
          msg.style.animationDelay = '0s';
          msg.style.animationPlayState = 'running';
        }, delay);
      }
    });
  }

  // ------- NEGOTIATION INTERACTIVE BUTTONS -------
  const negoAccept = document.getElementById('negoAccept');
  const negoDecline = document.getElementById('negoDecline');
  const agreedMessage = document.getElementById('agreedMessage');

  if (negoAccept) {
    negoAccept.addEventListener('click', () => {
      const negoCard = negoAccept.closest('.mock-message');
      if (negoCard) {
        negoCard.style.display = 'none';
      }
      if (agreedMessage) {
        agreedMessage.style.display = 'block';
        agreedMessage.style.opacity = '1';
        agreedMessage.style.transform = 'translateY(0)';
      }
    });
  }

  if (negoDecline) {
    negoDecline.addEventListener('click', () => {
      const negoPrice = document.querySelector('.nego-price');
      if (negoPrice) {
        negoPrice.textContent = 'Rp 52.000';
        negoPrice.style.color = '#f57f17';
        setTimeout(() => {
          negoPrice.style.color = '#1565C0';
        }, 600);
      }
    });
  }

  // ------- CLAP BUTTON -------
  let clapCount = 247;
  const clapBtns = [document.getElementById('clapBtn'), document.getElementById('clapBtnBottom')];
  const clapCounts = [document.getElementById('clapCount'), document.getElementById('clapCountBottom')];

  clapBtns.forEach((btn, idx) => {
    if (!btn) return;
    btn.addEventListener('click', () => {
      clapCount++;
      btn.classList.add('clapped');

      // Update both counters
      clapCounts.forEach(el => {
        if (el) el.textContent = clapCount;
      });

      // Remove animation class to allow re-trigger
      setTimeout(() => {
        btn.classList.remove('clapped');
      }, 500);
    });
  });

  // ------- FOLLOW BUTTONS -------
  const followBtns = [
    document.getElementById('followBtn'),
    document.getElementById('followBtnBottom')
  ];

  followBtns.forEach(btn => {
    if (!btn) return;
    btn.addEventListener('click', () => {
      const isFollowed = btn.classList.toggle('followed');
      btn.textContent = isFollowed ? 'Following' : 'Follow';

      // Sync all follow buttons
      followBtns.forEach(otherBtn => {
        if (otherBtn && otherBtn !== btn) {
          if (isFollowed) {
            otherBtn.classList.add('followed');
            otherBtn.textContent = 'Following';
          } else {
            otherBtn.classList.remove('followed');
            otherBtn.textContent = 'Follow';
          }
        }
      });
    });
  });

  // ------- BOOKMARK BUTTON -------
  const bookmarkBtns = document.querySelectorAll('.bookmark-btn');
  bookmarkBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      btn.classList.toggle('saved');
    });
  });

  // ------- SHARE BUTTON -------
  const shareBtns = document.querySelectorAll('.share-btn');
  shareBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      if (navigator.share) {
        navigator.share({
          title: 'ITS Serabutan: Ketika Burnout Mahasiswa Jadi Ide Aplikasi',
          text: 'Platform jasa mahasiswa pertama di ITS Surabaya',
          url: window.location.href
        });
      } else {
        // Fallback: copy URL
        navigator.clipboard.writeText(window.location.href).then(() => {
          const toast = document.createElement('div');
          toast.textContent = '🔗 Link copied to clipboard!';
          toast.style.cssText = `
            position: fixed;
            bottom: 24px;
            left: 50%;
            transform: translateX(-50%);
            background: #333;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            font-family: var(--font-sans);
            font-size: 14px;
            z-index: 9999;
            animation: fadeInOut 2s ease forwards;
          `;
          document.body.appendChild(toast);
          setTimeout(() => toast.remove(), 2500);
        });
      }
    });
  });

  // Toast animation
  const toastStyle = document.createElement('style');
  toastStyle.textContent = `
    @keyframes fadeInOut {
      0% { opacity: 0; transform: translateX(-50%) translateY(10px); }
      20% { opacity: 1; transform: translateX(-50%) translateY(0); }
      80% { opacity: 1; transform: translateX(-50%) translateY(0); }
      100% { opacity: 0; transform: translateX(-50%) translateY(-10px); }
    }
  `;
  document.head.appendChild(toastStyle);

  // ------- FLOW STEPS AUTO-ANIMATE -------
  const flowSteps = document.querySelectorAll('.flow-step');
  let currentFlowStep = 0;
  let flowInterval = null;

  const flowObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting && !flowInterval) {
        startFlowAnimation();
      } else if (!entry.isIntersecting && flowInterval) {
        clearInterval(flowInterval);
        flowInterval = null;
      }
    });
  }, { threshold: 0.3 });

  const flowContainer = document.getElementById('flowSteps');
  if (flowContainer) {
    flowObserver.observe(flowContainer);
  }

  function startFlowAnimation() {
    // Show all steps first
    flowSteps.forEach(step => step.classList.add('visible'));

    // Then cycle active highlight
    flowInterval = setInterval(() => {
      flowSteps.forEach(step => step.classList.remove('active'));
      flowSteps[currentFlowStep].classList.add('active');

      const stepNum = flowSteps[currentFlowStep].querySelector('.step-number');
      if (stepNum) {
        stepNum.style.background = '#29B6F6';
        stepNum.style.color = 'white';
        stepNum.style.transform = 'scale(1.15)';

        setTimeout(() => {
          stepNum.style.background = '';
          stepNum.style.color = '';
          stepNum.style.transform = '';
        }, 1500);
      }

      currentFlowStep = (currentFlowStep + 1) % flowSteps.length;
    }, 2000);
  }

  // ------- SCROLL EVENT LISTENER -------
  let ticking = false;
  window.addEventListener('scroll', () => {
    if (!ticking) {
      requestAnimationFrame(() => {
        updateReadingProgress();
        updateNavShadow();
        ticking = false;
      });
      ticking = true;
    }
  });

  // Initial calls
  updateReadingProgress();
  updateNavShadow();

  // ------- SMOOTH SCROLL FOR TOC (if added) -------
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });

});
