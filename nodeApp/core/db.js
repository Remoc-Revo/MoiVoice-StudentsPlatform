var mysql=require('mysql');


var pool= mysql.createPool({
    host:'localhost',
    user:'moiVoice_user',
    password:'moi2021.',
    database:'moiVoiceAppDb',
    multipleStatements:true
});



module.exports={
    mysql,pool
}

