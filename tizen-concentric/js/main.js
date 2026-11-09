(function () {
    'use strict';

    const canvas = document.getElementById('watchface-canvas');
    const ctx = canvas.getContext('2d');
    const toastEl = document.getElementById('toast');

    // Official Pixel Concentric color palette from watchface.xml
    const COLORS = [
        { name: 'Cloud', hex: '#a7a7a7' },
        { name: 'Snow', hex: '#ffffff' },
        { name: 'Watermelon', hex: '#e96868' },
        { name: 'Tangerine Red', hex: '#f97254' },
        { name: 'Gold', hex: '#f4af65' },
        { name: 'Sunshine', hex: '#e6d469' },
        { name: 'Mint', hex: '#88c58e' },
        { name: 'Peppermint', hex: '#6ee294' },
        { name: 'Lime', hex: '#b7e26e' },
        { name: 'Turquoise', hex: '#83d7ba' },
        { name: 'Ocean', hex: '#79b1f3' },
        { name: 'Azure', hex: '#86b0fa' },
        { name: 'Aquamarine', hex: '#80f5e2' },
        { name: 'Lavender', hex: '#9281ef' },
        { name: 'Rose', hex: '#ff8ed3' }
    ];

    // Exact 12 number positions from watchface.xml for Minutes (320x320 group at x=65, y=65)
    const MINUTE_POSITIONS = [
        { label: '00', x: 261 + 20, y: 145 + 15 },
        { label: '05', x: 245 + 20, y: 85 + 15 },
        { label: '10', x: 201 + 20, y: 40 + 15 },
        { label: '15', x: 140 + 20, y: 24 + 15 },
        { label: '20', x: 80 + 20, y: 40 + 15 },
        { label: '25', x: 35 + 20, y: 85 + 15 },
        { label: '30', x: 19 + 20, y: 145 + 15 },
        { label: '35', x: 35 + 20, y: 206 + 15 },
        { label: '40', x: 80 + 20, y: 250 + 15 },
        { label: '45', x: 140 + 20, y: 266 + 15 },
        { label: '50', x: 201 + 20, y: 250 + 15 },
        { label: '55', x: 245 + 20, y: 206 + 15 }
    ];

    // Radius for Seconds numbers (from x=392+20=412, center=225 -> r=187)
    const SECONDS_RADIUS = 187;

    let colorIndex = parseInt(localStorage.getItem('concentric_color') || '3', 10);
    let use24h = localStorage.getItem('concentric_24h') === 'true';
    let isAmbient = false;

    const images = {};
    const imageSources = {
        indexMinutes0: 'res/drawable/index_minutes_0.png',
        indexSeconds0: 'res/drawable/index_seconds_0.png',
        minuteBorder: 'res/drawable/minute_border.png',
        minuteBorderPill: 'res/drawable/minute_border_pill.png'
    };

    const offscreenCache = {};

    function loadImages(callback) {
        let loaded = 0;
        const keys = Object.keys(imageSources);
        keys.forEach((key) => {
            const img = new Image();
            img.onload = () => {
                loaded++;
                if (loaded === keys.length) callback();
            };
            img.onerror = () => {
                loaded++;
                if (loaded === keys.length) callback();
            };
            img.src = imageSources[key];
            images[key] = img;
        });
    }

    function getTintedImage(key, img, width, height, colorHex) {
        const cacheKey = `${key}_${width}_${height}_${colorHex}`;
        if (offscreenCache[cacheKey]) return offscreenCache[cacheKey];
        if (!img || !img.complete || img.naturalWidth === 0) return null;

        const off = document.createElement('canvas');
        off.width = width;
        off.height = height;
        const octx = off.getContext('2d');
        octx.drawImage(img, 0, 0, width, height);
        octx.globalCompositeOperation = 'source-in';
        octx.fillStyle = colorHex;
        octx.fillRect(0, 0, width, height);
        offscreenCache[cacheKey] = off;
        return off;
    }

    let toastTimeout = null;
    function showToast(msg) {
        if (!toastEl) return;
        toastEl.textContent = msg;
        toastEl.classList.add('visible');
        if (toastTimeout) clearTimeout(toastTimeout);
        toastTimeout = setTimeout(() => {
            toastEl.classList.remove('visible');
        }, 1200);
    }

    function pad2(n) {
        return n < 10 ? '0' + n : '' + n;
    }

    function render() {
        const now = new Date();
        const hours24 = now.getHours();
        const minutes = now.getMinutes();
        const seconds = now.getSeconds();
        const ms = now.getMilliseconds();

        const smoothSeconds = seconds + ms / 1000;
        const smoothMinutes = minutes + smoothSeconds / 60;
        const accentColor = COLORS[colorIndex % COLORS.length].hex;

        ctx.clearRect(0, 0, 450, 450);
        ctx.fillStyle = '#000000';
        ctx.fillRect(0, 0, 450, 450);

        // 1. Minutes Concentric Ring (Group x=65, y=65, w=320, h=320, scale=0.95)
        ctx.save();
        ctx.translate(225, 225);
        ctx.scale(0.95, 0.95);
        const minAngleRad = (smoothMinutes * 6 * Math.PI) / 180;
        ctx.rotate(minAngleRad);

        if (!isAmbient) {
            const minDial = getTintedImage('indexMinutes0', images.indexMinutes0, 320, 320, '#57595c');
            if (minDial) {
                ctx.drawImage(minDial, -160, -160, 320, 320);
            }
        }

        ctx.font = '24px inter_medium, sans-serif';
        ctx.fillStyle = '#999999';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';

        for (let i = 0; i < MINUTE_POSITIONS.length; i++) {
            const pos = MINUTE_POSITIONS[i];
            const dx = pos.x - 160;
            const dy = pos.y - 160;

            ctx.save();
            ctx.translate(dx, dy);
            ctx.rotate(-minAngleRad);
            ctx.fillText(pos.label, 0, 0);
            ctx.restore();
        }
        ctx.restore();

        // 2. Seconds Outer Ring (Group x=0, y=0, w=450, h=450)
        if (!isAmbient) {
            ctx.save();
            ctx.translate(225, 225);
            const secAngleRad = (smoothSeconds * 6 * Math.PI) / 180;
            ctx.rotate(secAngleRad);

            const secDial = getTintedImage('indexSeconds0', images.indexSeconds0, 450, 450, '#57595c');
            if (secDial) {
                ctx.drawImage(secDial, -225, -225, 450, 450);
            }

            ctx.font = '24px inter_medium, sans-serif';
            ctx.fillStyle = accentColor;
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';

            for (let i = 0; i < 12; i++) {
                const val = i * 5;
                const label = pad2(val);
                const itemAngle = (-i * 30 * Math.PI) / 180;
                const sx = Math.cos(itemAngle) * SECONDS_RADIUS;
                const sy = Math.sin(itemAngle) * SECONDS_RADIUS;

                ctx.save();
                ctx.translate(sx, sy);
                ctx.rotate(-secAngleRad);
                ctx.fillText(label, 0, 0);
                ctx.restore();
            }
            ctx.restore();
        }

        // 3. Mask out area behind the current Hour & Minute Pill so rotating numbers don't clash
        ctx.save();
        ctx.fillStyle = '#000000';
        ctx.beginPath();
        ctx.roundRect(155, 180, 290, 90, 45);
        ctx.fill();
        ctx.restore();

        // 4. Pill Border (Group x=150+136=286, y=175+10=185, w=164, h=80)
        const borderImgKey = isAmbient ? 'minuteBorderPill' : 'minuteBorder';
        const borderImg = getTintedImage(borderImgKey, images[borderImgKey], 164, 80, accentColor);
        if (borderImg) {
            ctx.drawImage(borderImg, 286, 185, 164, 80);
        }

        // 5. Current Minute inside Pill (x=150+145=295, y=175+20=195, w=80, h=60 -> center 335, 225)
        ctx.save();
        ctx.font = '42px inter_medium, sans-serif';
        ctx.fillStyle = '#ffffff';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(pad2(minutes), 335, 226);
        ctx.restore();

        // 6. Current Hour (x=150, y=175, w=150, h=100 -> center 225, 225)
        let displayHour = hours24;
        if (!use24h) {
            displayHour = hours24 % 12;
            if (displayHour === 0) displayHour = 12;
        }
        const hourStr = use24h ? pad2(displayHour) : '' + displayHour;

        ctx.save();
        ctx.font = '90px inter_medium, sans-serif';
        ctx.fillStyle = '#ffffff';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(hourStr, 218, 226);
        ctx.restore();

        if (!isAmbient && !document.hidden) {
            requestAnimationFrame(render);
        }
    }

    // Bezel rotation changes accent color on Galaxy Watch 3
    document.addEventListener('rotarydetent', (ev) => {
        const dir = ev.detail.direction;
        if (dir === 'CW') {
            colorIndex = (colorIndex + 1) % COLORS.length;
        } else {
            colorIndex = (colorIndex - 1 + COLORS.length) % COLORS.length;
        }
        localStorage.setItem('concentric_color', String(colorIndex));
        showToast(COLORS[colorIndex].name);
    });

    // Tap left side toggles 12/24h; tap right side cycles color
    canvas.addEventListener('click', (ev) => {
        const rect = canvas.getBoundingClientRect();
        const x = ev.clientX - rect.left;
        if (x < rect.width * 0.4) {
            use24h = !use24h;
            localStorage.setItem('concentric_24h', String(use24h));
            showToast(use24h ? 'Formato 24h' : 'Formato 12h');
        } else {
            colorIndex = (colorIndex + 1) % COLORS.length;
            localStorage.setItem('concentric_color', String(colorIndex));
            showToast(COLORS[colorIndex].name);
        }
    });

    // Tizen Ambient Mode support
    window.addEventListener('ambientmodechanged', (ev) => {
        isAmbient = ev.detail.ambientMode;
        render();
    });

    document.addEventListener('timetick', () => {
        if (isAmbient) render();
    });

    document.addEventListener('visibilitychange', () => {
        if (!document.hidden) {
            requestAnimationFrame(render);
        }
    });

    loadImages(() => {
        requestAnimationFrame(render);
    });
})();
