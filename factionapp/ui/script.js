var FrakPlayer = undefined;
var isBoss = false;

const fetchData = (action, data) => {
    if (!action || !data) return;

    const options = {
        method: "post",
        headers: {
            "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify(data),
    };

    return new Promise((resolve, reject) => {
        fetch(`https://${resourceName}/${action}`, options)
            .then((response) => response.json())
            .then(resolve)
            .catch(reject);
    });
};

window.addEventListener("load", () => {
    $("#flexplayer").html("");
    $.post(`https://${resourceName}/apploaded`, JSON.stringify({}), function(data){

        for (var i=0; i < 5000; i++) {
            if (data.data[i] != undefined) {
                $("#flexplayer").append(`
                    <div class="player" data-id="${data.data[i].source}">
                        <div class="circle active"></div>
                        <span>${data.data[i].name} (${data.data[i].grade})</span>
                        <img id="callplayer" data-id="${data.data[i].source}" data-number="${data.data[i].number}" src="icons/call.svg"/>
                        <img id="messageplayer" data-id="${data.data[i].source}" src="icons/text.svg"/>
                        <img id="promoteplayer" data-id="${data.data[i].source}" src="icons/setting.svg"/>
                    </div>
                `)
            }
        }
    
        document.getElementById("jobname").textContent = data.job;
        //document.getElementById("banking").textContent = data.banking;
        document.getElementById("jobcount").textContent = data.count;
        document.getElementById("activenotes").textContent = data.motd.message;
        document.getElementById("activenotestitle").textContent = `MOTD`;
        isBoss = data.isBoss;
    });
});


function SetContactModal(number) {
    if (!number) return;

    fetchNui('SetContactModal', number, 'lb-phone')
}
window.setContactModal = SetContactModal;

$(document).on('click', '#callplayer', function(e){
    var number = $(this).attr("data-number");
    console.log(number)
    SetContactModal(number)
});

// $(document).on('click', '#callplayer', function(e){
//     var playerId = $(this).attr("data-id");
//     const data = {
//         type: "call",
//         playerId: playerId,
//     };
//     $.post(`https://${resourceName}/callplayer`, JSON.stringify(data));
// });

$(document).on('click', '#messageplayer', function(e){
    var playerId = $(this).attr("data-id");
    SetContextMenu({
        title: "Telefon",
        buttons: [
            {
                title: "Nachricht senden",
                color: "green",
                cb: () => {
                    fetchData("messageplayer", {
                        type: "message",
                        playerId: playerId
                    })
                }
            },
        ]
    })
});


$(document).on('click', '#promoteplayer', function(e){
    if (!isBoss) { return; }
    var playerId = $(this).attr("data-id");
    SetContextMenu({
        title: "Mitarbeitermanagement",
        buttons: [
            {
                title: "Befördern",
                color: "green",
                cb: () => {
                    fetchData("handleplayer", {
                        type: "promote",
                        playerId: playerId
                    })
                }
            },
            {
                title: "Degradieren",
                color: "red",
                cb: () => {
                    fetchData("handleplayer", {
                        type: "demote",
                        playerId: playerId
                    })
                }
            },
            {
                title: "Feuern",
                color: "red",
                cb: () => {
                    fetchData("handleplayer", {
                        type: "fire",
                        playerId: playerId
                    })
                }
            }
        ]
    })
});

function saveNotes() {
    if (!isBoss) {return;}
    var message = $("#createnotes").val();
    fetchData("createmotd", {
        message: message
    })
}


