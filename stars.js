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
}

function label(e, x, y, caption) {
    let label = document.createElementNS(svgns, 'text');
    let text = document.createTextNode(caption);

    label.setAttributeNS(null, 'fill', '#444');
    label.appendChild(text);
    label.setAttributeNS(null, 'x', x);
    label.setAttributeNS(null, 'y', y);
    label.setAttributeNS(null, 'font-size', 6);
    e.appendChild(label);
}

class StarMap {
    constructor(csv, svg) {
        this.stars = [];
        this.raMin = 360;
        this.raMax = 0;
        this.decMin = 90;
        this.decMax = -90;
        this.svg = svg;
        this.height = svg.getAttribute('height');
        this.width = svg.getAttribute('width');

        for (const row of csv.trim().split('\n')) {
            const star = row.trim().split(',');
            const [ra, dec, mag, name] = star;

            this.raMin = Math.min(ra, this.raMin);
            this.raMax = Math.max(ra, this.raMax);
            this.decMin = Math.min(dec, this.decMin);
            this.decMax = Math.max(dec, this.decMax);

            this.stars.push(star);
        }

        this.raMin -= 7.5; // 30 minutes advance time

        // draw grid
        for (let minute = 0; minute < 1440; minute++) {
            let x = this.scaleRa(minute * 360 / 1440);

            if (x > 0 && x < this.width) {
                line(this.svg, x, 0, x, this.height, '#222');
            }
        }

        for (let dec = -90; dec < 90; dec++) {
            let y = this.scaleDec(dec);

            if (y > 0 && y < this.height) {
                line(this.svg, 0, y, this.width, y, dec % 5 === 0 ? '#444' : '#222');
            }
        }

        // draw meridian
        let g = document.createElementNS(svgns, 'g');

        this.svg.appendChild(g);

        line(g, 0, 0, 0, this.height, '#555');

        for (let dec = -90; dec < 90; dec++) {
            if (dec % 5 === 0) {
                let y = this.scaleDec(dec);

                if (y > 0 && y < this.height) {
                    label(g, 3, y - 3, '' + dec);
                }
            }
        }

        this.meridian = g;
        this.moveMeridian();

        // draw stars
        for (const star of this.stars) {
            let [ra, dec, mag, name] = star;
            let dot = document.createElementNS(svgns, 'circle');
            let x = this.scaleRa(ra);
            let y = this.scaleDec(dec);

            dot.setAttributeNS(null, 'cx', x);
            dot.setAttributeNS(null, 'cy', y);
            dot.setAttributeNS(null, 'r', mag < 3 ? 1 : 1);
            dot.setAttributeNS(null, 'style', 'stroke: none; fill: #' + (mag < 3 ? 'f' : mag < 5 ? 'a' : '6') + '00');
            this.svg.appendChild(dot);

            if (name) {
                label(this.svg, x - 4, y - 2, name);
            }
        }

        // update meridian
        setInterval(() => {
            this.moveMeridian();
        }, 10000);

        // create and update incline
        let interval = setInterval(() => {
            if (deviceEnabled) {
                this.inclineSouth = document.createElementNS(svgns, 'g');

                line(this.inclineSouth, 0, 0, this.width, 0, 'blue');
                this.svg.appendChild(this.inclineSouth);

                this.inclineNorth = document.createElementNS(svgns, 'g');

                line(this.inclineNorth, 0, 0, this.width, 0, 'blue');
                this.svg.appendChild(this.inclineNorth);

                window.addEventListener('deviceorientation', e => {
                    let set = (e, dec) => e.setAttribute('transform', 'translate(0 ' + this.scaleDec(dec) + ')');

                    set(this.inclineSouth, e.beta - (90 - latitude));
                    set(this.inclineNorth, 90 - Math.abs(e.beta - latitude));
                });

                clearInterval(interval);
            }
        }, 1000);

    }

    scale(x, xmin, xmax, size) {
        return size - ((x - xmin) * (size / (xmax - xmin)));
    }

    scaleRa(ra) {
        return this.scale(ra, this.raMin, this.raMax, this.width);
    }

    scaleDec(dec) {
        return this.scale(dec, this.decMin, this.decMax, this.height);
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
        let x = this.scaleRa((gst * 15 + longitude) % 360);

        this.meridian.setAttribute('transform', 'translate(' + x + ' 0)');
    }
}