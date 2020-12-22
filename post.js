var exec = require('child_process').exec;
const core = require('@actions/core');
const github = require('@actions/github');
// 
const repo_url = core.getInput('URL');
const TOKEN = core.getInput('TOKEN');
const BRANCH = core.getInput('BRANCH');
const user = github.context.actor

if (repo_url.includes('http://')){
    var REPO = `https://${user}:${TOKEN}@${repo_url.replace('http://', '')}`
} else if (repo_url.includes('https://')){
    var REPO = `https://${user}:${TOKEN}@${repo_url.replace('https://', '')}`
} else {
    var REPO = `git://${user}:${TOKEN}@${repo_url.replace('git://', '')}`
};
var gitCLONEcommand = `git clone ${REPO} -b ${BRANCH} --depth=1 /tmp/repo`
console.log(REPO,user)
console.log(gitCLONEcommand)
var gitclone = exec(gitCLONEcommand)
gitclone.stdout.on('data', function (data) {
    console.log(data);
});
gitclone.om('exit', function (code){
    if (code == 0){
        var debC = exec(`bash ${__dirname}/src/post_js.sh`)
        debC.stdout.on('data', function (data) {
            console.log(data);
        });
    } else{
        console.log('Erro clone')
    };
})
