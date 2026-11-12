-- Fix clock_order_info so custom watchfaces are exactly 1 to 9 with no collisions
-- 1. Hide all stock watchfaces and push them to high corder
UPDATE clock_order_info SET hide=1, corder=corder+50, rorder=rorder+50 WHERE pkgid NOT IN (
    'com.samsung.watchface-noblesse-a1',
    'com.samsung.watchface-noblesse-a2',
    'com.samsung.watchface-noblesse-a5',
    'com.samsung.watchface-noblesse-u3',
    'com.samsung.watchface-noblesse-a8',
    'com.samsung.watchface-noblesse-a4',
    'com.samsung.watchface-noblesse-u6',
    'com.samsung.watchface-noblesse-a7',
    'com.samsung.watchface-noblesse-u1'
);

-- 2. Explicitly set orders 1 to 9 and hide=0 for the 9 custom watchfaces
UPDATE clock_order_info SET label='Hublot Big Bang Skeleton', iconpath='/opt/usr/media/watchface_icons/rolex_skeleton.png', rorder=1, corder=1, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-a1';
UPDATE clock_order_info SET label='ICU Pulse Animated ECG', iconpath='/opt/usr/media/watchface_icons/icu_pulse.png', rorder=2, corder=2, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-a2';
UPDATE clock_order_info SET label='Casio Classic Vintage 205 Gold', iconpath='/opt/usr/media/watchface_icons/casio_classic.png', rorder=3, corder=3, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-a5';
UPDATE clock_order_info SET label='Casio Royale WorldTime', iconpath='/opt/usr/media/watchface_icons/casio_royale.png', rorder=4, corder=4, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-u3';
UPDATE clock_order_info SET label='Pac-Man Arcade Animated', iconpath='/opt/usr/media/watchface_icons/pacman_arcade.png', rorder=5, corder=5, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-a8';
UPDATE clock_order_info SET label='Odyssey Digital OLED', iconpath='/opt/usr/media/watchface_icons/odyssey_digital.png', rorder=6, corder=6, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-a4';
UPDATE clock_order_info SET label='Concentric Pixel Watch', iconpath='/opt/usr/media/watchface_icons/concentric_pixel.png', rorder=7, corder=7, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-u6';
UPDATE clock_order_info SET label='MoveToBeActive Fitness', iconpath='/opt/usr/media/watchface_icons/movetobeactive.png', rorder=8, corder=8, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-a7';
UPDATE clock_order_info SET label='Linux Terminal Hacker', iconpath='/opt/usr/media/watchface_icons/terminal_linux.png', rorder=9, corder=9, hide=0 WHERE pkgid='com.samsung.watchface-noblesse-u1';
