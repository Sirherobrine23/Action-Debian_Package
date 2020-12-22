var exec = require('child_process').exec;
const core = require('@actions/core');
// TIME
const time = (new Date()).toTimeString();
core.setOutput("time", time);
// TIME
// console.log(`Process ${process.cwd()},\n Dirname ${__dirname}\n\n\n`)
var command = `cd ${__dirname}/src/ && chmod 777 repo.sh && ./repo.sh`
var serverstated = exec(command, {
    detached: false,
    shell: true,
    maxBuffer: Infinity});
function logoutpu(dados){
    console.log(dados)
}
serverstated.stdout.on('data', function (data) {
    logoutpu(data)
});
serverstated.on('exit', function (code) {
    if (code == 0) {
        let nuLLL = '';
    } else {
        core.setFailed('Error code: ' + code);
    }
});
