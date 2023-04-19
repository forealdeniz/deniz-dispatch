var dispatchcounter = 0

$(document).ready(() => {
    window.addEventListener('message', function (event) {
        let data = event.data;
        if (data.update == "newCall") {
            newDispatch(data.code, data.event, data.location, data.time, data.type);
        };
    });
});

$(document).ready(function() {
    // newDispatch('10-71', 'şimdi', 'Market Soygunu', 'Fleeca St.', 4000, 'urgent');
    // setTimeout(() => {
    //     newDispatch('10-71', 'şimdi', 'Banka Soygunu', 'Fleeca St.', 4000, 'normal');
    // }, 1000);
    // newDispatch('10-71', 'şimdi', 'Vezne Soygunu', 'Fleeca St.', 4000, 'urgent');
    // newDispatch('10-71', 'şimdi', 'Banka Aracı Soygunu', 'Fleeca St.', 4000, 'urgent');
    // newDispatch('10-71', 'şimdi', 'Ev Soygunu', 'Fleeca St.', 4000, 'normal');
    // newDispatch('10-71', 'şimdi', 'Ateş İhbarı', 'Fleeca St.', 4000, 'urgent');
})

function createID() {
    return Math.floor((1 + Math.random()) * 0x10000)
    .toString(16)
    .substring(1);
}

function newDispatch(code, event, location, deltime, type) {
        var uniqueid = createID();
        dispatchcounter = dispatchcounter + 1;
        let html = "";
        if (event.length > 11) {
            html += `
            <div class="dispatch2" data-number="${uniqueid}">
                <div class="dispatchcounter">#${dispatchcounter}</div>
                <div class="dispatchcode" data-number="${uniqueid}">${code} - #${dispatchcounter}</div>
                <div class="dispatchtime" style="top: -30%;">şimdi</div>
                <div class="infoall2">
                    <div class="information2">
                        <div class="infoheader">Olay Bilgisi</div>
                        <div class="infotext">${event}</div>
                    </div>
                    <div class="information2">
                        <div class="infoheader">Konum</div>
                        <div class="infotext">${location}</div>
                    </div>
                </div>
            </div>
            `;
            $(".dispatchbody").append(html);
            $('.dispatch2[data-number="' + uniqueid + '"]').addClass("animate__backInRight");
            if (type === 'urgent') {
                $('.dispatchcode[data-number="' + uniqueid + '"]').css("background-color", '#6c2b2b');
            } else {
                $('.dispatchcode[data-number="' + uniqueid + '"]').css("background-color", '#2b6c58');
            }
            var timer = deltime
            setTimeout(() => {
                $('.dispatch2[data-number="' + uniqueid + '"]').addClass("animate__backOutRight");
                setTimeout(() => {
                    $('.dispatch2[data-number="' + uniqueid + '"]').remove();
                }, 1000);
            }, timer || 5500);
        } else {
            html += `
            <div class="dispatch" data-number="${uniqueid}">
                <div class="dispatchcounter">#${dispatchcounter}</div>
                <div class="dispatchcode" data-number="${uniqueid}">${code} - #${dispatchcounter}</div>
                <div class="dispatchtime">şimdi</div>
                <div class="infoall">
                    <div class="information">
                        <div class="infoheader">Olay Bilgisi</div>
                        <div class="infotext">${event}</div>
                    </div>
                    <div class="information">
                        <div class="infoheader">Konum</div>
                        <div class="infotext">${location}</div>
                    </div>
                </div>
            </div>
            `;
            $(".dispatchbody").append(html);
            $('.dispatch[data-number="' + uniqueid + '"]').addClass("animate__backInRight");
            if (type === 'urgent') {
                $('.dispatchcode[data-number="' + uniqueid + '"]').css("background-color", '#6c2b2b');
            } else {
                $('.dispatchcode[data-number="' + uniqueid + '"]').css("background-color", '#2b6c58');
            }
            var timer = deltime
            setTimeout(() => {
                $('.dispatch[data-number="' + uniqueid + '"]').addClass("animate__backOutRight");
                setTimeout(() => {
                    $('.dispatch[data-number="' + uniqueid + '"]').remove();
                }, 1000);
            }, timer || 5500);
        }
}