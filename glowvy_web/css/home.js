import {
    drawWaves
} from './wingdings.js';

var genRandomNumber = function (min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
};

var renderCopyrightYear = function () {
    var date = new Date();
    var year = date.getYear();
    document.getElementById('copyright').innerHTML = `© ${1900 + year}`;
};

var showGenerateButtons = function () {
    document.querySelectorAll('.generate').forEach(function (btn) {
        btn.style.display = 'inline-block';
    });
};

localforage.getItem('state').then(function (stateLocal) {
    if (stateLocal) {
        if (stateLocal.network) {
            document.querySelectorAll('.personalize').forEach(function (btn) {
                btn.style.display = 'none';
            });
        } else {
            document.querySelectorAll('.generate').forEach(function (btn) {
                btn.style.display = 'none';
            });
        }
    } else {
        localforage.getItem('network_ind').then(function (net) {
            if (net) {
                showGenerateButtons();
            } else {
                document.querySelectorAll('.generate').forEach(function (btn) {
                    btn.style.display = 'none';
                });
            }
        });
    }
});

var detectmob = () => {
    if (navigator.userAgent.match(/Android/i) ||
        navigator.userAgent.match(/webOS/i) ||
        navigator.userAgent.match(/iPhone/i) ||
        navigator.userAgent.match(/iPad/i) ||
        navigator.userAgent.match(/iPod/i) ||
        navigator.userAgent.match(/BlackBerry/i) ||
        navigator.userAgent.match(/Windows Phone/i)
    ) {
        return true;
    } else {
        return false;
    }
}

renderCopyrightYear();
drawWaves('canvas');

if (detectmob()) {
    document.querySelectorAll('.personalize').forEach(function (btn) {
        btn.style.display = 'none';
    });
    document.querySelectorAll('.generate').forEach(function (btn) {
        btn.style.display = 'none';
    });
    document.querySelector('.ah-btn-group').innerHTML = 'Please visit Khroma on desktop to get stared.'
}