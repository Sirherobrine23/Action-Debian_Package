var exec = require('child_process').exec;
const core = require('@actions/core');
const github = require('@actions/github');
const simpleGit = require('simple-git');
const git = simpleGit();

const repo_url = core.getInput('URL');
const TOKEN = core.getInput('TOKEN');
const user = JSON.parse(github.context.actor)

if (repo_url.includes('http://'))
    var REPO = `https://:${TOKEN}@${repo_url.replace('http://', '')}`
else if (repo_url.includes('https://'))
    var REPO = `https://${TOKEN}@${repo_url.replace('https://', '')}`
else
var REPO = `https://${TOKEN}@${repo_url.replace('git://', '')}`

git.clone(REPO, [`/tmp/repo`/*, [options]*/])