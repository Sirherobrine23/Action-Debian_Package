var exec = require('child_process').execSync;
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

console.log(REPO,user)
var gitclone = exec(`git clone ${REPO} -b ${BRANCH} --depth=1 /tmp/repo`).toString()
console.log(gitclone)

var debC = exec(`bash ${__dirname}/src/post_js.sh`).toString()
console.log(debC)