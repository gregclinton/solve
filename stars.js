let longitude = 0;
let latitude = 0;
let deviceEnabled = false;

function enableDevice() {
    DeviceOrientationEvent.requestPermission().then(() => {
        deviceEnabled = true;
        navigator.geolocation.getCurrentPosition(position => {
            longitude = position.coords.longitude;
            latitude = position.coords.latitude;
        })
    });
}

const svgns = "http://www.w3.org/2000/svg";

function line(e, x1, y1, x2, y2, color) {
    let line = document.createElementNS(svgns, 'line');

    line.setAttributeNS(null, 'x1', x1);
    line.setAttributeNS(null, 'y1', y1);
    line.setAttributeNS(null, 'x2', x2);
    line.setAttributeNS(null, 'y2', y2);
    line.setAttributeNS(null, 'stroke', color);
    line.setAttributeNS(null, 'stroke-width', 0.2);
    e.appendChild(line);
    return e;
}

class Scaler {
    constructor(size) {
        this.low = Number.MAX_VALUE;
        this.high = Number.MIN_VALUE;
        this.size = size;
    }

    scale(x) {
        return this.size - ((x - this.low) * this.size / (this.high - this.low));
    }

    scan(x) {
        this.low = Math.min(x, this.low);
        this.high = Math.max(x, this.high);
    }
}

class StarMap {
    constructor(csv, svg) {
        this.stars = [];

        const height = svg.getAttribute('height');
        const width = svg.getAttribute('width');

        this.raScaler = new Scaler(width);
        this.decScaler = new Scaler(height);

        for (const row of csv.trim().split('\n')) {
            const star = row.trim().split(',');
            const [ra, dec, mag, name] = star;

            this.raScaler.scan(ra);
            this.raScaler.scan(ra - 7.5); // 30 minutes advance time
            this.decScaler.scan(dec);
            this.stars.push(star);
        }

        // draw grid
        for (let minute = 0; minute < 1440; minute++) {
            let x = this.raScaler.scale(minute * 360 / 1440);

            if (x > 0 && x < width) {
                line(svg, x, 0, x, height, '#222');
            }
        }

        for (let dec = -90; dec < 90; dec++) {
            let y = this.decScaler.scale(dec);

            if (y > 0 && y < height) {
                line(svg, 0, y, width, y, dec % 5 === 0 ? '#444' : '#222');
            }
        }

        // draw meridian
        this.meridian = line(svg, 0, 0, 0, height, '#555');
        this.moveMeridian();

        // draw stars
        for (const star of this.stars) {
            let [ra, dec, mag, name] = star;
            let dot = document.createElementNS(svgns, 'circle');
            let x = this.raScaler.scale(ra);
            let y = this.decScaler.scale(dec);

            dot.setAttributeNS(null, 'cx', x);
            dot.setAttributeNS(null, 'cy', y);
            dot.setAttributeNS(null, 'r', mag < 3 ? 1 : 1);
            dot.setAttributeNS(null, 'style', 'stroke: none; fill: #' + (mag < 3 ? 'f' : mag < 5 ? 'a' : '6') + '00');
            svg.appendChild(dot);

            if (name) {
                let label = document.createElementNS(svgns, 'text');
                let text = document.createTextNode(name);

                label.setAttributeNS(null, 'fill', '#444');
                label.appendChild(text);
                label.setAttributeNS(null, 'x', x - 4);
                label.setAttributeNS(null, 'y', y - 2);
                label.setAttributeNS(null, 'font-size', 6);
                svg.appendChild(label);
            }
        }

        // update meridian
        setInterval(() => {
            this.moveMeridian();
        }, 10000);

        // create and update incline
        let interval = setInterval(() => {
            if (deviceEnabled) {
                const inclineSouth = line(svg, 0, 0, width, 0, 'blue');
                const inclineNorth = line(svg, 0, 0, width, 0, 'blue');

                window.addEventListener('deviceorientation', e => {
                    let decSouth = this.decScaler.scale(e.beta - (90 - latitude));

                    inclineSouth.setAttribute('y1', decSouth);
                    inclineSouth.setAttribute('y2', decSouth);

                    let decNorth = this.decScaler.scale(90 - Math.abs(e.beta - latitude));

                    inclineNorth.setAttribute('y1', decNorth);
                    inclineNorth.setAttribute('y2', decNorth);
                });

                clearInterval(interval);
            }
        }, 1000);

    }

    moveMeridian() {
        // http://www.jgiesen.de/astro/astroJS/siderealClock/sidClock.js

        let dt = new Date();
        let y = dt.getUTCFullYear();
        let m = dt.getUTCMonth() + 1;
        let d = dt.getUTCDate();

        if (m <= 2) {
            m += 12;
            y--;
        }

        let floor = Math.floor;
        let u = dt.getUTCHours() + dt.getUTCMinutes() / 60 + dt.getUTCSeconds() / 3600;
        let jd = floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + d - 13 -1524.5 + u / 24.0 - 2400000.5;
        let jd0 = floor(jd);
        let eph  = (jd0 - 51544.5) / 36525.0;
        let gst =  6.697374558 + 1.0027379093 * (jd - jd0) * 24.0 + (8640184.812866 + (0.093104 - 0.0000062 * eph) * eph) * eph / 3600.0;
        let x = this.raScaler.scale((gst * 15 + longitude) % 360);

        this.meridian.setAttribute('x1', x);
        this.meridian.setAttribute('x2', x);
    }
}