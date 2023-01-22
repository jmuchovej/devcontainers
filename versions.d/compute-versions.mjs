#!/usr/bin/env node
import _ from "lodash-es";
import fs from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
import stripJSONComments from "strip-json-comments";
import nunjucks from "nunjucks";

const __dirname = dirname(fileURLToPath(import.meta.url));

const SOURCES = JSON.parse(stripJSONComments(fs.readFileSync(
  join(__dirname, "_sources.jsonc"), {
    encoding: "utf-8",
  })
));
const LANGS = _.keys(SOURCES);

// const argv = yargs(process.argv.slice(2))
//   .usage("Usage $0 --lang")
//   .alias("l", "lang")
//   .nargs("l", 1)
//   .choices("l", Object.keys(SOURCES))
//   .describe("l", "A language to search DockerHub for versions of.")
//   .demandOption(["l"])
//   .help("h")
//   .alias("h", "help")
//   .argv;

const VERSIONS = _(LANGS).chain()
  .reduce((obj, lang) => {
    const releases = JSON.parse(
      fs.readFileSync(`${__dirname}/${lang}.json`, { encoding: "utf-8" })
    );
    obj[lang] = releases;
    return obj;
  }, {})
  .value();

const loneLatestVersions = _(VERSIONS).chain()
  .map((versions, lang) => ({
    versions: { [lang]: versions.latest, },
    dockerTag: `latest-${SOURCES[lang].versionPrefix}`,
  }))
  .value();

const getVersionTypeList = (versionType) => _(LANGS)
  .chain()
  .reduce((obj, lang) => {
    const releases = VERSIONS[lang][versionType];
    obj[lang] = _.map(releases, (version, dockerTag) => ({
      versions: { [lang]: version, },
      dockerTag: dockerTag,
    }));
    return obj;
  }, {})
  .value();

// https://stackoverflow.com/a/43053803/2714651
const cartesian =
  (...a) => a.reduce((a, b) => a.flatMap(d => b.map(e => [d, e].flat())));

const getReleaseProduct = (releases) => _(releases).chain()
  .map((versions) => _.range(versions.length))
  .thru((_releases) => cartesian(..._releases))
  .map((indexes) => {
    const product = indexes.map(
      (versIdx, langIdx) => releases[LANGS[langIdx]][versIdx]
    );
    const versions = _(product)
      .chain()
      .map("versions")
      .reduce((obj, item) => ({...obj, ...item}), {})
      .value();
    const tags = _.map(product, "dockerTag").join("-")
    return { versions, dockerTag: tags, };
  })
  .value();

const majorReleases = getVersionTypeList("latestMajorReleases");
const minorReleases = getVersionTypeList("latestMinorReleases");
const allReleases = getVersionTypeList("versions");

const majorReleaseProducts = getReleaseProduct(majorReleases);
const minorReleaseProducts = getReleaseProduct(minorReleases);
const allReleaseProducts = getReleaseProduct(allReleases);

const dockerVersions = [
  {
    dockerTag: "latest",
    versions: _.reduce(LANGS, (obj, lang) => {
      obj[lang] = VERSIONS[lang].latest;
      return obj;
    }, {}),
  },
  ...loneLatestVersions,
  ...majorReleaseProducts,
  ...minorReleaseProducts,
  // ...allReleaseProducts,
];

try {
  fs.writeFileSync(
    `${__dirname}/docker-versions.json`,
    JSON.stringify(dockerVersions, null, 2)
  );
} catch (err) {
  console.error(err);
}

const Dockerfile = nunjucks.compile(fs.readFileSync(
  join(__dirname, "..", "Dockerfile.njk"),
  { encoding: "utf-8" }
));
const dockerfilePrefix = join(__dirname, "..", "docker.d");
dockerVersions.map(({ versions, dockerTag }) => {
  const renderedDockerfile = Dockerfile.render({ versions });
  const path = join(dockerfilePrefix, dockerTag);
  fs.mkdirSync(path, {
    mode: 0o775,
    recursive: true
  });
  fs.writeFileSync(join(path, "Dockerfile"), renderedDockerfile, {
    mode: 0o775,
    encoding: "utf-8"
  });
})