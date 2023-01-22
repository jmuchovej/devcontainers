#!/usr/bin/env node
import axios from "axios";
import _ from "lodash-es";
import semver from "semver";
import fs from "fs";
import { dirname } from "path";
import { fileURLToPath } from "url";
import stripJSONComments from "strip-json-comments";
import yargs from "yargs";

const __dirname = dirname(fileURLToPath(import.meta.url));

const VERSIONS = JSON.parse(stripJSONComments(
    fs.readFileSync(`${__dirname}/_sources.jsonc`, { encoding: "utf-8" })
));

const argv = yargs(process.argv.slice(2))
  .usage("Usage $0 --lang")
  .alias("l", "lang")
  .nargs("l", 1)
  .choices("l", Object.keys(VERSIONS))
  .describe("l", "A language to search DockerHub for versions of.")
  .demandOption(["l"])
  .help("h")
  .alias("h", "help")
  .argv;

const LANG = VERSIONS[argv.lang]

const DOCKERHUB_API_URL = "https://hub.docker.com/v2";

const api = axios.create({
    baseURL: DOCKERHUB_API_URL,
    timeout: 5000,
})


const getRepositoryTags = async (
    url = `/namespaces/${LANG.namespace}/repositories/${LANG.repository}/tags`
) => {
    const page = url.match(/page=(?<page>\d+)/i);
    url = url.replace(DOCKERHUB_API_URL, "").split("?")[0];
    const params = {
        page: page ? parseInt(page.groups.page) : 1,
        page_size: 100,
    }
    // * Reset the URL because we manually pass params, every time.
    const query = await api.get(url, { params })

    let results = []
    if (query.data.next) {
        results = results.concat(await getRepositoryTags(query.data.next))
    }

    if (query.data.results) {
        return results.concat(query.data.results);
    }

    return results;
}

const tags = await getRepositoryTags();

const desiredVersions =_(tags).chain()
    .filter(({ name }) => semver.satisfies(name, LANG.semver))
    .map(({ name }) => name)
    .sort((a, b) => semver.gt(a, b) ? 1 : -1)
    .map(semver.parse)
    .map((s) => Object.assign({}, s))
    .value(); 

const patchVersionMap = _(desiredVersions).chain()
    .reduce((obj, { version }) => {
        obj[`${LANG.versionPrefix}${version}`] = version;
        return obj;
    }, {}).value();

const latestMinorReleases = _(desiredVersions).chain()
    .groupBy(v => `${v.major}.${v.minor}`)
    .reduce((obj, opts, version) => {
        const latest = _.last(opts);
        obj[`${LANG.versionPrefix}${version}`] = latest.version;
        return obj;
    }, {}).value()

const latestMajorReleases = _(desiredVersions).chain()
    .groupBy(v => `${v.major}`)
    .reduce((obj, opts, version) => {
        const latest = _.last(opts);
        obj[`${LANG.versionPrefix}${latest.major}`] = latest.version;
        return obj;
    }, {}).value();

const versionMap = {
    versions: {
        ...patchVersionMap,
    },
    latestMinorReleases,
    latestMajorReleases,
    latest: _.last(desiredVersions).version,
}
try {
    fs.writeFileSync(
        `${__dirname}/${argv.lang}.json`,
        JSON.stringify(versionMap, null, 2)
    );
} catch (err) {
    console.error(err)
}
