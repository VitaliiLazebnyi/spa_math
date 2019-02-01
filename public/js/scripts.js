'use strict';

let headers = { "Content-type": "application/json" };

function submit_user(event) {
    event.preventDefault();

    let action = document.
        querySelector('input[name="action"]:checked').
        value;

    var login = document.getElementById('login-input').value;
    var password = document.getElementById('password-input').value;

    if (login) {
        document.getElementById("login-error").hidden = true;
    } else {
        document.getElementById("login-error").hidden = false;
    }


    if (password) {
        document.getElementById("password-error").hidden = true;
    } else {
        document.getElementById("password-error").hidden = false;
    }

    if (login && password){
        window[action](login, password);
    }
}

function submit_calculation(event) {
    event.preventDefault();

    var string1 = document.getElementById('string1').value;
    var string2 = document.getElementById('string2').value;

    if (string1 && !string1.split(',').some(isNaN)) {
        document.getElementById("invalid1-error").hidden = true;
    } else {
        document.getElementById("invalid1-error").hidden = false;
    }

    if (string2 && !string2.split(',').some(isNaN)) {
        document.getElementById("invalid1-error").hidden = true;
    } else {
        document.getElementById("invalid2-error").hidden = false;
    }

    if (headers["token"]) {
        document.getElementById("login-needed-error").hidden = true;
    } else {
        document.getElementById("login-needed-error").hidden = false;
    }

    if (string1 && !string1.split(',').some(isNaN) &&
        string2 && !string2.split(',').some(isNaN)){

        string1 = string1.split(',').map(Number);
        string2 = string2.split(',').map(Number);
        calculate(string1, string2);
    }
}

function calculate(s1, s2){
    const url = "/api/calculate";
    fetch(url, {
        method : "POST",
        headers: headers,

        body : JSON.stringify({data: {
                input_arrays: [s1, s2]
            }})
    }).then(
        response => response.json()
    ).then(
        result => function(result){
            if(result["data"][0][0] == "Input is invalid."){
                document.getElementById("invalid1-error").hidden = false;
            }

            if(result["data"][1][0] == "Input is invalid."){
                document.getElementById("invalid2-error").hidden = false;
            }

            if (result["data"][0][0] != "Input is invalid." &&
                result["data"][1][0] != "Input is invalid.") {

                result = "1st line result:" +
                    JSON.stringify(result["data"][0]) +
                    "<br />" +
                    "2nd line result:" +
                    JSON.stringify(result["data"][1]);
                document.getElementById("results").innerHTML = result;
            }
        }(result)
    )
}
function login(l, p) {
    const url = "/api/login";
    fetch(url, {
        method : "POST",
        headers: headers,

        body : JSON.stringify({data: {
            login : l,
            password: p
        }})
    }).then(
        response => response.json()
    ).then(
        result => function(result){
            if (result["data"]["errors"]){
                document.getElementById("login-password-error").hidden = false;
                document.getElementById("login-password-success").hidden = true;
                headers["token"] = "";
            } else {
                document.getElementById("login-password-error").hidden = true;
                document.getElementById("login-password-success").hidden = false;
                headers["token"] = result["token"];
            }

            document.getElementById("signup-success").hidden = true;
        }(result)
    )
}

function signup(l, p) {
    headers["token"] = "";
    const url = "/api/signup";
    fetch(url, {
        method : "POST",
        headers: headers,

        body : JSON.stringify({data: {
                login : l,
                password: p
            }})
    }).then(
        response => response.json()
    ).then(
        result => function(result){
            if (!result["data"]["errors"]){
                document.getElementById("login-password-error").hidden = true;
                document.getElementById("login-password-success").hidden = true;
                document.getElementById("signup-success").hidden = false;
            }
        }(result)
    )
}


